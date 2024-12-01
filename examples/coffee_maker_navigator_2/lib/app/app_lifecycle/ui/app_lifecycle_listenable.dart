import 'package:coffee_maker_navigator_2/app/di/coffee_maker_app_level_dependency_container.dart';
import 'package:flutter/widgets.dart';
import 'package:wolt_di/wolt_di.dart';

class AppLifecycleObserver extends StatefulWidget {
  const AppLifecycleObserver({required this.child, super.key});

  final Widget child;

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver> {
  late final AppLifecycleListener listener;

  @override
  void initState() {
    super.initState();
    final appLevelDependencyContainer =
        DependencyInjector.container<CoffeeMakerAppLevelDependencyContainer>(
            context);
    final appLifeCycleService = appLevelDependencyContainer.appLifeCycleService;
    listener = AppLifecycleListener(
      onShow: () {
        debugPrint('AppLifecycleListener: onForegrounded');
        appLifeCycleService.onForegrounded();
      },
      onHide: () {
        debugPrint('AppLifecycleListener: onBackgrounded');
        appLifeCycleService.onBackgrounded();
      },
    );
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
