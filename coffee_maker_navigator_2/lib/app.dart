import 'package:coffee_maker_navigator_2/di/dependency_container_manager.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/injector.dart';
import 'package:coffee_maker_navigator_2/ui/router/view/app_router_delegate.dart';
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
  late final AppRouterDelegate _appRouterDelegate;
  late final BackButtonDispatcher _backButtonDispatcher;
  late final DependencyContainerManager _containerManager;

  @override
  void initState() {
    super.initState();
    _appRouterDelegate = AppRouterDelegate();
    _backButtonDispatcher = RootBackButtonDispatcher();
    _containerManager = DependencyContainerManager();
  }

  @override
  void dispose() {
    _appRouterDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
      containerManager: _containerManager,
      child: ChangeNotifierProvider<RouterViewModel>(
        create: (_) => _containerManager
            .getContainer<AppLevelDependencyContainer>()
            .routerViewModel,
        builder: (context, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.themeData(context),
            routerDelegate: _appRouterDelegate,
            backButtonDispatcher: _backButtonDispatcher,
          );
        },
      ),
    );
  }
}
