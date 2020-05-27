import 'package:flutter/material.dart';
import 'package:slim/slim.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

//slim object for state management +
class Counter extends SlimObject {
  int value = 0;
  inc() {
    value++;
    updateUI(); //update state
  }

  //show overlay with widget in center of screen
  testWidget() => showWidget(Container(
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Center(child: Text("value is: $value")),
      ));

  //show overlay with Text in center of screen
  testOverlay() =>
      showOverlay("value is: $value", messageBackgroundColor: Colors.red);

  //show snackbar with text
  testSnack() =>
      showSnackBar("value is: $value", messageBackgroundColor: Colors.red);
}

class MyApp extends StatelessWidget {
  MyApp() {
    //set up supported locales
    SlimLocalizations.supportedLocales = [
      const Locale('en', 'US'),
      const Locale('he', 'IL'),
    ];

    //you can create custom slim localizations
    //SlimLocalizations.slimLocaleLoader = CustomSlimLocalizations();
  }

  @override
  Widget build(BuildContext context) {
    return [Slimer<Counter>(Counter())].slim(
        //putting state/bloc objects in the tree using extensions, there are more then one way putting it there
        child: MaterialApp(
      builder: SlimMaterialAppBuilder
          .builder, //to support slim messages for SlimObject
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates:
          SlimLocalizations.delegates, //set localizations delegates
      supportedLocales:
          SlimLocalizations.supportedLocales, //set supported locales
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(context.translate("hi")),
              Text(
                'You have pushed the button this many times:',
              ),
              SlimBuilder<Counter>(
                //local access (just for eample) for counter up the tree - you can wrap the scaffold with the slim builder instead

                builder: (cnt) => Text(
                  '${cnt.value}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              FlatButton(
                child: Text("next page"),
                onPressed: () => MyHomePage(title: "Hi").push(context),
                color: Colors.blue,
              ),
              SlimBuilder<Counter>(
                builder: (cnt) => FlatButton(
                  child: Text("test overlay"),
                  onPressed: cnt.testOverlay,
                  color: Colors.yellow,
                ),
              ),
              SlimBuilder<Counter>(
                builder: (cnt) => FlatButton(
                  child: Text("test snack"),
                  onPressed: cnt.testSnack,
                  color: Colors.red,
                ),
              ),
              SlimBuilder<Counter>(
                builder: (cnt) => FlatButton(
                  child: Text("test widget"),
                  onPressed: cnt.testWidget,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SlimBuilder<Counter>(
          builder: (c2) => FloatingActionButton(
            heroTag: "main",
            onPressed: c2.inc,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ),
      );
}
