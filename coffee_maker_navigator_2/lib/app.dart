import 'package:coffee_maker_navigator_2/di/dependency_container_manager.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/injector.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeMakerApp extends StatefulWidget {
  const CoffeeMakerApp({Key? key}) : super(key: key);

  @override
  State<CoffeeMakerApp> createState() => _CoffeeMakerAppState();
}

class _CoffeeMakerAppState extends State<CoffeeMakerApp> {
  late final DependencyContainerManager _dependencyContainerManager;
  late final CoffeeMakerAppLevelDependencyContainer
      _appLevelDependencyContainer;

  @override
  void initState() {
    super.initState();
    _dependencyContainerManager = DependencyContainerManager.instance;
    _appLevelDependencyContainer = _dependencyContainerManager
        .getDependencyContainer<CoffeeMakerAppLevelDependencyContainer>();
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
      containerManager: _dependencyContainerManager,
      child: ChangeNotifierProvider<RouterViewModel>(
        create: (_) => _appLevelDependencyContainer.routerViewModel,
        builder: (context, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.themeData(context),
            routerDelegate: _appLevelDependencyContainer.appRouterDelegate,
            backButtonDispatcher:
                _appLevelDependencyContainer.backButtonDispatcher,
          );
        },
      ),
    );
  }
}
