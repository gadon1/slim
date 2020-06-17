<img src="https://raw.githubusercontent.com/gadon1/slim/master/slim.png" alt="" width="50"/>

# slim - app essentials

**slim** was written to give some app essentials and capabilities that are common for most apps.
**slim** makes it easier to set up app infrastructure so you can start working on your screens and logic.

- Localizations
- UI Messages
- State Management
- AppLifecycleState Events
- Useful Extensions
- Rest Api

## Configurations

Easy app level configuration that gives 'ready to use' localization and UI messages.

1. **App class constructor**
   This is the place to set your supported locales and if you want also set your own `SlimLocaleLoader`
   The default `SlimLocaleLoader` will load you locale files from - assets/locales/ so make sure you created folder and files matching your supported locales
   and add it to pubspec.yaml file.

2. **MaterialApp builder**
   Add the `SlimMaterialAppBuilder.builder` to it. If you have additional builders just chain them.
   `SlimMaterialAppBuilder.builder` gives you the UI messages caps.

3. **MaterialApp localizationsDelegates**
   Set to `SlimLocalizations.delegates`
   That will support all delegates needed including the `SlimLocalizations.slimLocaleLoader` delegate.
4. **MaterialApp supportedLocales**
   Set to `SlimLocalizations.supportedLocales` you configured in **App class constructor**.

_The following example will load simple json locale configurations from - assets/locales/en.json_

```dart
import 'package:slim/slim.dart';

class MyApp extends StatelessWidget{
	MyApp(){
		SlimLocalizations.supportedLocales = [Locale('en', 'US')];
		/// If you want to customize you locale loader just create class that extends SlimLocaleLoader and change:
    ///
		/// SlimLocalizations.slimLocaleLoader= YouCustomLocalLoader();
	}

	@override
	Widget build(BuildContext context) =>
		   MaterialApp(
				builder: SlimMaterialAppBuilder.builder,
				title: 'Flutter Demo',
				theme: ThemeData(
				primarySwatch: Colors.blue,
				visualDensity: VisualDensity.adaptivePlatformDensity,
				),
				home: MyHomePage("First Screen"),
				localizationsDelegates: SlimLocalizations.delegates,
				supportedLocales: SlimLocalizations.supportedLocales,
			);
}
```

## Localization

**UI direction**\
The **confgurations** above will make your UI ltr/rtl automatically according to os locale.
You can use `BuildContext` extension method to get your locale text direction `context.textDirection`

**Translation**\
If you didn't provide any custom `SlimLocaleLoader` , Your localization would be configured with a default one. The default `SlimLocaleLoader` expects locale files to be in _- assets/locales/_ folder with name convention of your locale. for example _- assets/locales/en.json_.
The default locale file format is a single level json that holds you translation. You can extends `SlimLocaleLoader` to your own.

```json
{
  "welcome": "translation of 'welcome' key"
}
```

Access to translation of a key gained by `BuildContext` extension method called translate.

```dart
@override
Widget build(BuildContext context) => Text(context.translate('welcome'));
```

## UI Messages

UI Messages caps are available via `BuildContext` extension methods. Since `SlimController` accessed by `SlimBuilder` has an access to current context, these caps are also available inside it. That will be explained in the **State Management** section below.
You can display overlay with your own widget, text message and a snackbar.

```dart
showWidget(Widget widget, {bool dissmisble = true, Color overlayColor = Colors.black,double overlayOpacity = .6})

showOverlay(String message,{Color backgroundColor = Colors.black,
bool dissmisble = true,textStyle = const  TextStyle(color: Colors.white), Color overlayColor = Colors.black,double overlayOpacity = .6});

showSnackBar(String message,{Color messageBackgroundColor = Colors.black,
messageTextStyle = const  TextStyle(color: Colors.white)});
```

You can use each one of the above via `BuildContext` extension methods. for example:

```dart
@override
Widget build(BuildContext context) => Column(children:[
		 FlatButton(
			 child:Text('show message'),
			 onPressed:() => context.showOverlay("some text"),
		),
		FlatButton(
			 child:Text('show snack bar'),
			 onPressed:() => context.showSnackBar("some text"),
		),
		FlatButton(
			 child:Text('show widget'),
			 onPressed:() => context.showWidget(
                 Container(
				    height: 100,
					widgth: 100,
					color: Colors.black
				),
            ),
		),
	],
);
```

For text overlay and snackbar you can set the background color and text style.\
For overlay of text or widget you can specify if dismissible.

## State Management

**slim** provides state management based on [InhertiedNotifier](https://api.flutter.dev/flutter/widgets/InheritedNotifier-class.html) and [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) classes.
The concept is that you keep an object at the top of the tree or sub tree of children that might access it.
The state object can be a widget state object, data object, business object or whatever you want it to be.
You can even use it for passing parameters between screens, so it can be a String, int or even an enum.
This is the one of the powerful concepts of **slim** state management - it can be any state and not limited for a widget state.

Before you go over below examples, excluding the case of parameter passing between screens, the most recommended state object is the **`SlimController`** and recommended way to access it is via **`SlimBuilder`** widget.  
By using the `SlimController` from one side and `SlimBuilder` on the other, you get the best of three worlds:

1. Widget state control - you can make the wrapped widget to rebuild by calling `updateUI` method.
   Since `SlimController` based on `ChangeNotifier` it will cause **all** widgets that referenced it to rebuild.
   That is great but considered to be a `ChangeNotifier` disadvantage in case you only want to rebuild the current widget. For that you can pass the current flag and decide when you want to globaly or localy update the UI.

   `updateUI({bool current = false})`

2. Global & Local shared objects/values - you can make any object/values shared between your app screens.
   Global - put your object/value at the top of your app tree by wrapping the material app widget.
   Local - put your object/value at the top of a sub tree. That way you can share objects for a local tree or pass
   parameters between screens.

3. Separate & not disconnected business logic - The `SlimController` accessed by `SlimBuilder` allows you to separate the business from UI but gives access to current context. That gives you that ability to combine navigation flows and use the UI messages inside your business class.

**SlimController**\
abstract class that can be used for state management or logic, inherits from [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) and gives you widget rebuild options:\
`T slim<slim>()` - access to ancestor slims
`updateUI({bool current = false})` - will refresh the state of all / current widgets that reference it (current update flag workd only if you access it via [SlimBuilder] widget).\
`closeKeyBoard()` - close keyboard by requesting focuse
The `SlimController` has context propery to access the current context so you can use context extensions from inside a business login class interacting with UI:\
`showOverlay` - display overlay text message\
`showWidget` - display overlay widget\
`showSnackBar` - display snackbar with given text\
`clearOverlay` - clears overlays\
`forceClearOverlay` - clears overlays even if not dismissible

For overlay message and snackbar you can set background color, text style, overlay color and overlay opacity.\
For overlay message and widget you can set dismissible flag.

**SlimAppStateController**\
abstract class that inherits from `SlimController` and recieves AppLifecycleState events. the events change recieves only if the SlimAppStateController
is accessed in the current app's screen. SlimAppStateController force to override its `void onAppStateChanged(AppLifecycleState state)` method.

**`SlimAppStateController` must be access via `SlimBuilder`, `SlimController` access via `SlimBuilder` is optional but recommended**
\
\
**Putting Slims in the tree**\
For the following example we will use a simple Counter class:

```dart
class Counter extends SlimController{
	int value=0;
	inc(){
		value++;
	}
}
```

SingleSlim:

```dart
Slim<Counter>(child:someWidget,stateObject:Counter());
```

SingleSlim with a Slimer:

```dart
Slimer<Counter>(Counter()).slim(someWidget);
```

MultiSlim with slimers:

```dart
MultiSlim(child:someWidget,slimers:[Slimer<Counter>(Counter())]);
```

MultiSlim via `List<Slimer>` extension method:

```dart
[Slimer<Counter>(Counter())].slim(child:someWidget);
```

**Access slim objects in the tree**

SlimBuilder - allows `updateUI(current:true)`

```dart
@override
Widget build(BuildContext context){
	return SlimBuilder<Counter>(
    [instance: optional local instance of Counter if you dont want to pre put it on tree]
		builder:(counter){
			...
			return someWidget;
		}
	);
}
```

Simple Access - without `updateUI(current:true)` support

```dart
@override
Widget build(BuildContext context){
	final counter = Slim.of<Counter>(context);
	...
	return someWidget;
}
```

```dart
@override
Widget build(BuildContext context){
	final counter = context.slim<Counter>();
	...
	return someWidget;
}
```

## Useful Extensions

**slim** provides some useful extension methods for several classes (some of them mentioned previously).
The full extension methods list is:

**`String`**\
`bool isNullOrEmpty`\
`bool isNotNullOrEmpty`\
`String format(List<dynamic> variables)`

**`BuildContext`**\
`bool hasOverlay` - true if any overlay currently displayed\
`void clearOverlay()` - clears current overlay message if dismissible\
`void forceClearOverlay()` - clears current overlay message even if not dismissible\
`void showWidget(Widget widget, {bool dismissible = true})`

```
void  showOverlay(String message,{Color backgroundColor = Colors.black,
bool dismissible = true,messageTextStyle = const  TextStyle(color: Colors.white), Color overlayColor = Colors.black, double overlayOpacity = .6})
```

```
void  showSnackBar(String message,{Color backgroundColor = Colors.black,
messageTextStyle = const  TextStyle(color: Colors.white), Color overlayColor = Colors.black, double overlayOpacity = .6})
```

`T slim<T>()` - access a state object of type T\
`double width` - media query width\
`double height` - media query height\
`NavigatorState navigator` - navigator state\
`void pop<T>({T result})` - navigator pop\
`Future<T> push<T>(Route<T> route)` - navigator push\
`Future<T> pushReplacement<T>(Route<T> route)` - navigator pushReplacement\
`void popTop()` - navigator pop till can't pop anymore\
`String translate(String key,[String group])` - locale translation of key\
`TextDirection textDirection` - current locale text direction\
`void closeKeyboard()` - request focuse

**`Widget`**\
`Future<T> push<T>(BuildContext context)` - navigator push\
`Future<T> pushReplacement<T>(BuildContext context)` - navigator pushReplacement\
`Future<T> pushTop<T>(BuildContext context)` - push at navigators most top

**`int`**\
`Duration get seconds` - get in seconds\
`Duration get hours` - get in hours\
`Duration get days` - get in days\
`Duration get minutes` - get in minutes\
`Duration get milliseconds` - get in milliseconds\
`Duration get microseconds` - get in microseconds\
`DateTime get nowMinutesInterval` - get current time with minutes round up to interval

## RestApi

**`SlimApi`** is an abstract class that gives you rest (get, delete, post, put) methods for fast service writing.\
The `SlimApi` class constructor gets the server url, and its methods gets the service url and some additional data.\
`SlimApi` class has a `createHeaders` method that can be overriden.\
`SlimApi` methods wrapped in try/catch clause and returns `SlimResponse` object.

```dart
class SlimResponse {
  bool get success => statusCode == 200 || statusCode == 201;
  int statusCode;
  String body;
  String exception;
  RestApiMethod method;
  String url;
  int milliseconds;
  String get error => body.isNullOrEmpty ? exception : body;

  SlimResponse(this.url, this.method, this.statusCode, this.milliseconds);

  @override
  String toString() => "$method [$statusCode] [$error] ${milliseconds}ms";
}
```

Exapmle for a login service:

```dart

class LoginService extends SlimApi {
  LoginService() : super("http://myserver.com/api");

  /// POST http://myserver.com/api/login
  Future<SlimResponse> login(User user) =>
      post("login", {"userName": user.userName, "password": user.password});

  /// POST http://myserver.com/api/logout
  Future<SlimResponse> logout(User user) =>
      post("logout", {"userName": user.userName});
}

```

## Full Example

This final section describes a full example that combines most of **slim** app essentials package.\
All of **slim** usage is remarked.

```dart
import 'package:slim/slim.dart';
```

1. locale json file _- assets/locales/en.json_

```json
{
  "hi": "Hello",
  "badlogin": "Bad Login",
  "goodlogin": "Ok Login",
  "badcreds": "invalid username or password",
  "loginform": "Login"
}
```

2. User class

```dart
class User{
    String userName;
    String password;
}
```

3. LoginService class

```dart
/// Extends SlimApi class
class LoginService extends SlimApi {
  LoginService() : super("http://myserver.com/api");

  Future<SlimResponse> login(User user) =>
      post("login", {"userName": user.userName, "password": user.password});

  Future<SlimResponse> logout(User user) =>
      post("logout", {"userName": user.userName});
}
```

4. LoginBloc class - Business logic

```dart
/// Extends slim SlimController class
class LoginBloc extends SlimController {
  badLogin(User user) async {
    /// Access login service via slim
    final loginService = slim<LoginService>();
    /// Using context access to display loading indicator
    showWidget(CircularProgressIndicator(), dismissible:false);
    final result = await loginService.login(user);
    /// Using context access to clear loading indicator
    forceClearOverlay();
    /// Checking slim RestApiResult for success
    if (result.success)
      /// Using slim widget extension method to replace current screen to Home widget
      Home().pushReplacement(context);
    else
      /// Using context access to show a snackbar and locale translation
      showSnackBar(context.translate("badcreds"), backgroundColor: Colors.red);
  }

  goodLogin(User user) async {
    /// Access login service via slim
    final loginService = slim<LoginService>();
    /// Close keyboard
    closeKeyboard();
    /// Using context access to display loading indicator
    showWidget(CircularProgressIndicator(), dismissible:false);
    await loginService.login(user);
    //Using context access to clear loading indicator
    forceClearOverlay();
    /// Using slim widget extension method to replace current screen to Home widget
    Home().pushReplacement(context);
  }
}
```

5. App Configurations

```dart
class MyApp extends StatelessWidget {
  MyApp() {
    /// Set slim supported locales
    SlimLocalizations.supportedLocales = [Locale('en', 'US')];
  }

  @override
  Widget build(BuildContext context) {
    return [
      /// Putting single instance of Userat the top of the tree
      Slimer<User>(User()),
      /// Putting single instance of LoginService at the top of the tree
      Slimer<LoginService>(LoginService()),
      /// Putting single instance of LoginBloc at the top of the tree
      Slimer<LoginBloc>(LoginBloc()),
    ].slim(
      child: MaterialApp(
        /// Configure material app builder for slim UI messages support
        builder: SlimMaterialAppBuilder.builder,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Login(),
        /// Configure slim localizations delegates
        localizationsDelegates: SlimLocalizations.delegates,
        /// Configure slim localizations supported locales
        supportedLocales: SlimLocalizations.supportedLocales,
      ),
    );
  }
}
```

6. Login screen

```dart
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Using slim builder to access login bloc instance
    return SlimBuilder<LoginBloc>(
      builder: (loginBloc) {
        /// Simple slim access to user instance
        final user = context.slim<User>();
        return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Container(
              /// BuildContext extension method context.width = MediaQuery.of(context).size.width
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
                        /// slim locale translation
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
                            /// slim locale translation
                            child: Text(context.translate("badlogin")),
                            /// Using the bloc
                            onPressed: () => loginBloc.badLogin(user),
                            color: Colors.pink,
                          ),
                          FlatButton(
                            /// slim locale translation
                            child: Text(context.translate("goodlogin")),
                            /// Using the bloc
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
```

7. Home screen

```dart
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Using slim builder to access user instance
    return SlimBuilder<User>(
      builder: (user) => Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          /// Using slim locale translation and user instance
          child: Text("${context.translate("hi")} ${user.userName}"),
        ),
      ),
    );
  }
}
```

**The Example available in example tab and git.**

**Would love to get comments & suggestions.**

**Enjoy !**
