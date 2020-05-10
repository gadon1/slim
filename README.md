# slim

Super light state managment implemented pure out of the box.

# Resolve

```dart

    Slim.of<Counter>(context);

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
