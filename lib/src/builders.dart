import 'package:flutter/material.dart';
import 'extensions.dart';
import 'state_management.dart';

class SlimBuilder<T> extends StatelessWidget {
  final Widget Function(T stateObject) builder;
  SlimBuilder({@required this.builder});

  @override
  Widget build(BuildContext context) {
    final stateObject = context.slim<T>();
    if (stateObject is SlimObject) {
      return Slim<_CurrSlim>(
        stateObject: _CurrSlim(),
        child: Builder(builder: (ctx) {
          stateObject._addContext(ctx);
          return SlimBuilder<_CurrSlim>(builder: (_) => builder(stateObject));
        }),
      );
    }
    return builder(stateObject);
  }
}

class SlimMaterialAppBuilder {
  static Widget builder(BuildContext context, Widget child) =>
      _SlimMaterialAppBuilder(child);
}

class _CurrSlim extends ChangeNotifier {}

_SlimMessageObject _msg = _SlimMessageObject();

class _SlimMaterialAppBuilder extends StatelessWidget {
  final Widget child;
  _SlimMaterialAppBuilder(this.child);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            child,
            Slim<_SlimMessageObject>(
              child: _SlimMessage(),
              stateObject: _msg,
            )
          ],
        ),
      );
}

abstract class SlimObject extends ChangeNotifier {
  void updateUI({bool current = false}) => current
      ? context?.slim<_CurrSlim>()?.notifyListeners()
      : notifyListeners();

  BuildContext _getContext() {
    if (_contexts.isEmpty) return null;
    try {
      if (ModalRoute.of(_contexts.last).isActive) return _contexts.last;
    } catch (e) {}
    _contexts.removeLast();
    return _getContext();
  }

  List<BuildContext> _contexts = [];

  _addContext(BuildContext context) {
    if (_contexts.indexOf(context) < 0) _contexts.add(context);
  }

  BuildContext get context => _getContext();

  void showWidget(Widget widget, {bool dismissable = true}) =>
      context?.showWidget(widget, dismissable: dismissable);

  void showOverlay(String message,
          {Color messageBackgroundColor = Colors.black,
          bool dismissable = true,
          messageTextStyle = const TextStyle(color: Colors.white)}) =>
      context?.showOverlay(message,
          messageBackgroundColor: messageBackgroundColor,
          messageTextStyle: messageTextStyle,
          dismissable: dismissable);

  void showSnackBar(String message,
          {Color messageBackgroundColor = Colors.black,
          messageTextStyle = const TextStyle(color: Colors.white)}) =>
      context?.showSnackBar(message,
          messageBackgroundColor: messageBackgroundColor,
          messageTextStyle: messageTextStyle);
}

enum _MessageType { Overlay, Snackbar, Widget }

class _SlimMessageObject extends ChangeNotifier {
  Color messageBackgroundColor;
  TextStyle messageTextStyle;
  dynamic message;
  _MessageType messageType;
  Widget widget;
  bool dismissable;

  Future<bool> _onWillPop() async {
    if (message == null) return true;
    message = null;
    notifyListeners();
    return false;
  }

  void showMessage(
      BuildContext context,
      dynamic message,
      Color messageBackgroundColor,
      messageTextStyle,
      _MessageType messageType,
      bool dismissable) {
    this.message = message;
    this..messageBackgroundColor = messageBackgroundColor;
    this.messageTextStyle = messageTextStyle;
    this.messageType = messageType;
    this.dismissable = dismissable;
    notifyListeners();
    final route = ModalRoute.of(context);
    route?.removeScopedWillPopCallback(_onWillPop);
    route?.addScopedWillPopCallback(_onWillPop);
  }

  void clearMessage() {
    if (!dismissable && messageType != _MessageType.Snackbar) return;
    message = null;
    notifyListeners();
  }

  void forceClearOverlay() {
    dismissable = true;
    clearMessage();
  }

  bool get hasMessage =>
      message != null && messageType != _MessageType.Snackbar;
}

class _SlimMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messageObject = context.slim<_SlimMessageObject>();

    if (messageObject.message == null) return SizedBox(height: 0);

    if (messageObject.messageType == _MessageType.Snackbar) {
      Future.delayed(
        Duration.zero,
        () {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              messageObject.message,
              style: messageObject.messageTextStyle,
            ),
            backgroundColor: messageObject.messageBackgroundColor,
          ));
        },
      );
      return SizedBox(height: 0);
    }

    return GestureDetector(
      onTap: messageObject.clearMessage,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black.withOpacity(.6),
        child: GestureDetector(
          onTap: () {},
          child: Center(
            child: messageObject.messageType == _MessageType.Overlay
                ? Container(
                    decoration: BoxDecoration(
                      color: messageObject.messageBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Text(
                      messageObject.message.toString(),
                      style: messageObject.messageTextStyle,
                    ),
                  )
                : messageObject.message,
          ),
        ),
      ),
    );
  }
}

extension SlimBuildContextMessagesX on BuildContext {
  void _showMessage(dynamic message, Color messageBackgroundColor,
          messageTextStyle, _MessageType messageType, bool dismissable) =>
      _msg.showMessage(this, message, messageBackgroundColor, messageTextStyle,
          messageType, dismissable);

  void forceClearMessage() => _msg.forceClearOverlay();

  void clearMessage() => _msg.clearMessage();

  void showWidget(Widget widget, {bool dismissable = true}) =>
      _showMessage(widget, null, null, _MessageType.Widget, dismissable);

  void showOverlay(String message,
          {Color messageBackgroundColor = Colors.black,
          bool dismissable = true,
          messageTextStyle = const TextStyle(color: Colors.white)}) =>
      _showMessage(message, messageBackgroundColor, messageTextStyle,
          _MessageType.Overlay, dismissable);

  void showSnackBar(String message,
          {Color messageBackgroundColor = Colors.black,
          messageTextStyle = const TextStyle(color: Colors.white)}) =>
      _showMessage(message, messageBackgroundColor, messageTextStyle,
          _MessageType.Snackbar, false);

  bool get hasMessage => _msg.hasMessage;
}
