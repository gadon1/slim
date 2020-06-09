import 'package:flutter/material.dart';
import '../localization.dart';
import '../message.dart';
import '../state_management/slim.dart';

/// Useful extension methods on [BuildContext]
extension SlimBuildContextContextX on BuildContext {
  /// Clear UI messages even if not dismissible
  void forceClearOverlay() => msg.forceClearOverlay();

  /// Clear UI messages if not dismissible
  void clearOverlay() => msg.clearOverlay();

  /// Show overlay widget
  void showWidget(Widget widget,
          {bool dismissible = true,
          Color overlayColor = Colors.black,
          double overlayOpacity = .6}) =>
      msg.showMessage(
        this,
        widget,
        null,
        null,
        MessageType.Widget,
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
      msg.showMessage(this, message, backgroundColor, textStyle,
          MessageType.Overlay, dismissible, overlayColor, overlayOpacity);

  /// Show snackbar
  void showSnackBar(String message,
          {Color backgroundColor = Colors.black,
          textStyle = const TextStyle(color: Colors.white)}) =>
      msg.showMessage(this, message, backgroundColor, textStyle,
          MessageType.Snackbar, false, Colors.black, .6);

  /// True if currently showing overlay
  bool get hasOverlay => msg.hasOverlay;

  /// Access the nearest T up the tree
  T slim<T>() => Slim.of<T>(this);

  /// [MediaQuery] width
  double get width => MediaQuery.of(this).size.width;

  /// [MediaQuery] height
  double get height => MediaQuery.of(this).size.height;

  /// Current navigator state
  NavigatorState get navigator => Navigator.of(this);

  /// Pop navigation stack
  void pop<T>({T result}) => navigator.pop<T>(result);

  /// Push to navigation stack
  Future<T> push<T>(Route<T> route) => navigator.push<T>(route);

  /// Replace top navigation stack
  Future<T> pushReplacement<T>(Route<T> route) =>
      navigator.pushReplacement(route);

  /// Pop navigation stack to a single navigation
  void popTop() {
    while (navigator.canPop()) navigator.pop();
  }

  /// Get current locale translation by key
  String translate(String key) =>
      SlimLocalizations.slimLocaleLoader.translate(key);

  /// Get OS locale text direction
  TextDirection get textDirection =>
      Localizations.of<WidgetsLocalizations>(this, WidgetsLocalizations)
          .textDirection;

  /// Close keyboard
  void closeKeyboard() => FocusScope.of(this).requestFocus(FocusNode());
}
