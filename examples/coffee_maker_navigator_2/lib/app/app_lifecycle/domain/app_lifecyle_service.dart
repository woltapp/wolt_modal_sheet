import 'package:flutter/foundation.dart';

enum AppLifeCycleState {
  foreground,
  background,
}

class AppLifeCycleService {
  late ValueNotifier<AppLifeCycleState> lifeCycleState;

  ValueListenable<AppLifeCycleState> get appLifeStateListenable =>
      lifeCycleState;

  AppLifeCycleService() {
    lifeCycleState = ValueNotifier(AppLifeCycleState.foreground);
  }

  void onForegrounded() {
    lifeCycleState.value = AppLifeCycleState.foreground;
  }

  void onBackgrounded() {
    lifeCycleState.value = AppLifeCycleState.background;
  }
}
