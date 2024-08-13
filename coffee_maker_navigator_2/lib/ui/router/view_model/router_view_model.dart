import 'dart:async';

import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/domain/onboarding/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/orders_screen.dart';
import 'package:coffee_maker_navigator_2/ui/router/entities/app_route_page.dart';
import 'package:coffee_maker_navigator_2/ui/router/entities/app_route_settings_name.dart';
import 'package:coffee_maker_navigator_2/ui/widgets/app_navigation_drawer.dart';
import 'package:flutter/material.dart';

class RouterViewModel {
  final AuthService authService;
  final OnboardingService onboardingService;
  late final ValueNotifier<List<AppRoutePage>> pages = ValueNotifier([]);
  final ValueNotifier<CoffeeMakerStep> bottomNavigationTabInOrdersPage =
      ValueNotifier(CoffeeMakerStep.grind);

  final ValueNotifier<bool> isTutorialModalShown = ValueNotifier(false);

  RouterViewModel({
    required bool isUserLoggedIn,
    required bool isTutorialShown,
    required this.authService,
    required this.onboardingService,
  }) {
    pages.value = [
      if (isUserLoggedIn) const OrdersRoutePage() else const AuthRoutePage(),
      if (isUserLoggedIn && !isTutorialShown) const OnboardingModalRoutePage(),
    ];
    authService.authStateListenable.addListener(_authStateChangeSubscription);
  }

  void dispose() {
    authService.authStateListenable
        .removeListener(_authStateChangeSubscription);
    pages.dispose();
    bottomNavigationTabInOrdersPage.dispose();
  }

  void _authStateChangeSubscription() {
    final isLoggedIn = authService.authStateListenable.value ?? false;
    if (isLoggedIn) {
      final shouldShowTutorial = !onboardingService.isTutorialShown();
      pages.value = [
        const OrdersRoutePage(),
        if (shouldShowTutorial) const OnboardingModalRoutePage(),
      ];
    } else {
      pages.value = [const AuthRoutePage()];
    }
  }

  void _navigateToOrdersScreen({
    CoffeeMakerStep? destinationBottomNavBarTab,
  }) {
    pages.value = [const OrdersRoutePage()];
    if (destinationBottomNavBarTab != null) {
      bottomNavigationTabInOrdersPage.value = destinationBottomNavBarTab;
    }
  }

  void _navigateToTutorialsScreen() {
    pages.value = [const TutorialsRoutePage()];
  }

  void _navigateToSingleTutorialScreen(
    CoffeeMakerStep coffeeMakerStep,
  ) {
    pages.value = [
      const TutorialsRoutePage(),
      SingleTutorialRoutePage(coffeeMakerStep),
    ];
  }

  void _navigateToAddWaterScreen(String coffeeOrderId) {
    pages.value = [
      const OrdersRoutePage(),
      AddWaterRoutePage(coffeeOrderId),
    ];
  }

  void onPagePoppedImperatively({required String poppingPageName}) {
    final routeSettingName = RouteSettingsName.findFromPageName(
      poppingPageName,
    );
    switch (routeSettingName) {
      case RouteSettingsName.auth:
      case RouteSettingsName.orders:
        break;
      case RouteSettingsName.singleTutorial:
        _navigateToTutorialsScreen();
      case RouteSettingsName.tutorials:
      case RouteSettingsName.addWater:
      case RouteSettingsName.onboarding:
      case RouteSettingsName.grindCoffee:
        _navigateToOrdersScreen();
    }
  }

  /// The pops caused by Android swipe gesture and hardware button
  /// is handled in here instead of Navigator's onPopPage callback.
  /// Returning false will cause the entire app to be popped.
  Future<bool> onPagePoppedWithOperatingSystemIntent() {
    switch (pages.value.last) {
      case AuthRoutePage():
      case OrdersRoutePage():
        // false means the entire app will be popped.
        return Future.value(false);
      case AddWaterRoutePage():
        _navigateToOrdersScreen(
            destinationBottomNavBarTab: CoffeeMakerStep.addWater);

        // true means the current page will be popped.
        return Future.value(true);
      case SingleTutorialRoutePage():
        _navigateToTutorialsScreen();

        return Future.value(true);
      case GrindCoffeeModalRoutePage():
      case TutorialsRoutePage():
      case OnboardingModalRoutePage():
        _navigateToOrdersScreen();
        return Future.value(true);
    }
  }

  void onCloseOnboardingModalSheet() {
    _navigateToOrdersScreen();
  }

  void onUserRequestedTutorialFromOnboardingModal() {
    onboardingService.markTutorialShown();
    _navigateToTutorialsScreen();
  }

  void onAddWaterStepCompleted() {
    _navigateToOrdersScreen(destinationBottomNavBarTab: CoffeeMakerStep.ready);
  }

  void onDrawerDestinationSelected(
    AppNavigationDrawerDestination destination,
  ) {
    switch (destination) {
      case AppNavigationDrawerDestination.ordersScreen:
        _navigateToOrdersScreen();
        break;
      case AppNavigationDrawerDestination.tutorialsScreen:
        _navigateToTutorialsScreen();
        break;
      case AppNavigationDrawerDestination.logOut:
        authService.logOut();
        break;
    }
  }

  void onTutorialDetailSelected(CoffeeMakerStep coffeeMakerStep) {
    _navigateToSingleTutorialScreen(coffeeMakerStep);
  }

  void onAddWaterStepEntering(String coffeeOrderId) {
    _navigateToAddWaterScreen(coffeeOrderId);
  }

  void onOrdersScreenBottomNavBarUpdated(CoffeeMakerStep selectedStep) {
    bottomNavigationTabInOrdersPage.value = selectedStep;
  }

  void onGrindStepEntering(
    String id,
    OnCoffeeOrderStatusChange onCoffeeOrderStatusChange,
  ) {
    pages.value = [
      const OrdersRoutePage(),
      GrindCoffeeModalRoutePage(id, onCoffeeOrderStatusChange),
    ];
  }

  void onGrindStepExit({required bool hasStartedGrinding}) {
    bottomNavigationTabInOrdersPage.value =
        hasStartedGrinding ? CoffeeMakerStep.addWater : CoffeeMakerStep.grind;
  }
}
