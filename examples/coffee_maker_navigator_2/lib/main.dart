import 'package:coffee_maker_navigator_2/app/app.dart';
import 'package:wolt_di/wolt_di.dart';
import 'package:coffee_maker_navigator_2/features/add_water/di/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/login/di/login_screen_dependency_container.dart';
import 'package:coffee_maker_navigator_2/app/di/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/orders/di/orders_dependency_container.dart';
import 'package:flutter/material.dart';

void _registerFeatureLevelDependencyContainers(
    DependencyContainerManager manager) {
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
|  | +-------------------------+ | |       |  |  |                       |  | |
|  | | AuthRemoteDataSource    | | |       |  |  |                       |  | |
|  | +-------------------------+ | |       |  |  |                       |  | |
|  | | RouterViewModel         | | |       |  |  |        Feature        |  | |
|  | +-------------------------+ | |       |  |  |      Screen Widget    |  | |
|  +-----------------------------+ |       |  |  |                       |  | |
|                                  |       |  |  |                       |  | |
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
  ///
  /// The app-level dependency container is responsible for managing the dependencies used
  /// as long as app is alive. These dependencies can be shared across multiple feature level
  /// dependency containers. It is the only container that is initialized asynchronously.
  final dependencyContainerManager = DependencyContainerManager.instance;
  await dependencyContainerManager
      .init(CoffeeMakerAppLevelDependencyContainer());

  /// STEP #2: Register feature-level dependency containers.
  ///
  /// Here, we register dependency containers for specific features, like Orders, AddWater, and
  /// LoginScreen with the `DependencyContainerManager`. Each feature has its own container to
  /// manage its group of dependencies.
  ///
  /// This uses a Service Locator pattern, where dependencies are registered and retrieved as needed.
  /// Additionally, the `DependencyContainerManager` automatically disposes of containers that
  /// are no longer needed and have no active subscribers, helping manage resources efficiently.
  _registerFeatureLevelDependencyContainers(dependencyContainerManager);

  runApp(const CoffeeMakerApp());
}
