import 'package:coffee_maker_navigator_2/app/app_lifecycle/ui/app_lifecycle_listenable.dart';
import 'package:wolt_di/wolt_di.dart';
import 'package:coffee_maker_navigator_2/app/di/coffee_maker_app_level_dependency_container.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class CoffeeMakerApp extends StatelessWidget {
  const CoffeeMakerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// STEP #3: Provide the DependencyInjector to the widget tree.
    ///
    /// Here, we wrap the entire widget tree with the `DependencyInjector` widget.
    /// This makes the DI system available to all widgets in the tree, allowing them
    /// to access the active dependency containers. By doing this, any widget can
    /// easily retrieve the necessary dependencies it needs.
    return DependencyInjector(
      child: Builder(builder: (context) {
        final appLevelDependencyContainer = DependencyInjector.container<
            CoffeeMakerAppLevelDependencyContainer>(context);

        return AppLifecycleObserver(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.themeData(context),
            routerDelegate: appLevelDependencyContainer.appRouterDelegate,
            routeInformationParser:
                appLevelDependencyContainer.appRouteInformationParser,
            backButtonDispatcher:
                appLevelDependencyContainer.backButtonDispatcher,
          ),
        );
      }),
    );
  }
}
