import 'dart:async';

import 'package:coffee_maker_navigator_2/app/auth/domain/auth_service.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_page.dart';
import 'package:coffee_maker_navigator_2/app/ui/widgets/app_navigation_drawer.dart';
import 'package:coffee_maker_navigator_2/features/onboarding/domain/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:flutter/foundation.dart';

class RouterViewModel {
  final AuthService authService;
  final OnboardingService onboardingService;
  late final ValueNotifier<List<AppRoutePage>> _pages =
      ValueNotifier([const BootstrapRoutePage()]);

  ValueListenable<List<AppRoutePage>> get pages => _pages;

  RouterViewModel({
    required this.authService,
    required this.onboardingService,
  }) {
    authService.authStateListenable.addListener(_authStateChangeSubscription);
  }

  void dispose() {
    authService.authStateListenable
        .removeListener(_authStateChangeSubscription);
    _pages.dispose();
  }

  void onPagePoppedImperatively() {
    _popPage();
  }

  void onDrawerDestinationSelected(
    AppNavigationDrawerDestination destination,
  ) {
    switch (destination) {
      case AppNavigationDrawerDestination.ordersScreen:
        _pages.value = [const OrdersRoutePage()];
        break;
      case AppNavigationDrawerDestination.tutorialsScreen:
        _pages.value = [
          const OrdersRoutePage(),
          const TutorialsRoutePage(),
        ];
        break;
      case AppNavigationDrawerDestination.logOut:
        authService.logOut();
        break;
    }
  }

  /// The pops caused by Android swipe gesture and hardware button
  /// is handled in here instead of Navigator's onPopPage callback.
  /// Returning false will cause the entire app to be popped.
  Future<bool> onPagePoppedWithOperatingSystemIntent() {
    switch (_pages.value.last) {
      case BootstrapRoutePage():
      case AuthRoutePage():
      case OrdersRoutePage():
        // false means the entire app will be popped.
        return Future.value(false);
      case SingleTutorialRoutePage():
      case AddWaterRoutePage():
      case ReadyCoffeeModalRoutePage():
      case TutorialsRoutePage():
      case OnboardingModalRoutePage():
      case GrindCoffeeModalRoutePage():
        _popPage();
        // true means the current page will be popped.
        return Future.value(true);
    }
  }

  void onCloseOnboardingModalSheet() {
    _popPage();
  }

  void onUserRequestedTutorialFromOnboardingModal() {
    onboardingService.markTutorialShown();
    _pushPage(const TutorialsRoutePage());
  }

  void onAddWaterStepCompleted() {
    _popPage();
  }

  void onTutorialDetailSelected(CoffeeMakerStep coffeeMakerStep) {
    _pushPage(SingleTutorialRoutePage(coffeeMakerStep));
  }

  void onGrindCoffeeStepSelected({
    required String id,
    required VoidCallback onCoffeeGrindCompleted,
    required VoidCallback onCoffeeGrindRejected,
  }) {
    _pushPage(GrindCoffeeModalRoutePage(
      coffeeOrderId: id,
      onCoffeeOrderGrindCompleted: () {
        onCoffeeGrindCompleted();
        _popPage();
      },
      onCoffeeOrderRejected: () {
        onCoffeeGrindRejected();
        _popPage();
      },
    ));
  }

  void onAddWaterCoffeeStepSelected(String coffeeOrderId) {
    _pushPage(AddWaterRoutePage(coffeeOrderId));
  }

  void onReadyCoffeeStepSelected({
    required String id,
    required VoidCallback onCoffeeServed,
  }) {
    _pushPage(ReadyCoffeeModalRoutePage(
      coffeeOrderId: id,
      onCoffeeOrderServed: () {
        onCoffeeServed();
        _popPage();
      },
    ));
  }

  void _authStateChangeSubscription() {
    final isLoggedIn = authService.authStateListenable.value ?? false;
    if (isLoggedIn) {
      final shouldShowTutorial = !onboardingService.isTutorialShown();
      _pages.value = [
        const OrdersRoutePage(CoffeeMakerStep.grind),
        if (shouldShowTutorial) const OnboardingModalRoutePage(),
      ];
    } else {
      _pages.value = [const AuthRoutePage()];
    }
  }

  void _pushPage(AppRoutePage page) {
    _pages.value = List.of(pages.value)..add(page);
  }

  void _popPage() {
    if (_pages.value.length > 1) {
      _pages.value = _pages.value.sublist(0, _pages.value.length - 1);
    }
  }
}
