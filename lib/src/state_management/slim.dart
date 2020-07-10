import 'package:flutter/material.dart';
import 'slim_notifier.dart';
import 'slim_inherited_notifier.dart';
import 'slim_controller.dart';

/// [Slim] StatefulWidget with special inherited notifier state object wrapping
class Slim<T> extends StatefulWidget {
  final Widget child;
  final T stateObject;
  Slim({@required this.child, @required this.stateObject});

  @override
  _SlimState<T> createState() => _SlimState<T>();

  static T read<T>(BuildContext context) => (context
          .findAncestorWidgetOfExactType<SlimInhertiedNotifier<T>>()
          .notifier as SlimNotifier)
      .stateObject;

  static T of<T>(BuildContext context) {
    try {
      return (context
              .dependOnInheritedWidgetOfExactType<SlimInhertiedNotifier<T>>()
              .notifier as SlimNotifier)
          .stateObject;
    } catch (e) {
      return (context
              .findAncestorWidgetOfExactType<SlimInhertiedNotifier<T>>()
              .notifier as SlimNotifier)
          .stateObject;
    }
  }
}

class _SlimState<T> extends State<Slim<T>> {
  T _stateObject;
  @override
  void initState() {
    super.initState();
    _stateObject = widget.stateObject;
    if (_stateObject is SlimController)
      (_stateObject as SlimController).onInit();
  }

  @override
  void dispose() {
    if (_stateObject is SlimController)
      (_stateObject as SlimController).onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      SlimInhertiedNotifier<T>(child: widget.child, stateObject: _stateObject);
}
