import 'package:flutter/material.dart';
import 'extensions.dart';
import 'builders.dart';

/// Abstract class for recommended state object
abstract class SlimObject extends ChangeNotifier {
  /// Update all widget that reference it, if current is true then only update current widget
  void updateUI({bool current = false}) => current
      ? context?.slim<CurrSlim>()?.notifyListeners()
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

  addContext(BuildContext context) {
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
