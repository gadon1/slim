import 'package:flutter/material.dart';
import 'extensions.dart';
import 'object.dart';
import 'state_management.dart';
import 'message.dart';

/// Recommended widget to consume [SlimObject]
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
    if (stateObject is SlimObject) {
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

/// Provide MaterialApp.builder function to support slim UI messages
class SlimMaterialAppBuilder {
  static Widget builder(BuildContext context, Widget child) =>
      _SlimMaterialAppBuilder(child);
}

class CurrSlim extends ChangeNotifier {}

class _SlimMaterialAppBuilder extends StatelessWidget {
  final Widget child;
  _SlimMaterialAppBuilder(this.child);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            child,
            Slim<SlimMessageObject>(
              child: SlimMessage(),
              stateObject: msg,
            )
          ],
        ),
      );
}
