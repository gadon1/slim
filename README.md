# slim

Super light state managment implemented pure out of the box.

# Resolve

```dart

    class _MyHomePageState extends State<MyHomePage> {
        @override
        Widget build(BuildContext context) {
            final counter = Slim.of<Counter>(context);

            return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text(
                    'You have pushed the button this many times:',
                    ),
                    Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.headline4,
                    ),
                ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: counter.inc,
                tooltip: 'Increment',
                child: Icon(Icons.add),
            ),
            );
        }
    }

```

# Registration

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

## Multi Slim - Extension Method

```dart

    class MyApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
            return [Slimer<Counter>(Counter())].slim(
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
