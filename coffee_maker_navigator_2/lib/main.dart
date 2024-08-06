import 'package:coffee_maker_navigator_2/data/di/data_di_module.dart';
import 'package:coffee_maker_navigator_2/di/dependency_injection.dart';
import 'package:coffee_maker_navigator_2/di/di/container_manager.dart';
import 'package:coffee_maker_navigator_2/di/di/containers.dart';
import 'package:coffee_maker_navigator_2/di/di/injector.dart';
import 'package:coffee_maker_navigator_2/domain/di/domain_di_module.dart';
import 'package:coffee_maker_navigator_2/ui/di/ui_di_module.dart';
import 'package:coffee_maker_navigator_2/ui/router/view/app_router_delegate.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataDiModule.setup();
  await DomainDiModule.setup();
  await UiDiModule.setup();
  runApp(const CoffeeMakerApp());
}

class CoffeeMakerApp extends StatefulWidget {
  const CoffeeMakerApp({Key? key}) : super(key: key);

  @override
  State<CoffeeMakerApp> createState() => _CoffeeMakerAppState();
}

class _CoffeeMakerAppState extends State<CoffeeMakerApp> {
  late final AppRouterDelegate _appRouterDelegate;
  late final BackButtonDispatcher _backButtonDispatcher;
  late final ContainerManager _containerManager;

  @override
  void initState() {
    super.initState();
    _appRouterDelegate = AppRouterDelegate();
    _backButtonDispatcher = RootBackButtonDispatcher();
    _containerManager = ContainerManager.instance
      ..registerDependency<OrdersDependencies>(
        (deps) => OrdersDependencies(deps as AppDependencies),
      );
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
        create: (_) => DependencyInjection.get<RouterViewModel>()..onInit(),
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
