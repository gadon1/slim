# slim - app essentials

**slim** was written to give some app essentials and capabilities that are common for most apps.
**slim** makes it easier to set up app infrastructure so you can start working on your screens and logic.

- Localizations
- UI Messages
- State Management
- Useful Extensions
- Rest Api

## Configurations

Easy app level configuration will gives you 'ready to use' localization and UI messages.

1. **App class constructor**
   This is the place to set your supported locales and if you want also set your own `SlimLocaleLoader`
   The default slimLocaleLoader will load you locale files from - assets/locales/ so make sure you created folder and files matching to you supported locales.

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
		//if you want to customize you locale loader just create
		//class that extends SlimLocaleLoader and change:
		//SlimLocalizations.slimLocaleLoader= YouCustomLocalLoader();
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

**UI direction**
The **confgurations** above will make your UI ltr/rtl automatically according os locale.
You can use a `BuildContext` extension method to get your locale text direction `context.textDirection`

**Translation**
If you didn't provide any custom `SlimLocaleLoader` , Your localization would be configured with a default one. The default `SlimLocaleLoader` expects locale files to be in _- assets/locales/_ folder with name convention of your locale, for example _- assets/locales/en.json_.
The default locale file format is a single level json that holds you translation.

```json
{
  "welcome": "translation of 'welcome' key"
}
```

Access translation of a key gained by `BuildContext` extension method called translate.

```dart
@override
Widget build(BuildContext context) => Text(context.translate('welcome'));
```

## UI Messages

UI Messages caps are available through `BuildContext` extension methods or inside `SlimObject` that will be explained in the **State Management** section below.
You can display overlay with your own widget or a text message and a snackbar.

```dart
showWidget(Widget widget, {bool dissmiable = true})

showOverlay(String message,{Color messageBackgroundColor = Colors.black,
bool dissmisable = true,messageTextStyle = const  TextStyle(color: Colors.white)});

showSnackBar(String message,{Color messageBackgroundColor = Colors.black,
messageTextStyle = const  TextStyle(color: Colors.white)});
```

You can use each one of the above via `BuildContext`. for example:

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

For text of overlay and snackbar you can set the background color and text style.
For overlay text or widget you can specify if dismissable

## State Management

**slim** provides state management based on [InhertiedNotifier](https://api.flutter.dev/flutter/widgets/InheritedNotifier-class.html) and [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) classes.
The concept is that you keep an object at the top of the tree or sub tree of children that might access it.
The object can be a state object, data object, business object or whatever you want it to be.
You can even use it for passing parameters between screens, so it can be a String, int or some kind of an enum.
This is the on of the powerful concepts of **slim** state management - it can be any state and not limited for a widget state.

Before you go over below examples, if we exclude the case for local parameter passing between screens the most recommended state object is the **`SlimObject`** and recommended access to it is the **`SlimBuilder`** widget.  
By using the `SlimObject` from one side and access it with a `SlimBuilder` you get the best of three worlds:

1. Widget state control - you can make the wrapped widget to rebuild by calling `updateUI` method.
   Since `SlimObject` based on `ChangeNotifier` it will cause all widgets that referenced it to rebuild.
   That is great but considered to be a `ChangeNotifier` disadvantage in case you only want to make the current widget to rebuild. for that you can pass the current flag and decide when you want to globally or
   localy update the UI.

   `updateUI({bool current = false})`

2. Global & Local shared objects/values - you can make any object/values shared between your app screens.
   Global - put your object/value at the top of your app tree by wrapping the material app widget.
   Local - put your object/value at the top of a sub tree. That way you can share objects for a local tree or pass
   parameters between screens.
3. Separate business logic class that relates to UI - The `SlimObject` allows you to separate the business from UI but gives you powerful features that you can combine as part of you business logic.

   - UI Rebuild
   - UI Messages - `SlimObject` contains the `showOverlay`,`showWidget` and `showSnckBar` methods explained in the UI Messages section.
   - Current context access
   - Combine Navigation logic - You can use the widget extension method to navigate to different screen

   By using the **`SlimObject` & `SlimBuilder`** approach you can easily see what you business logic does, including navigation flow.

**SlimObject**
abstract class that can be used for state management or logic, inherits from [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) and gives you widget rebuild options:
`updateUI({bool current = false})` - will refresh the state of all / current widgets that reference it.
also `SlimObject` has context propery for current context so you can access context extensions from inside a business login class interacting with UI:
`context.showOverlay` - display overlay text message
`context.showWidget` - display overlay widget
`context.showSnackBar` - display snackbar with given text
`context.clearMessage` - clears overlays

for overlay message and snackbar can set background color and text style.
for overlay message and widget you can set dismissable flag.
\
\
**Putting objects in the tree**
For the example will use a simple Counter class:

```dart
class Counter extends SlimObject{
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

SlimBuilder - allows for `updateUI(current:true)`

```dart
@override
Widget build(BuildContext context){
	return SlimBuilder<Counter>(
		builder:(counter){
			...
			return someWidget;
		}
	);
}
```

Simple Access - can't do `updateUI(current:true)`

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

\

## Useful Extensions

**slim** provides some useful extension methods for several classes (some of them mentioned previously).
The full extension methods are:

**`String`**\
`bool isNullOrEmpty`\
`bool isNotNullOrEmpty`

**`BuildContext`**\
`bool hasMessage` - true if any overlay currently displayed\
`void clearMessage()` - clears current overlay message if dismissable\
`void forceClearMessage()` - clears current overlay message even if not dismissable\
`void showWidget(Widget widget, {bool dismissable = true})`

```
void  showOverlay(String message,{Color messageBackgroundColor = Colors.black,
bool dismissable = true,messageTextStyle = const  TextStyle(color: Colors.white)})
```

```
void  showSnackBar(String message,{Color messageBackgroundColor = Colors.black,
messageTextStyle = const  TextStyle(color: Colors.white)})
```

`T slim<T>()` - access a state object of type T\
`double width` - media query width\
`double height` - media query height\
`NavigatorState navigator` - navigator state\
`void pop<T>({T result})` - navigator pop\
`Future<T> push<T>(Route<T> route)` - navigator push\
`Future<T> pushReplacement<T>(Route<T> route)` - navigator pushReplacement\
`void popTop()` - navigator pop till can't pop anymore\
`String translate(String key)` - locale translation of key\
`TextDirection textDirection` - current locale text direction

**`Widget`**\
`Future<T> push<T>(BuildContext context)` - navigator push\
`Future<T> pushReplacement<T>(BuildContext context)` - navigator pushReplacement\
`Future<T> pushTop<T>(BuildContext context)` - push at navigators most top

## RestApi

**`RestApi`** is an abstract class gives you get, delete, post, put methods for fast service writing. The `RestApi` class constructors gets the server url,
and its methods gets the service url and some additional data.
`RestApi` class has also a createHeaders methods that can be overriden.
`RestApi` methods wrapped in try/catch clause and returns `RestApiResult` object.

```dart
class RestApiResult {
  bool get success => statusCode == 200 || statusCode == 201;
  int statusCode;
  String body;
  String exception;
  RestApiMethod method;
  String url;
  int milliseconds;
  String get error => body.isNullOrEmpty ? exception : body;

  RestApiResult(this.url, this.method, this.statusCode, this.milliseconds);

  @override
  String toString() => "$method [$statusCode] [$error] ${milliseconds}ms";
}
```

exapmle for login service:

```dart

class LoginService extends RestApi {
  LoginService() : super("http://myserver.com/api");

  //POST http://myserver.com/api/login
  Future<RestApiResult> login(User user) =>
      post("login", {"userName": user.userName, "password": user.password});

  //POST http://myserver.com/api/logout
  Future<RestApiResult> logout(User user) =>
      post("logout", {"userName": user.userName});
}

```

## Full Example

In this final section i'll describe quick sample that combines most of the **slim** app essentials package.
All of **slim** usage has remarks.

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
class LoginService extends RestApi { //extends slim RestApi class
  LoginService() : super("http://myserver.com/api");

  Future<RestApiResult> login(User user) =>
      post("login", {"userName": user.userName, "password": user.password});

  Future<RestApiResult> logout(User user) =>
      post("logout", {"userName": user.userName});
}
```

4. LoginBloc class - Business logic

```dart
class LoginBloc extends SlimObject { //extends slim SlimObject class
  badLogin(User user) async {
    final loginService = context.slim<LoginService>(); //access login service via slim
    context.showWidget(CircularProgressIndicator()); //using context access to display loading indicator
    final result = await loginService.login(user);
    context.clearMessage(); //using context access to clear loading indicator
    if (result.success) //checking slim RestApiResult for success
      Home().pushReplacement(context); //using slim widget extension method to replace current screen to Home widget
    else
      context.showSnackBar(context.translate("badcreds"), //using context access to show a snackbar and locale translation
          messageBackgroundColor: Colors.red);
  }

  goodLogin(User user) async {
    final loginService = context.slim<LoginService>(); //access login service via slim
    context.showWidget(CircularProgressIndicator()); //using context access to display loading indicator
    await loginService.login(user);
    context.clearMessage(); //using context access to clear loading indicator
    Home().pushReplacement(context); //using slim widget extension method to replace current screen to Home widget
  }
}
```

5. App Configurations

```dart
class MyApp extends StatelessWidget {
  MyApp() {
    SlimLocalizations.supportedLocales = [Locale('en', 'US')]; //set slim supported locales
  }

  @override
  Widget build(BuildContext context) {
    return [
      Slimer<User>(User()), //putting single instance of Userat the top of the tree
      Slimer<LoginService>(LoginService()),   //putting single instance of LoginService at the top of the tree
      Slimer<LoginBloc>(LoginBloc()), //putting single instance of LoginBloc at the top of the tree
    ].slim(
      child: MaterialApp(
        builder: SlimMaterialAppBuilder.builder, //configure material app builder for slim UI messages support
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Login(),
        localizationsDelegates: SlimLocalizations.delegates,  //configure slim localizations delegates
        supportedLocales: SlimLocalizations.supportedLocales, //configure slim localizations supported locales
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
    return SlimBuilder<LoginBloc>( //using slim builder to access login bloc instance
      builder: (loginBloc) {
        final user = context.slim<User>(); //simple slim access to user instance
        return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Container(
              width: context.width * 0.8, //BuildContext extension method context.width = MediaQuery.of(context).size.width
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        context.translate("loginform"), //slim locale translation
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
                            child: Text(context.translate("badlogin")), //slim locale translation
                            onPressed: () => loginBloc.badLogin(user), //using the bloc
                            color: Colors.pink,
                          ),
                          FlatButton(
                            child: Text(context.translate("goodlogin")), //slim locale translation
                            onPressed: () => loginBloc.goodLogin(user), //using the bloc
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
    return SlimBuilder<User>( //using slim builder to access user instance
      builder: (user) => Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Text("${context.translate("hi")} ${user.userName}"), //using slim locale translation and user instance
        ),
      ),
    );
  }
}
```

\*\*Example above is available in example tab and git.
\
Comments & suggestions are most welcome.
\
Enjoy !\*\*
