import 'package:flutter/material.dart';
import 'localization.dart';
import 'state_management.dart';

/// Useful extension methods on [String]
extension SlimStringX on String {
  /// True if null or empty
  bool get isNullOrEmpty => (this ?? '').isEmpty;

  /// True if not null or empty
  bool get isNotNullOrEmpty => (this ?? '').isNotEmpty;
}

/// Useful extension methods on [Widget]
extension SlimWidgetX on Widget {
  /// Push widget to navigation stack
  Future<T> push<T>(BuildContext context) =>
      context.push(MaterialPageRoute(builder: (_) => this));

  /// Replace current navigation to widget
  Future<T> pushReplacement<T>(BuildContext context) =>
      context.pushReplacement(MaterialPageRoute(builder: (_) => this));

  /// Make widget the only widget in navigation stack
  Future<T> pushTop<T>(BuildContext context) {
    context.popTop();
    return context.pushReplacement<T>(MaterialPageRoute(builder: (_) => this));
  }
}

/// Useful extension methods on [BuildContext]
extension SlimBuildContextContextX on BuildContext {
  /// Access the nearest T up the tree
  T slim<T>() => Slim.of<T>(this);

  /// [MediaQuery] width
  double get width => MediaQuery.of(this).size.width;

  /// [MediaQuery] height
  double get height => MediaQuery.of(this).size.height;

  /// Current navigator state
  NavigatorState get navigator => Navigator.of(this);

  /// Pop navigation stack
  void pop<T>({T result}) => navigator.pop<T>(result);

  /// Push to navigation stack
  Future<T> push<T>(Route<T> route) => navigator.push<T>(route);

  /// Replace top navigation stack
  Future<T> pushReplacement<T>(Route<T> route) =>
      navigator.pushReplacement(route);

  /// Pop navigation stack to a single navigation
  void popTop() {
    while (navigator.canPop()) navigator.pop();
  }

  /// Get current locale translation by key
  String translate(String key) =>
      SlimLocalizations.slimLocaleLoader.translate(key);

  /// Get OS locale text direction
  TextDirection get textDirection =>
      Localizations.of<WidgetsLocalizations>(this, WidgetsLocalizations)
          .textDirection;

  /// Close keyboard
  void closeKeyboard() => FocusScope.of(this).requestFocus(FocusNode());
}
