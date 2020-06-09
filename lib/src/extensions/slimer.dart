import 'package:flutter/material.dart';
import '../state_management/slimer.dart';

/// Useful extension methods on List<[Slimer]>
extension SlimSlimersX on List<Slimer> {
  Widget slim({@required Widget child}) =>
      fold(null, (value, slimer) => slimer.slim(value ?? child));
}
