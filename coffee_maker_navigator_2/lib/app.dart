import 'package:wolt_di/wolt_di.dart';
import 'package:coffee_maker_navigator_2/di/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeMakerApp extends StatelessWidget {
  const CoffeeMakerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      child: Builder(builder: (context) {
        final appLevelDependencyContainer = DependencyInjector.container<
            CoffeeMakerAppLevelDependencyContainer>(context);

        return ChangeNotifierProvider<RouterViewModel>(
          create: (_) => appLevelDependencyContainer.routerViewModel,
          builder: (context, _) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppThemeData.themeData(context),
              routerDelegate: appLevelDependencyContainer.appRouterDelegate,
              backButtonDispatcher:
                  appLevelDependencyContainer.backButtonDispatcher,
            );
          },
        );
      }),
    );
  }
}
