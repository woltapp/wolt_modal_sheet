import 'package:coffee_maker_navigator_2/app.dart';
import 'package:coffee_maker_navigator_2/di/dependency_container_manager.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/auth_screen_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/orders_dependency_container.dart';
import 'package:flutter/material.dart';

void _registerDependencyContainerFactories() {
  final manager = DependencyContainerManager.instance;
  manager
    ..registerContainerFactory<OrdersDependencyContainer>(
      (resolver) => OrdersDependencyContainer(
        dependencyContainerManager: manager,
      ),
    )
    ..registerContainerFactory<AddWaterDependencyContainer>(
      (resolver) => AddWaterDependencyContainer(
        dependencyContainerManager: manager,
      ),
    )
    ..registerContainerFactory<AuthScreenDependencyContainer>(
      (resolver) => AuthScreenDependencyContainer(
        dependencyContainerManager: manager,
      ),
    );
}

Future<void> _initDependencyContainerManager() async {
  final manager = DependencyContainerManager.instance;
  await manager.init();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initDependencyContainerManager();
  _registerDependencyContainerFactories();
  runApp(const CoffeeMakerApp());
}
