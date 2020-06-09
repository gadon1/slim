import 'package:flutter/material.dart';

import 'slim.dart';

/// [Slim<T>] by demand
class Slimer<T> {
  /// State object
  final T stateObject;
  Slimer(this.stateObject);

  /// Returns the child wrapped with [InheritedNotifier]
  Widget slim(Widget child) => Slim<T>(child: child, stateObject: stateObject);
}
