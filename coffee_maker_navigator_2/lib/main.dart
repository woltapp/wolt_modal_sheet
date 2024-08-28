import 'package:coffee_maker_navigator_2/app/app.dart';
import 'package:wolt_di/wolt_di.dart';
import 'package:coffee_maker_navigator_2/features/add_water/di/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/login/di/login_screen_dependency_container.dart';
import 'package:coffee_maker_navigator_2/app/di/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/orders/di/orders_dependency_container.dart';
import 'package:flutter/material.dart';

void _registerDependencyContainerFactories(DependencyContainerManager manager) {
  manager
    ..registerContainerFactory<OrdersDependencyContainer>(
        () => OrdersDependencyContainer())
    ..registerContainerFactory<AddWaterDependencyContainer>(
        () => AddWaterDependencyContainer())
    ..registerContainerFactory<LoginScreenDependencyContainer>(
        () => LoginScreenDependencyContainer());
}

/*
+----------------------------------+
|  DependencyContainerManager      |       +----------------------------------+
|  +-----------------------------+ |       |                                  |
|  | App Level DI Container      | |       |          MaterialApp             |
|  | +-------------------------+ | |       |  +-----------------------------+ |
|  | | AuthService             | | |       |  |    DependencyInjector       | |
|  | +-------------------------+ | |       |  |          Widget             | |
|  | | AuthRepository          | | |       |  |  +-----------------------+  | |
|  | +-------------------------+ | |       |  |  | FeatureLevelDependency|  | |
|  | | AuthRemoteDataSource    | | |       |  |  |        Container      |  | |
|  | +-------------------------+ | |       |  |  | +-------------------+ |  | |
|  | | RouterViewModel         | | |       |  |  | |      Feature      | |  | |
|  | +-------------------------+ | |       |  |  | |    Screen Widget  | |  | |
|  +-----------------------------+ |       |  |  | |                   | |  | |
|                                  |       |  |  | +-------------------+ |  | |
|  +-----------------------------+ |       |  |  |                       |  | |
|  | OrdersDependencyContainer   | |       |  |  +-----------------------+  | |
|  | +-------------------------+ | |       |  +-----------------------------+ |
|  | | OrderService            | | |       |                                  |
|  | +-------------------------+ | |       +----------------------------------+
|  | | OrdersRepository        | | |
|  | +-------------------------+ | |
|  | | OrdersRemoteDataSource  | | |
|  | +-------------------------+ | |
|  | | OrderScreenVM (Factory) | | |
|  | +-------------------------+ | |
|  +-----------------------------+ |
|                                  |
|  +-----------------------------+ |
|  | AddWaterDependencyContainer | |
|  | +-------------------------+ | |
|  | |AddWaterScreenVM(Factory)| | |
|  | +-------------------------+ | |
|  | | AddWaterService         | | |
|  | +-------------------------+ | |
|  +-----------------------------+ |
+----------------------------------+
*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// STEP #1: Initialize the dependency container manager with the App-level dependency container.
  final dependencyContainerManager = DependencyContainerManager.instance;
  await dependencyContainerManager
      .init(CoffeeMakerAppLevelDependencyContainer());

  /// STEP #2: Register the feature level dependency container factories.
  _registerDependencyContainerFactories(dependencyContainerManager);
  runApp(const CoffeeMakerApp());
}
