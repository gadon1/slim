import 'package:flutter/material.dart';

class SlimNotifier extends ChangeNotifier {
  final stateObject;
  SlimNotifier(this.stateObject) {
    if (stateObject is ChangeNotifier)
      (stateObject as ChangeNotifier).addListener(notifyListeners);
  }
}
