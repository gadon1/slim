import 'package:flutter/material.dart';
import 'package:slim/slim.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    SlimLocalizations.supportedLocales = [Locale('en', 'US')];
  }

  @override
  Widget build(BuildContext context) {
    return [
      Slimer<User>(User()),
      Slimer<LoginService>(LoginService()),
      Slimer<LoginBloc>(LoginBloc()),
    ].slim(
      child: MaterialApp(
        builder: SlimMaterialAppBuilder.builder,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Login(),
        localizationsDelegates: SlimLocalizations.delegates,
        supportedLocales: SlimLocalizations.supportedLocales,
      ),
    );
  }
}

class User {
  String userName;
  String password;
}

class LoginService extends RestApi {
  LoginService() : super("http://myserver.com/api");

  Future<RestApiResponse> login(User user) =>
      post("login", {"userName": user.userName, "password": user.password});

  Future<RestApiResponse> logout(User user) =>
      post("logout", {"userName": user.userName});
}

class LoginBloc extends SlimController {
  badLogin(User user) async {
    final loginService = slim<LoginService>();
    showWidget(CircularProgressIndicator(), dismissible: false);
    final result = await loginService.login(user);
    forceClearOverlay();
    if (result.success)
      Home().pushReplacement(context);
    else
      context.showSnackBar(
        context.translate("badcreds"),
        backgroundColor: Colors.red,
      );
  }

  goodLogin(User user) async {
    final loginService = slim<LoginService>();
    showWidget(CircularProgressIndicator(), dismissible: false);
    await loginService.login(user);
    forceClearOverlay();
    Home().pushReplacement(context);
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SlimBuilder<LoginBloc>(
      builder: (loginBloc) {
        final user = context.slim<User>();
        return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Container(
              width: context.width * 0.8,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        context.translate("loginform"),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Username",
                          alignLabelWithHint: true,
                        ),
                        initialValue: user.userName,
                        onChanged: (value) => user.userName = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Password",
                          alignLabelWithHint: true,
                        ),
                        initialValue: user.password,
                        onChanged: (value) => user.password = value,
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Text(context.translate("badlogin")),
                            onPressed: () => loginBloc.badLogin(user),
                            color: Colors.pink,
                          ),
                          FlatButton(
                            child: Text(context.translate("goodlogin")),
                            onPressed: () => loginBloc.goodLogin(user),
                            color: Colors.green,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SlimBuilder<User>(
      builder: (user) => Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Text("${context.translate("hi")} ${user.userName}"),
        ),
      ),
    );
  }
}
