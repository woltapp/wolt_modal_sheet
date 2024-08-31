import 'package:coffee_maker_navigator_2/app/app_lifecycle/ui/app_lifecycle_listenable.dart';
import 'package:coffee_maker_navigator_2/app/di/coffee_maker_app_level_dependency_container.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_di/wolt_di.dart';

class CoffeeMakerApp extends StatelessWidget {
  const CoffeeMakerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// STEP #3: Use the DependencyInjector widget to provide dependency injection framework to
    /// the widget tree.
    return DependencyInjector(
      child: Builder(builder: (context) {
        final appLevelDependencyContainer = DependencyInjector.container<
            CoffeeMakerAppLevelDependencyContainer>(context);

        return AppLifecycleObserver(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.themeData(context),
            routerDelegate: appLevelDependencyContainer.appRouterDelegate,
            backButtonDispatcher:
                appLevelDependencyContainer.backButtonDispatcher,
          ),
        );
      }),
    );
  }
}
