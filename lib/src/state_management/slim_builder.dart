import 'package:flutter/material.dart';
import 'curr_slim.dart';
import 'slim.dart';
import 'slim_controller.dart';
import '../extensions/build_context.dart';

/// Recommended widget to consume [SlimController]
class SlimBuilder<T> extends StatelessWidget {
  final Widget Function(T stateObject) builder;
  final T instance;
  SlimBuilder({@required this.builder, this.instance});

  @override
  Widget build(BuildContext context) {
    if (instance != null)
      return Slim<T>(
        child: SlimBuilder<T>(builder: builder),
        stateObject: instance,
      );

    final stateObject = context.slim<T>();
    if (stateObject is SlimController) {
      return Slim<CurrSlim>(
        stateObject: CurrSlim(),
        child: Builder(builder: (ctx) {
          stateObject.addContext(ctx);
          return SlimBuilder<CurrSlim>(builder: (_) => builder(stateObject));
        }),
      );
    }
    return builder(stateObject);
  }
}
