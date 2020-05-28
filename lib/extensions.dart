import 'package:flutter/material.dart';
import 'state_management.dart';
import 'builders.dart';

extension SlimStringX on String {
  bool get isNullOrEmpty => (this ?? '').isEmpty;
  bool get isNotNullOrEmpty => (this ?? '').isNotEmpty;
}

extension SlimSlimersX on List<Slimer> {
  Widget slim({@required Widget child}) =>
      fold(null, (value, slimer) => slimer.slim(value ?? child));
}

extension SlimWidgetX on Widget {
  Future<T> push<T>(BuildContext context) =>
      context.push(MaterialPageRoute(builder: (_) => this));
  Future<T> pushReplacement<T>(BuildContext context) =>
      context.pushReplacement(MaterialPageRoute(builder: (_) => this));
  Future<T> pushTop<T>(BuildContext context) {
    context.popTop();
    return context.pushReplacement<T>(MaterialPageRoute(builder: (_) => this));
  }
}

extension SlimBuildContextContextX on BuildContext {
  T slim<T>() => Slim.of<T>(this);
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  NavigatorState get navigator => Navigator.of(this);
  void pop<T>({T result}) =>
      hasMessage ? forceClearMessage() : navigator.pop<T>(result);

  Future<T> push<T>(Route<T> route) => navigator.push<T>(route);
  Future<T> pushReplacement<T>(Route<T> route) =>
      navigator.pushReplacement(route);
  void popTop() {
    while (navigator.canPop()) navigator.pop();
  }
}
