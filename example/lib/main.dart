import 'package:flutter/material.dart';
import 'package:slim/slim.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class Counter extends SlimObject {
  int value = 0;
  inc() {
    value++;
    updateUI();
  }

  testWidget() => showWidget(Container(
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Center(child: Text("value is: $value")),
      ));

  testOverlay() =>
      showOverlay("value is: $value", messageBackgroundColor: Colors.red);

  testSnack() =>
      showSnackBar("value is: $value", messageBackgroundColor: Colors.red);
}

class MyApp extends StatelessWidget {
  MyApp() {
    SlimLocalizations.supportedLocales = [
      const Locale('en', 'US'),
      const Locale('he', 'IL'),
    ];

    //SlimLocalizations.slimLocaleLoader = CustomSlimLocalizations();
  }

  @override
  Widget build(BuildContext context) {
    return [Slimer<Counter>(Counter())].slim(
        child: MaterialApp(
      builder: SlimMaterialAppBuilder.builder,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: SlimLocalizations.delegates,
      supportedLocales: SlimLocalizations.supportedLocales,
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
                builder: (cnt) => Text(
                  '${cnt.value}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              FlatButton(
                child: Text("next page"),
                onPressed: () => MyHomePage2(title: "Hi").push(context),
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
