import 'package:coffee_maker_navigator_2/app.dart';
import 'package:coffee_maker_navigator_2/data/di/data_di_module.dart';
import 'package:coffee_maker_navigator_2/di/di/dependency_container_manager.dart';
import 'package:coffee_maker_navigator_2/di/di/dependency_containers/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/di/domain_di_module.dart';
import 'package:coffee_maker_navigator_2/ui/di/ui_di_module.dart';
import 'package:flutter/material.dart';

void _registerDependencyContainerFactories() {
  final manager = DependencyContainerManager.instance;
  manager.registerContainerFactory((_) => OrdersDependencyContainer());
}

Future<void> _initDependencyContainerManager() async {
  final manager = DependencyContainerManager.instance;
  await manager.init();
  manager.registerContainerFactory((_) => OrdersDependencyContainer());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initDependencyContainerManager();
  _registerDependencyContainerFactories();
  await DataDiModule.setup();
  await DomainDiModule.setup();
  await UiDiModule.setup();
  runApp(const CoffeeMakerApp());
}
