import 'package:coffee_maker_navigator_2/di/dependency_container_manager.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/app_level_dependency_container.dart';
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
  late final DependencyContainerManager _containerManager;
  late final AppLevelDependencyContainer _appLevelDependencyContainer;

  @override
  void initState() {
    super.initState();
    _containerManager = DependencyContainerManager();
    _appLevelDependencyContainer =
        _containerManager.getContainer<AppLevelDependencyContainer>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
      containerManager: _containerManager,
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
