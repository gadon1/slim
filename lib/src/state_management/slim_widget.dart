import 'package:flutter/cupertino.dart';
import 'slim_builder.dart';
import 'slim_controller.dart';

/// abstraction quick code for stateless widget wrapped with SlimBuilder
abstract class SlimWidget<T extends SlimController> extends StatelessWidget {
  final T controller;

  SlimWidget({Key key, this.controller}) : super(key: key);

  /// build your widget here instead of traditional build(BuildContext) function
  Widget slimBuild(BuildContext context, T controller);

  @override
  Widget build(BuildContext context) => SlimBuilder(
        instance: controller,
        builder: (stateObject) => slimBuild(context, stateObject),
      );
}
