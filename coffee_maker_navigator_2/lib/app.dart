import 'package:coffee_maker_navigator_2/di/di.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeMakerApp extends StatelessWidget {
  const CoffeeMakerApp({
    required this.dependencyContainerResolver,
    Key? key,
  }) : super(key: key);

  final DependencyContainerResolver dependencyContainerResolver;

  @override
  Widget build(BuildContext context) {
    final appLevelDependencyContainer = dependencyContainerResolver
        .getDependencyContainer<CoffeeMakerAppLevelDependencyContainer>();

    return DependencyContainerInjector(
      dependencyContainerResolver: dependencyContainerResolver,
      child: ChangeNotifierProvider<RouterViewModel>(
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
      ),
    );
  }
}
