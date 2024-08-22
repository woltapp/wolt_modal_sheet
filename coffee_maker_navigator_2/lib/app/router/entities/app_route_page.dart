import 'package:coffee_maker_navigator_2/app/router/entities/app_route_configuration.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_path.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/add_water_screen.dart';
import 'package:coffee_maker_navigator_2/features/login/ui/view/login_screen.dart';
import 'package:coffee_maker_navigator_2/features/onboarding/ui/view/onboarding_modal_sheet_page.dart';
import 'package:coffee_maker_navigator_2/features/orders/di/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/grind/grind_or_reject_modal_page.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/grind/reject_order_modal_page.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/not_found/order_not_found_modal.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/ready/offer_recommendation_modal_page.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/ready/serve_or_offer_modal_page.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/orders_screen.dart';
import 'package:coffee_maker_navigator_2/features/tutorial/view/single_tutorial_screen.dart';
import 'package:coffee_maker_navigator_2/features/tutorial/view/tutorials_screen.dart';
import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:wolt_di/wolt_di.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

sealed class AppRoutePage<T> extends Page<T> {
  const AppRoutePage({LocalKey? key, this.configuration}) : super(key: key);

  final AppRouteConfiguration? configuration;
}

class BootstrapRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'bootstrap';

  const BootstrapRoutePage()
      : super(
          key: const ValueKey('BootstrapRoutePage'),
          configuration:
              const AppRouteConfiguration(appRoutePath: AppRoutePath.bootstrap),
        );

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      settings: this,
    );
  }
}

class LoginRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'login';

  const LoginRoutePage()
      : super(
          key: const ValueKey('LoginRoutePage'),
          configuration:
              const AppRouteConfiguration(appRoutePath: AppRoutePath.login),
        );

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) => const LoginScreen(),
      settings: this,
    );
  }
}

class OrdersRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'orders';

  const OrdersRoutePage([this.initialBottomNavBarTab])
      : super(
          key: const ValueKey('OrdersRoutePage'),
          configuration:
              const AppRouteConfiguration(appRoutePath: AppRoutePath.orders),
        );

  final CoffeeMakerStep? initialBottomNavBarTab;

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) => OrdersScreen(
        initialBottomNavBarTab,
      ),
      settings: this,
    );
  }
}

class AddWaterRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'addWater';

  AddWaterRoutePage(this.coffeeOrderId)
      : super(
          key: ValueKey(coffeeOrderId),
          configuration: AppRouteConfiguration(
            appRoutePath: AppRoutePath.addWater,
            queryParams: {AppRoutePath.queryParamId: coffeeOrderId},
          ),
        );

  final String coffeeOrderId;

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) {
        return AddWaterScreen(
          coffeeOrderId: coffeeOrderId,
        );
      },
      settings: this,
    );
  }
}

class SingleTutorialRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'singleTutorial';

  SingleTutorialRoutePage(this.coffeeMakerStep)
      : super(
          key: ValueKey(coffeeMakerStep),
          configuration: AppRouteConfiguration(
            appRoutePath: AppRoutePath.fromCoffeeMakerStep(coffeeMakerStep),
          ),
        );

  final CoffeeMakerStep coffeeMakerStep;

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) =>
          SingleTutorialScreen(coffeeMakerStep: coffeeMakerStep),
      settings: this,
    );
  }
}

class TutorialsRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'tutorials';

  const TutorialsRoutePage()
      : super(
          key: const ValueKey('TutorialsRoutePage'),
          configuration:
              const AppRouteConfiguration(appRoutePath: AppRoutePath.tutorials),
        );

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) => const TutorialsScreen(),
      settings: this,
    );
  }
}

class OnboardingModalRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'onboarding';

  const OnboardingModalRoutePage()
      : super(
          key: const ValueKey('OnboardingRoutePage'),
          configuration: const AppRouteConfiguration(
              appRoutePath: AppRoutePath.onboarding),
        );

  @override
  Route<void> createRoute(BuildContext context) {
    return WoltModalSheetRoute(
      settings: this,
      pageListBuilderNotifier: ValueNotifier(
        (context) => [OnboardingModalSheetPage()],
      ),
      onModalDismissedWithDrag:
          context.routerViewModel.onCloseOnboardingModalSheet,
      onModalDismissedWithBarrierTap:
          context.routerViewModel.onCloseOnboardingModalSheet,
    );
  }
}

class GrindCoffeeModalRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'grindCoffee';

  final String coffeeOrderId;

  GrindCoffeeModalRoutePage({required this.coffeeOrderId})
      : super(
          key: ValueKey('GrindCoffeeModalRoutePage-$coffeeOrderId'),
          configuration: AppRouteConfiguration(
            appRoutePath: AppRoutePath.grindCoffeeModal,
            queryParams: {AppRoutePath.queryParamId: coffeeOrderId},
          ),
        );

  @override
  Route<void> createRoute(BuildContext context) {
    final viewModel =
        DependencyInjector.container<OrdersDependencyContainer>(context)
            .createViewModel();
    return WoltModalSheetRoute(
      settings: this,
      pageListBuilderNotifier: ValueNotifier(
        (context) {
          final orderExists = viewModel.orderExists(
            coffeeOrderId,
            CoffeeMakerStep.grind,
          );
          return [
            if (orderExists) ...[
              GrindOrRejectModalPage(
                  coffeeOrderId: coffeeOrderId,
                  onCoffeeOrderGrindCompleted: () {
                    viewModel.onOrderStatusChange(
                        coffeeOrderId, CoffeeMakerStep.addWater);
                    context.routerViewModel.onGrindCoffeeCompleted();
                  }),
              RejectOrderModalPage(
                coffeeOrderId: coffeeOrderId,
                onCoffeeOrderRejected: () {
                  viewModel.onOrderStatusChange(coffeeOrderId);
                  context.routerViewModel.onGrindCoffeeCompleted();
                },
              ),
            ] else
              OrderNotFoundModal(coffeeOrderId, CoffeeMakerStep.grind),
          ];
        },
      ),
    );
  }
}

class ReadyCoffeeModalRoutePage extends AppRoutePage<void> {
  @override
  String get name => routeName;

  static const String routeName = 'readyCoffee';

  final String coffeeOrderId;

  ReadyCoffeeModalRoutePage({required this.coffeeOrderId})
      : super(
          key: ValueKey('ReadyCoffeeModalRoutePage-$coffeeOrderId'),
          configuration: AppRouteConfiguration(
            appRoutePath: AppRoutePath.readyCoffeeModal,
            queryParams: {AppRoutePath.queryParamId: coffeeOrderId},
          ),
        );

  @override
  Route<void> createRoute(BuildContext context) {
    final viewModel =
        DependencyInjector.container<OrdersDependencyContainer>(context)
            .createViewModel();
    return WoltModalSheetRoute(
      settings: this,
      pageListBuilderNotifier: ValueNotifier((context) {
        final orderExists = viewModel.orderExists(
          coffeeOrderId,
          CoffeeMakerStep.ready,
        );
        return [
          if (orderExists) ...[
            ServeOrOfferModalPage(
              coffeeOrderId: coffeeOrderId,
              onCoffeeOrderServed: () {
                viewModel.onOrderStatusChange(coffeeOrderId);
                context.routerViewModel.onReadyCoffeeStepCompleted();
              },
            ),
            OfferRecommendationModalPage.build(
              coffeeOrderId: coffeeOrderId,
              onCoffeeOrderServed: () {
                viewModel.onOrderStatusChange(coffeeOrderId);
                context.routerViewModel.onReadyCoffeeStepCompleted();
              },
            ),
          ] else
            OrderNotFoundModal(coffeeOrderId, CoffeeMakerStep.ready),
        ];
      }),
    );
  }
}
