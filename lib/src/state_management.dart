import 'package:flutter/material.dart';
import 'object.dart';

/// [Slim] StatefulWidget with special inherited notifier state object wrapping
class Slim<T> extends StatefulWidget {
  final Widget child;
  final T stateObject;
  Slim({@required this.child, @required this.stateObject});

  @override
  _SlimState<T> createState() => _SlimState<T>();

  static T of<T>(BuildContext context) {
    try {
      return (context
              .dependOnInheritedWidgetOfExactType<_SlimInhertiedNotifier<T>>()
              .notifier as _SlimNotifier)
          .stateObject;
    } catch (e) {
      return (context
              .findAncestorWidgetOfExactType<_SlimInhertiedNotifier<T>>()
              .notifier as _SlimNotifier)
          .stateObject;
    }
  }
}

/// [Slim<T>] by demand
class Slimer<T> {
  /// State object
  final T stateObject;
  Slimer(this.stateObject);

  /// Returns the child wrapped with [InheritedNotifier]
  Widget slim(Widget child) => Slim<T>(child: child, stateObject: stateObject);
}

/// Useful extension methods on List<[Slimer]>
extension SlimSlimersX on List<Slimer> {
  Widget slim({@required Widget child}) =>
      fold(null, (value, slimer) => slimer.slim(value ?? child));
}

/// Wraps child widget with multiple [Slimer]
class MultiSlim extends StatelessWidget {
  /// List of [Slimer] to put above child
  final List<Slimer> slimers;
  final Widget child;
  MultiSlim({@required this.child, @required this.slimers});

  @override
  Widget build(BuildContext context) => slimers.slim(child: child);
}

class _SlimInhertiedNotifier<T> extends InheritedNotifier<ChangeNotifier> {
  _SlimInhertiedNotifier({@required Widget child, @required T stateObject})
      : super(child: child, notifier: _SlimNotifier(stateObject));
}

class _SlimState<T> extends State<Slim<T>> {
  T _stateObject;
  @override
  void initState() {
    super.initState();
    _stateObject = widget.stateObject;
    if (_stateObject is SlimObject) (_stateObject as SlimObject).onInit();
  }

  @override
  void dispose() {
    if (_stateObject is SlimObject) (_stateObject as SlimObject).onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _SlimInhertiedNotifier<T>(child: widget.child, stateObject: _stateObject);
}

class _SlimNotifier extends ChangeNotifier {
  final stateObject;
  _SlimNotifier(this.stateObject) {
    if (stateObject is ChangeNotifier)
      (stateObject as ChangeNotifier).addListener(notifyListeners);
  }
}
