import 'package:coffee_maker_navigator_2/di/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:wolt_di/wolt_di.dart';

extension AppLevelDependencyContainerExtensions on BuildContext {
  RouterViewModel get routerViewModel =>
      DependencyInjector.container<CoffeeMakerAppLevelDependencyContainer>(this)
          .routerViewModel;
}
