import 'package:flutter/material.dart';

/// [InhertiedNotifier] with special state object wrapping
class Slim<T> extends InheritedNotifier<ChangeNotifier> {
  Slim({@required Widget child, @required T stateObject})
      : super(child: child, notifier: _SlimNotifier(stateObject));

  static T of<T>(BuildContext context) =>
      (context.findAncestorWidgetOfExactType<Slim<T>>().notifier
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
