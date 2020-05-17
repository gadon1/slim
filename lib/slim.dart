library slim;

import 'package:flutter/material.dart';

class Slim<T> extends InheritedNotifier<ChangeNotifier> {
  Slim({@required Widget child, @required T stateObject})
      : super(child: child, notifier: _SlimNotifier(stateObject));

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static T of<T>(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Slim<T>>().notifier
              as _SlimNotifier)
          .stateObject;
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

extension SlimSlimersX on List<Slimer> {
  Widget slim({@required Widget child}) =>
      fold(null, (value, slimer) => slimer.slim(value ?? child));
}

extension SlimBuildContextX on BuildContext {
  T slim<T>() => Slim.of<T>(this);
}
