# slim

Super light statemanagment implemented pure out of the box.

# Usage

## Single Slim

```dart

  class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slim<Counter>(
      stateObject: Counter(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

```

## Multi Slim - Slimer

```dart

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MultiSlim(
        slimers: [Slimer<Counter>(Counter())],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
        );
    }
    }

```

## Resolve Object

```dart

    Slim.of<Counter>(context);

```
