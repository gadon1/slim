import 'package:flutter/material.dart';
import 'state_management.dart';
import 'extensions.dart';

class SlimBuilder<T> extends StatelessWidget {
  final Widget Function(T stateObject) builder;
  SlimBuilder({@required this.builder});

  @override
  Widget build(BuildContext context) {
    final stateObject = context.slim<T>();
    if (stateObject is SlimObject) stateObject._addContext(context);
    return builder(stateObject);
  }
}

class SlimMaterialAppBuilder extends StatelessWidget {
  final Widget child;
  SlimMaterialAppBuilder(this.child);

  @override
  Widget build(BuildContext context) => Slim<_SlimMessageObject>(
        stateObject: _SlimMessageObject(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[child, _SlimMessage()],
          ),
        ),
      );

  static Widget builder(BuildContext context, Widget child) =>
      SlimMaterialAppBuilder(child);
}

abstract class SlimObject extends ChangeNotifier {
  void updateUI() => notifyListeners();

  BuildContext _getMessageObject() {
    if (_contexts.isEmpty) return null;
    try {
      _contexts.last.slim<_SlimMessageObject>();
      return _contexts.last;
    } catch (e) {
      _contexts.removeLast();
    }
    return _getMessageObject();
  }

  List<BuildContext> _contexts = [];

  _addContext(BuildContext context) {
    if (_contexts.indexOf(context) < 0) _contexts.add(context);
  }

  BuildContext get context => _getMessageObject();

  void showWidget(Widget widget, {bool dissmiable = true}) =>
      context?.showWidget(widget, dissmiable: dissmiable);

  void showOverlay(String message,
          {Color messageBackgroundColor = Colors.black,
          bool dissmisable = true,
          messageTextStyle = const TextStyle(color: Colors.white)}) =>
      context?.showOverlay(message,
          messageBackgroundColor: messageBackgroundColor,
          messageTextStyle: messageTextStyle,
          dissmisable: dissmisable);

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
  bool dissmisable;

  void update() => notifyListeners();

  void clearMessage() {
    if (!dissmisable || messageType == _MessageType.Snackbar) return;
    message = null;
    update();
  }

  void forceClearOverlay() {
    dissmisable = true;
    clearMessage();
  }
}

class _SlimMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stateObject = context.slim<_SlimMessageObject>();

    if (stateObject.message == null) return SizedBox(height: 0);

    if (stateObject.messageType == _MessageType.Snackbar) {
      Future.delayed(
        Duration.zero,
        () {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              stateObject.message,
              style: stateObject.messageTextStyle,
            ),
            backgroundColor: stateObject.messageBackgroundColor,
          ));
          stateObject.message = null;
        },
      );
      return SizedBox(height: 0);
    }

    return GestureDetector(
      onTap: stateObject.clearMessage,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black.withOpacity(.6),
        child: GestureDetector(
          onTap: () {},
          child: Center(
            child: stateObject.messageType == _MessageType.Overlay
                ? Container(
                    decoration: BoxDecoration(
                      color: stateObject.messageBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Text(
                      stateObject.message.toString(),
                      style: stateObject.messageTextStyle,
                    ),
                  )
                : stateObject.message,
          ),
        ),
      ),
    );
  }
}

extension SlimBuildContextMessagesX on BuildContext {
  void _showMessage(dynamic message, Color messageBackgroundColor,
      messageTextStyle, _MessageType messageType, bool dissmisable) {
    final _slimMessageObject = slim<_SlimMessageObject>();
    if (_slimMessageObject == null) return;
    _slimMessageObject.message = message;
    _slimMessageObject.messageBackgroundColor = messageBackgroundColor;
    _slimMessageObject.messageTextStyle = messageTextStyle;
    _slimMessageObject.messageType = messageType;
    _slimMessageObject.dissmisable = dissmisable;
    _slimMessageObject.update();
  }

  void forceClearMessage() {
    final _slimMessageObject = slim<_SlimMessageObject>();
    if (_slimMessageObject == null) return;
    _slimMessageObject.forceClearOverlay();
  }

  void clearMessage() {
    final _slimMessageObject = slim<_SlimMessageObject>();
    if (_slimMessageObject == null) return;
    _slimMessageObject.clearMessage();
  }

  void showWidget(Widget widget, {bool dissmiable = true}) =>
      _showMessage(widget, null, null, _MessageType.Widget, dissmiable);

  void showOverlay(String message,
          {Color messageBackgroundColor = Colors.black,
          bool dissmisable = true,
          messageTextStyle = const TextStyle(color: Colors.white)}) =>
      _showMessage(message, messageBackgroundColor, messageTextStyle,
          _MessageType.Overlay, dissmisable);

  void showSnackBar(String message,
          {Color messageBackgroundColor = Colors.black,
          messageTextStyle = const TextStyle(color: Colors.white)}) =>
      _showMessage(message, messageBackgroundColor, messageTextStyle,
          _MessageType.Snackbar, false);
}
