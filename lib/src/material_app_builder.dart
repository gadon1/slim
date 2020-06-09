import 'package:flutter/material.dart';
import 'state_management/slim.dart';
import 'message.dart';

/// Provide MaterialApp.builder function to support slim UI messages
class SlimMaterialAppBuilder {
  static Widget builder(BuildContext context, Widget child) =>
      _SlimMaterialAppBuilder(child);
}

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
