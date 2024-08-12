import 'package:coffee_maker_navigator_2/app.dart';
import 'package:coffee_maker_navigator_2/di/di.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/auth_screen_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/orders_dependency_container.dart';
import 'package:flutter/material.dart';

void _registerDependencyContainerFactories(
    DependencyContainerRegistrar registrar) {
  registrar
    ..registerContainerFactory<OrdersDependencyContainer>(
      (r) => OrdersDependencyContainer(resolver: r),
    )
    ..registerContainerFactory<AddWaterDependencyContainer>(
      (r) => AddWaterDependencyContainer(resolver: r),
    )
    ..registerContainerFactory<AuthScreenDependencyContainer>(
      (r) => AuthScreenDependencyContainer(resolver: r),
    );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencyContainerManager = DependencyContainerManager.instance;
  final appLevelDependencyContainer = CoffeeMakerAppLevelDependencyContainer();
  await dependencyContainerManager.init(appLevelDependencyContainer);
  _registerDependencyContainerFactories(dependencyContainerManager);
  runApp(const CoffeeMakerApp());
}
