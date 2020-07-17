import 'package:flutter/material.dart';
import 'message_type.dart';
import 'slim_message_object.dart';
import '../extensions/build_context.dart';

SlimMessageObject msg = SlimMessageObject();

class SlimMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messageObject = context.slim<SlimMessageObject>();

    if (messageObject.message == null) return SizedBox(height: 0);

    if (messageObject.messageType == MessageType.Snackbar) {
      Future.delayed(
        Duration.zero,
        () {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              messageObject.message,
              style: messageObject.textStyle,
            ),
            backgroundColor: messageObject.backgroundColor,
          ));
          messageObject.message = null;
        },
      );
      return SizedBox(height: 0);
    }

    return GestureDetector(
      onTap: messageObject.clearOverlay,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: messageObject.overlayColor
            .withOpacity(messageObject.overlayOpacity),
        child: GestureDetector(
          onTap: () {},
          child: Center(
            child: messageObject.messageType == MessageType.Overlay
                ? Container(
                    decoration: BoxDecoration(
                      color: messageObject.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Text(
                      messageObject.message.toString(),
                      style: messageObject.textStyle,
                    ),
                  )
                : messageObject.message,
          ),
        ),
      ),
    );
  }
}
