import 'package:flutter/material.dart';
import 'build_context.dart';

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
