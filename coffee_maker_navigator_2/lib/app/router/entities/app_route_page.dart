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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_di/wolt_di.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// `AppRoutePage` is a sealed class that extends Flutter's [Page] class. It serves as a base
/// class for all route pages within the application, defining a consistent interface and behavior
/// for routes.
///
/// One of the main benefits of a sealed class is that it guarantees exhaustiveness.
/// Since all possible subclasses of `AppRoutePage` are known at compile time, the application can
/// ensure that every route is explicitly handled. This helps prevent errors that can arise from
/// unhandled routes or navigation scenarios, leading to more robust and predictable routing behavior.
/// When working with pattern matching or switch cases on instances of `AppRoutePage`, the compiler
/// can enforce that all cases are covered, reducing the risk of runtime errors.
///
///   Each subclass of `AppRoutePage` must specify an [AppRouteUriTemplate] that represents the
///   static route template associated with the page. The `queryParams` getter allows each page
///   to define any dynamic query parameters it might need. This is crucial for passing state or
///   configuration data through the URL, supporting more sophisticated navigation scenarios and
///   state management.x
sealed class AppRoutePage<T> extends Page<T> {
  const AppRoutePage({LocalKey? key}) : super(key: key);
}

class BootstrapRoutePage extends AppRoutePage<void> {
  static const String routeName = 'bootstrap';

  @override
  String get name => routeName;

  const BootstrapRoutePage() : super(key: const ValueKey('BootstrapRoutePage'));

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

  const LoginRoutePage() : super(key: const ValueKey('LoginRoutePage'));

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

  const OrdersRoutePage()
      : super(key: const ValueKey('OrdersRoutePage'));

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) => const OrdersScreen(),
      settings: this,
    );
  }
}

class AddWaterRoutePage extends AppRoutePage<void> {

  @override
  String get name => routeName;

  static const String routeName = 'addWater';

  AddWaterRoutePage(this.coffeeOrderId) : super(key: ValueKey(coffeeOrderId));

  final String coffeeOrderId;

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (_) => AddWaterScreen(coffeeOrderId: coffeeOrderId),
      settings: this,
    );
  }
}

class SingleTutorialRoutePage extends AppRoutePage<void> {

  @override
  String get name => routeName;

  static const String routeName = 'singleTutorial';

  SingleTutorialRoutePage(this.coffeeMakerStep)
      : super(key: ValueKey(coffeeMakerStep));

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

  const TutorialsRoutePage() : super(key: const ValueKey('TutorialsRoutePage'));

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
      : super(key: const ValueKey('OnboardingRoutePage'));

  @override
  Route<void> createRoute(BuildContext context) {
    return WoltModalSheetRoute(
      settings: this,
      pageListBuilderNotifier: ValueNotifier(
        (context) => [OnboardingModalSheetPage()],
      ),
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
                    context.routerViewModel.onOrderStepCompleted();
                  }),
              RejectOrderModalPage(
                coffeeOrderId: coffeeOrderId,
                onCoffeeOrderRejected: () {
                  viewModel.onOrderStatusChange(coffeeOrderId);
                  context.routerViewModel.onOrderStepCompleted();
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
      : super(key: ValueKey('ReadyCoffeeModalRoutePage-$coffeeOrderId'));

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
                context.routerViewModel.onOrderStepCompleted();
              },
            ),
            OfferRecommendationModalPage.build(
              coffeeOrderId: coffeeOrderId,
              onCoffeeOrderServed: () {
                viewModel.onOrderStatusChange(coffeeOrderId);
                context.routerViewModel.onOrderStepCompleted();
              },
            ),
          ] else
            OrderNotFoundModal(coffeeOrderId, CoffeeMakerStep.ready),
        ];
      }),
    );
  }
}
