import 'package:flutter/material.dart';
import 'package:slim/slim.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return [
      Slimer<User>(User()),
      Slimer<LoginService>(LoginService()),
      Slimer<LoginController>(LoginController()),
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
        supportedLocales: SlimLocalizations.supportedLocales
          ..addAll([Locale('en', 'US')]),
      ),
    );
  }
}

class User {
  String userName;
  String password;
}

class LoginService extends SlimApi {
  LoginService() : super("http://myserver.com/api");

  Future<SlimResponse> login(User user) =>
      post("login", {"userName": user.userName, "password": user.password});

  Future<SlimResponse> logout(User user) =>
      post("logout", {"userName": user.userName});
}

class LoginController extends SlimController {
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

class Login extends SlimWidget<LoginController> {
  @override
  Widget slimBuild(BuildContext context, LoginController controller) {
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        onPressed: () => controller.badLogin(user),
                        color: Colors.pink,
                      ),
                      FlatButton(
                        child: Text(context.translate("goodlogin")),
                        onPressed: () => controller.goodLogin(user),
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
