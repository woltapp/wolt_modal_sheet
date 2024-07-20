import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/ui/add_water/view/widgets/add_water_screen.dart';
import 'package:coffee_maker_navigator_2/ui/auth/view/auth_screen.dart';
import 'package:coffee_maker_navigator_2/ui/onboarding/view/onboarding_modal_sheet_page.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/modal_pages/grind/grind_or_reject_modal_page.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/modal_pages/grind/reject_order_modal_page.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/orders_screen.dart';
import 'package:coffee_maker_navigator_2/ui/router/entities/app_route_settings_name.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/tutorials/view/single_tutorial_screen.dart';
import 'package:coffee_maker_navigator_2/ui/tutorials/view/tutorials_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

sealed class AppRoutePage<T> extends Page<T> {
  const AppRoutePage({LocalKey? key}) : super(key: key);
}

class AuthRoutePage extends AppRoutePage<void> {
  @override
  String get name => RouteSettingsName.auth.routeName;

  const AuthRoutePage() : super(key: const ValueKey('AuthRoutePage'));

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) => const AuthScreen(),
      settings: this,
    );
  }
}

class OrdersRoutePage extends AppRoutePage<void> {
  @override
  String get name => RouteSettingsName.orders.routeName;

  const OrdersRoutePage() : super(key: const ValueKey('OrdersRoutePage'));

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
  String get name => RouteSettingsName.addWater.routeName;

  AddWaterRoutePage(this.coffeeOrderId) : super(key: ValueKey(coffeeOrderId));

  final String coffeeOrderId;

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (context) {
        return AddWaterScreen(coffeeOrderId: coffeeOrderId);
      },
      settings: this,
    );
  }
}

class SingleTutorialRoutePage extends AppRoutePage<void> {
  @override
  String get name => RouteSettingsName.singleTutorial.routeName;

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
  String get name => RouteSettingsName.tutorials.routeName;

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
  String get name => RouteSettingsName.onboarding.routeName;

  const OnboardingModalRoutePage()
      : super(key: const ValueKey('OnboardingRoutePage'));

  @override
  Route<void> createRoute(BuildContext context) {
    return WoltModalSheetRoute(
      settings: this,
      pageListBuilderNotifier: ValueNotifier(
        (context) => [OnboardingModalSheetPage()],
      ),
      onModalDismissedWithDrag:
          context.read<RouterViewModel>().onCloseOnboardingModalSheet,
      onModalDismissedWithBarrierTap:
          context.read<RouterViewModel>().onCloseOnboardingModalSheet,
    );
  }
}

class GrindCoffeeModalRoutePage extends AppRoutePage<void> {
  @override
  String get name => RouteSettingsName.onboarding.routeName;

  final String coffeeOrderId;
  final void Function(String orderId, [CoffeeMakerStep? newStep])
      onCoffeeOrderStatusChange;

  GrindCoffeeModalRoutePage(
    this.coffeeOrderId,
    this.onCoffeeOrderStatusChange,
  ) : super(key: ValueKey('GrindCoffeeModalRoutePage-$coffeeOrderId'));

  @override
  Route<void> createRoute(BuildContext context) {
    return WoltModalSheetRoute(
      settings: this,
      pageListBuilderNotifier: ValueNotifier(
        (context) => [
          GrindOrRejectModalPage(coffeeOrderId, onCoffeeOrderStatusChange),
          RejectOrderModalPage(coffeeOrderId, onCoffeeOrderStatusChange),
        ],
      ),
    );
  }
}
