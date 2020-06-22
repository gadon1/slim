import 'package:flutter/material.dart';
import 'extensions/build_context.dart';

SlimMessageObject msg = SlimMessageObject();

enum MessageType { Overlay, Snackbar, Widget }

class SlimMessageObject extends ChangeNotifier {
  Color backgroundColor,overlayColor;
  TextStyle textStyle;
  dynamic message;
  MessageType messageType;
  Widget widget;
  bool dismissible;
  double overlayOpacity;

  Future<bool> _onWillPop() async {
    if (message == null) return true;
    message = null;
    notifyListeners();
    return false;
  }

  void showMessage(
      BuildContext context,
      dynamic message,
      Color backgroundColor,
      textStyle,
      MessageType messageType,
      bool dismissible,
      Color overlayColor,
      double overlayOpacity) {
    this.message = message;
    this.backgroundColor = backgroundColor;
    this.textStyle = textStyle;
    this.messageType = messageType;
    this.dismissible = dismissible;
    this.overlayColor = overlayColor;
    this.overlayOpacity = overlayOpacity;
    notifyListeners();
    if (context != null) {
      final route = ModalRoute.of(context);
      route?.removeScopedWillPopCallback(_onWillPop);
      route?.addScopedWillPopCallback(_onWillPop);
    }
  }

  void clearOverlay() {
    if (!dismissible && messageType != MessageType.Snackbar) return;
    message = null;
    notifyListeners();
  }

  void forceClearOverlay() {
    dismissible = true;
    clearOverlay();
  }

  bool get hasOverlay => message != null && messageType != MessageType.Snackbar;
}

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
