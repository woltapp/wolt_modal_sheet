import 'package:wolt_di/wolt_di.dart';
import 'package:coffee_maker_navigator_2/app/di/coffee_maker_app_level_dependency_container.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class CoffeeMakerApp extends StatelessWidget {
  const CoffeeMakerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      child: Builder(builder: (context) {
        final appLevelDependencyContainer = DependencyInjector.container<
            CoffeeMakerAppLevelDependencyContainer>(context);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppThemeData.themeData(context),
          routerDelegate: appLevelDependencyContainer.appRouterDelegate,
          backButtonDispatcher:
              appLevelDependencyContainer.backButtonDispatcher,
        );
      }),
    );
  }
}
