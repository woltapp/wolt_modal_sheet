import 'package:coffee_maker_navigator_2/app.dart';
import 'package:coffee_maker_navigator_2/di/dependency_container_manager.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/auth_screen_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/orders_dependency_container.dart';
import 'package:flutter/material.dart';

void _registerDependencyContainerFactories() {
  final manager = DependencyContainerManager.instance;
  manager
    // Mikhail: Init is very easy to freeze, what can we do?
    // There shouldn't be heavy operation, they are called by demand one by one
    // and we can use lazyness inside. Shouldn't be a problem.
    ..registerContainerFactory<OrdersDependencyContainer>(
      (resolver) => OrdersDependencyContainer(resolver: resolver),
    )
    ..registerContainerFactory<AddWaterDependencyContainer>(
      (resolver) => AddWaterDependencyContainer(resolver: resolver),
    )
    ..registerContainerFactory<AuthScreenDependencyContainer>(
      (resolver) => AuthScreenDependencyContainer(resolver: resolver),
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
