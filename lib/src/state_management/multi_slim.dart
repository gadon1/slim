import 'package:flutter/material.dart';
import '../extensions/slimer.dart';
import 'slimer.dart';

/// Wraps child widget with multiple [Slimer]
class MultiSlim extends StatelessWidget {
  /// List of [Slimer] to put above child
  final List<Slimer> slimers;
  final Widget child;
  MultiSlim({@required this.child, @required this.slimers});

  @override
  Widget build(BuildContext context) => slimers.slim(child: child);
}
