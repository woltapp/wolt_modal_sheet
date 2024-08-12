import 'package:coffee_maker_navigator_2/app.dart';
import 'package:coffee_maker_navigator_2/di/di.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/auth_screen_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/add_water_dependency_container.dart';
import 'package:flutter/material.dart';

void _registerDependencyContainerFactories(
    DependencyContainerFactoryRegistrar registrar) {
  registrar
    ..registerContainerFactory<OrdersDependencyContainer>(
      (accessHandler) => OrdersDependencyContainer(
        dependencyContainerAccessHandler: accessHandler,
      ),
    )
    ..registerContainerFactory<AddWaterDependencyContainer>(
      (accessHandler) => AddWaterDependencyContainer(
        dependencyContainerAccessHandler: accessHandler,
      ),
    )
    ..registerContainerFactory<AuthScreenDependencyContainer>(
      (accessHandler) => AuthScreenDependencyContainer(
        dependencyContainerAccessHandler: accessHandler,
      ),
    );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencyContainerManager = DependencyContainerManager.instance;
  await dependencyContainerManager.init();
  _registerDependencyContainerFactories(dependencyContainerManager);
  runApp(CoffeeMakerApp(
      dependencyContainerAccessHandler: dependencyContainerManager));
}
