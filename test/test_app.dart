import 'package:flutter/material.dart';
import '../lib/slim.dart';

class TestApp extends StatelessWidget {
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
        supportedLocales: SlimLocalizations.supportedLocales
          ..addAll([Locale('en', 'US')]),
      ),
    );
  }
}

class User extends SlimAppStateObject {
  String userName;
  String password;

  @override
  void onAppStateChanged(AppLifecycleState state) {
    print(state);
    print("user");
  }
}

class LoginService extends SlimApi {
  LoginService() : super("http://myserver.com/api");

  Future<SlimResponse> login(User user) =>
      post("login", {"userName": user.userName, "password": user.password});

  Future<SlimResponse> logout(User user) =>
      post("logout", {"userName": user.userName});
}

class LoginBloc extends SlimAppStateObject {
  badLogin(User user) async {
    closeKeyboard();
    final loginService = context.slim<LoginService>();
    showWidget(CircularProgressIndicator(), dismissible: false);
    final result = await loginService.login(user);
    forceClearOverlay();
    if (result.success)
      Home().pushReplacement(context);
    else
      context.showOverlay(
        context.translate("badcreds"),
        backgroundColor: Colors.red,
      );
  }

  @override
  void onAppStateChanged(AppLifecycleState state) {
    print(state);
    print("login bloc");
  }

  goodLogin(User user) async {
    closeKeyboard();
    final loginService = context.slim<LoginService>();
    showWidget(CircularProgressIndicator(), dismissible: false);
    await loginService.login(user);
    forceClearOverlay();
    Home().pushReplacement(context);
  }
}

Key userKey = Key("user");
Key goodLoginKey = Key("goodLogin");
Key passwordKey = Key("password");

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SlimBuilder<LoginBloc>(
      builder: (loginBloc) {
        final user = context.slim<User>();
        return Scaffold(
          backgroundColor: Colors.white,
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
                        key: userKey,
                        decoration: InputDecoration(
                          hintText: "Username",
                          alignLabelWithHint: true,
                        ),
                        initialValue: user.userName,
                        onChanged: (value) => user.userName = value,
                      ),
                      TextFormField(
                        key: passwordKey,
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
                            key: goodLoginKey,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text("${context.translate("hi")} ${user.userName}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
