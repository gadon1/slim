import 'package:flutter/material.dart';
import 'localization.dart';
import 'state_management.dart';

extension SlimStringX on String {
  /// true if string is null or empty
  bool get isNullOrEmpty => (this ?? '').isEmpty;

  /// true if string is not null or empty
  bool get isNotNullOrEmpty => (this ?? '').isNotEmpty;
}

extension SlimWidgetX on Widget {
  /// push widget to navigation stack
  Future<T> push<T>(BuildContext context) =>
      context.push(MaterialPageRoute(builder: (_) => this));

  /// replace current navigation to widget
  Future<T> pushReplacement<T>(BuildContext context) =>
      context.pushReplacement(MaterialPageRoute(builder: (_) => this));

  /// make widget the only widget in navigation stack
  Future<T> pushTop<T>(BuildContext context) {
    context.popTop();
    return context.pushReplacement<T>(MaterialPageRoute(builder: (_) => this));
  }
}

extension SlimBuildContextContextX on BuildContext {
  /// access the nearest top T in tree
  T slim<T>() => Slim.of<T>(this);

  /// media query width
  double get width => MediaQuery.of(this).size.width;

  /// media query height
  double get height => MediaQuery.of(this).size.height;

  /// current navigator state
  NavigatorState get navigator => Navigator.of(this);

  /// pop navigation stack
  void pop<T>({T result}) => navigator.pop<T>(result);

  /// push to navigation stack
  Future<T> push<T>(Route<T> route) => navigator.push<T>(route);

  /// replace top navigation stack
  Future<T> pushReplacement<T>(Route<T> route) =>
      navigator.pushReplacement(route);

  /// pop navigation stack to a single navigation
  void popTop() {
    while (navigator.canPop()) navigator.pop();
  }

  /// get locale translation by key
  String translate(String key) =>
      SlimLocalizations.slimLocaleLoader.translate(key);

  /// get os locale text direction
  TextDirection get textDirection =>
      Localizations.of<WidgetsLocalizations>(this, WidgetsLocalizations)
          .textDirection;
}
