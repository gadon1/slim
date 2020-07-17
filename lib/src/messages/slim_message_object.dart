import 'package:flutter/material.dart';
import 'message_type.dart';

class SlimMessageObject extends ChangeNotifier {
  Color backgroundColor, overlayColor;
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
