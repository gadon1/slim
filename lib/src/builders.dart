import 'package:flutter/material.dart';
import 'extensions.dart';
import 'state_management.dart';

/// Useful extension methods on [BuildContext]
extension SlimBuildContextMessagesX on BuildContext {
  /// Clear UI messages even if not dismissible
  void forceClearOverlay() => _msg.forceClearMessage();

  /// Clear UI messages if not dismissible
  void clearOverlay() => _msg.clearMessage();

  /// Show overlay widget
  void showWidget(Widget widget,
          {bool dismissible = true,
          Color overlayColor = Colors.black,
          double overlayOpacity = .6}) =>
      _msg.showMessage(
        this,
        widget,
        null,
        null,
        _MessageType.Widget,
        dismissible,
        overlayColor,
        overlayOpacity,
      );

  /// Show overlay text
  void showOverlay(String message,
          {Color backgroundColor = Colors.black,
          bool dismissible = true,
          textStyle = const TextStyle(color: Colors.white),
          Color overlayColor = Colors.black,
          double overlayOpacity = .6}) =>
      _msg.showMessage(this, message, backgroundColor, textStyle,
          _MessageType.Overlay, dismissible, overlayColor, overlayOpacity);

  /// Show snackbar
  void showSnackBar(String message,
          {Color backgroundColor = Colors.black,
          textStyle = const TextStyle(color: Colors.white)}) =>
      _msg.showMessage(this, message, backgroundColor, textStyle,
          _MessageType.Snackbar, false, Colors.black, .6);

  /// True if currently showing overlay
  bool get hasOverlay => _msg.hasMessage;
}

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

/// Provide MaterialApp.builder function to support slim UI messages
class SlimMaterialAppBuilder {
  static Widget builder(BuildContext context, Widget child) =>
      _SlimMaterialAppBuilder(child);
}

class _CurrSlim extends ChangeNotifier {}

_SlimMessageObject _msg = _SlimMessageObject();

class SlimMessage {
  static get msg => _msg;
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
            Slim<_SlimMessageObject>(
              child: _SlimMessage(),
              stateObject: _msg,
            )
          ],
        ),
      );
}

/// Abstract class for recommended state object
abstract class SlimObject extends ChangeNotifier {
  /// Update all widget that reference it, if current is true then only update current widget
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

  T slim<T>() => context?.slim<T>();

  void onInit() {}
  void onDispose() {}

  _addContext(BuildContext context) {
    if (_contexts.indexOf(context) < 0) _contexts.add(context);
  }

  /// Get the current context - works only if consumed by [SlimBuilder]
  BuildContext get context => _getContext();

  /// Show overlay widget
  void showWidget(
    Widget widget, {
    bool dismissible = true,
    Color overlayColor = Colors.black,
    double overlayOpacity = .6,
  }) =>
      context?.showWidget(
        widget,
        dismissible: dismissible,
        overlayColor: overlayColor,
        overlayOpacity: overlayOpacity,
      );

  /// Show overlay text
  void showOverlay(
    String message, {
    Color backgroundColor = Colors.black,
    bool dismissible = true,
    textStyle = const TextStyle(color: Colors.white),
    Color overlayColor = Colors.black,
    double overlayOpacity = .6,
  }) =>
      context?.showOverlay(
        message,
        backgroundColor: backgroundColor,
        dismissible: dismissible,
        textStyle: textStyle,
        overlayColor: overlayColor,
        overlayOpacity: overlayOpacity,
      );

  /// Show snackbar
  void showSnackBar(
    String message, {
    Color backgroundColor = Colors.black,
    textStyle = const TextStyle(color: Colors.white),
  }) =>
      context?.showSnackBar(message,
          backgroundColor: backgroundColor, textStyle: textStyle);

  /// Close Keyboard by requesting focuse
  void closeKeyboard() => context?.closeKeyboard();

  /// True if currently showing overlay
  bool get hasOverlay => context?.hasOverlay ?? false;

  /// Clear UI messages if not dismissible
  void clearOverlay() => context?.clearOverlay();

  /// Clear UI messages even if not dismissible
  void forceClearOverlay() => context?.forceClearOverlay();
}

/// Abstract class for recommended state object that gets AppLifecycleState events
abstract class SlimAppStateObject extends SlimObject
    with WidgetsBindingObserver {
  @override
  void onInit() => WidgetsBinding.instance.addObserver(this);

  @override
  void onDispose() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    try {
      if (ModalRoute.of(context).isFirst) return onAppStateChanged(state);
    } catch (e) {}
  }

  /// Will be called if this instance dependency is the current screen
  void onAppStateChanged(AppLifecycleState state);
}

enum _MessageType { Overlay, Snackbar, Widget }

class _SlimMessageObject extends ChangeNotifier {
  Color messageBackgroundColor;
  TextStyle messageTextStyle;
  dynamic message;
  _MessageType messageType;
  Widget widget;
  bool dismissible;
  Color overlayColor;
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
      Color messageBackgroundColor,
      messageTextStyle,
      _MessageType messageType,
      bool dismissible,
      Color overlayColor,
      double overlayOpacity) {
    this.message = message;
    this..messageBackgroundColor = messageBackgroundColor;
    this.messageTextStyle = messageTextStyle;
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

  void clearMessage() {
    if (!dismissible && messageType != _MessageType.Snackbar) return;
    message = null;
    notifyListeners();
  }

  void forceClearMessage() {
    dismissible = true;
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
          messageObject.message = null;
        },
      );
      return SizedBox(height: 0);
    }

    return GestureDetector(
      onTap: messageObject.clearMessage,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: messageObject.overlayColor
            .withOpacity(messageObject.overlayOpacity),
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
