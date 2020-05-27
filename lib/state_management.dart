import 'package:flutter/material.dart';
import 'extensions.dart';

class Slim<T> extends InheritedNotifier<ChangeNotifier> {
  Slim({@required Widget child, @required T stateObject})
      : super(child: child, notifier: _SlimNotifier(stateObject));

  static T of<T>(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Slim<T>>().notifier
              as _SlimNotifier)
          .stateObject;

  @override
  bool updateShouldNotify(InheritedNotifier<ChangeNotifier> oldWidget) => true;
}

class _SlimNotifier extends ChangeNotifier {
  final stateObject;
  _SlimNotifier(this.stateObject) {
    if (stateObject is ChangeNotifier)
      (stateObject as ChangeNotifier).addListener(notifyListeners);
  }
}

class Slimer<T> {
  final T stateObject;
  Slimer(this.stateObject);

  Widget slim(Widget child) => Slim<T>(child: child, stateObject: stateObject);
}

class MultiSlim extends StatelessWidget {
  final List<Slimer> slimers;
  final Widget child;
  MultiSlim({@required this.child, @required this.slimers});

  @override
  Widget build(BuildContext context) => slimers.slim(child: child);
}
