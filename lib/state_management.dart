import 'package:flutter/material.dart';
import 'extensions.dart';
import 'dart:async';

class Slim<T> extends InheritedNotifier<ChangeNotifier> {
  Slim({@required Widget child, @required T stateObject})
      : super(child: child, notifier: _SlimNotifier(stateObject));

  static T of<T>(BuildContext context) {
    final res = (context.dependOnInheritedWidgetOfExactType<Slim<T>>().notifier
            as _SlimNotifier)
        .stateObject;
    if (res is SlimObject) res._addContext(context);
    return res;
  }
}

class _SlimNotifier extends ChangeNotifier {
  final stateObject;
  _SlimNotifier(this.stateObject) {
    if (stateObject is ChangeNotifier)
      (stateObject as ChangeNotifier).addListener(notifyListeners);
  }
}

class Slimer<T> {
  final T stateObject;
  Slimer(this.stateObject);

  Widget slim(Widget child) => Slim<T>(child: child, stateObject: stateObject);
}

extension SlimSlimersX on List<Slimer> {
  Widget slim({@required Widget child}) =>
      fold(null, (value, slimer) => slimer.slim(value ?? child));
}

class MultiSlim extends StatelessWidget {
  final List<Slimer> slimers;
  final Widget child;
  MultiSlim({@required this.child, @required this.slimers});

  @override
  Widget build(BuildContext context) => slimers.slim(child: child);
}

_SlimMessageStream _slimMessageStream = _SlimMessageStream();

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

class _CurrSlim extends ChangeNotifier {}

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
            _SlimMessage(),
          ],
        ),
      );
}

abstract class SlimObject extends ChangeNotifier {
  void updateUI({bool current = false}) => current
      ? context?.slim<_CurrSlim>()?.notifyListeners()
      : notifyListeners();

  BuildContext _getMessageObject() {
    if (_contexts.isEmpty) return null;
    try {
      if (ModalRoute.of(_contexts.last).isActive) return _contexts.last;
    } catch (e) {}
    _contexts.removeLast();
    return _getMessageObject();
  }

  List<BuildContext> _contexts = [];

  _addContext(BuildContext context) {
    if (_contexts.indexOf(context) < 0) _contexts.add(context);
  }

  BuildContext get context => _getMessageObject();

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

  void update() => notifyListeners();

  void clearMessage() {
    if (!dismissable && messageType != _MessageType.Snackbar) return;
    _slimMessageStream.clear();
  }

  void forceClearOverlay() {
    dismissable = true;
    _slimMessageStream.clear();
  }
}

class _SlimMessageStream {
  StreamController<_SlimMessageObject> streamController =
      StreamController<_SlimMessageObject>.broadcast();

  void close() => streamController.close();

  Stream<_SlimMessageObject> get stream => streamController.stream;

  _SlimMessageObject currentMessage;

  bool get hasMessage =>
      currentMessage != null &&
      currentMessage.messageType != _MessageType.Snackbar &&
      currentMessage.message != null;

  void show(_SlimMessageObject _slimMessageObject) {
    currentMessage = _slimMessageObject;
    streamController.sink.add(currentMessage);
  }

  void clear() => show(null);

  bool get dismissable => currentMessage == null || currentMessage.dismissable;
}

class _SlimMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder<_SlimMessageObject>(
      stream: _slimMessageStream.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox(height: 0);

        final messageObject = snapshot.data;

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
      });
}

Future<bool> _onWillPop() async {
  if (_slimMessageStream.hasMessage) {
    _slimMessageStream.clear();
    return false;
  }
  return true;
}

extension SlimBuildContextMessagesX on BuildContext {
  void _showMessage(dynamic message, Color messageBackgroundColor,
      messageTextStyle, _MessageType messageType, bool dismissable) {
    final _slimMessageObject = _SlimMessageObject();
    _slimMessageObject.message = message;
    _slimMessageObject.messageBackgroundColor = messageBackgroundColor;
    _slimMessageObject.messageTextStyle = messageTextStyle;
    _slimMessageObject.messageType = messageType;
    _slimMessageObject.dismissable = dismissable;
    _slimMessageStream.show(_slimMessageObject);
    final route = ModalRoute.of(this);
    route?.removeScopedWillPopCallback(_onWillPop);
    route?.addScopedWillPopCallback(_onWillPop);
  }

  void forceClearMessage() => _slimMessageStream.clear();

  void clearMessage() {
    if (_slimMessageStream.dismissable) forceClearMessage();
  }

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

  bool get hasMessage => _slimMessageStream.hasMessage;
}
