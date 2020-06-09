import 'package:flutter/material.dart';
import 'slim_notifier.dart';

class SlimInhertiedNotifier<T> extends InheritedNotifier<ChangeNotifier> {
  SlimInhertiedNotifier({@required Widget child, @required T stateObject})
      : super(child: child, notifier: SlimNotifier(stateObject));
}
