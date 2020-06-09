import 'package:flutter/material.dart';
import 'slim_object.dart';

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
