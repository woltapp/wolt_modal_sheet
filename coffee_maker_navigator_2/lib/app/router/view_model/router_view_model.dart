import 'dart:async';

import 'package:coffee_maker_navigator_2/app/auth/domain/auth_service.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_navigation_stack.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_configuration.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_page.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_path.dart';
import 'package:coffee_maker_navigator_2/app/ui/widgets/app_navigation_drawer.dart';
import 'package:coffee_maker_navigator_2/features/onboarding/domain/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:flutter/foundation.dart';

class RouterViewModel {
  final AuthService authService;
  final OnboardingService onboardingService;
  late final ValueNotifier<AppNavigationStack> _navigationStack =
      ValueNotifier(const AppNavigationStack(
    pages: [BootstrapRoutePage()],
  ));

  ValueListenable<AppNavigationStack> get navigationStack => _navigationStack;

  RouterViewModel({
    required this.authService,
    required this.onboardingService,
  }) {
    authService.authStateListenable.addListener(_authStateChangeSubscription);
  }

  void dispose() {
    authService.authStateListenable
        .removeListener(_authStateChangeSubscription);
    _navigationStack.dispose();
  }

  void onDrawerDestinationSelected(
    AppNavigationDrawerDestination destination,
  ) {
    switch (destination) {
      case AppNavigationDrawerDestination.ordersScreen:
        _navigationStack.value = AppNavigationStack.ordersStack();
        break;
      case AppNavigationDrawerDestination.tutorialsScreen:
        _navigationStack.value = AppNavigationStack.tutorialsStack();
        break;
      case AppNavigationDrawerDestination.logOut:
        authService.logOut();
        break;
    }
  }

  void onPagePoppedImperatively() {
    _popPage();
  }

  /// The pops caused by Android swipe gesture and hardware button
  /// is handled in here instead of Navigator's onPopPage callback.
  /// Returning false will cause the entire app to be popped.
  Future<bool> onPagePoppedWithOperatingSystemIntent() {
    switch (_navigationStack.value.lastPage) {
      case BootstrapRoutePage():
      case LoginRoutePage():
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

  void onTutorialDetailSelected(CoffeeMakerStep coffeeMakerStep) {
    _pushPage(SingleTutorialRoutePage(coffeeMakerStep));
  }

  void onGrindCoffeeStepSelected(String id) {
    _pushPage(GrindCoffeeModalRoutePage(coffeeOrderId: id));
  }

  void onGrindCoffeeCompleted() {
    _popPage();
  }

  void onAddWaterCoffeeStepSelected(String coffeeOrderId) {
    _pushPage(AddWaterRoutePage(coffeeOrderId));
  }

  void onAddWaterStepCompleted() {
    _popPage();
  }

  void onReadyCoffeeStepSelected(String id) {
    _pushPage(ReadyCoffeeModalRoutePage(coffeeOrderId: id));
  }

  void onReadyCoffeeStepCompleted() {
    _popPage();
  }

  void _authStateChangeSubscription() {
    final isLoggedIn = authService.authStateListenable.value ?? false;
    if (isLoggedIn) {
      final shouldShowOnboardingModal = !onboardingService.isTutorialShown();
      _navigationStack.value = AppNavigationStack.ordersStack(
        shouldShowOnboardingModal: shouldShowOnboardingModal,
      );
    } else {
      _navigationStack.value = AppNavigationStack.loginStack();
    }
  }

  void _pushPage(AppRoutePage page) {
    final currentPages = _navigationStack.value.pages;
    _navigationStack.value = AppNavigationStack(
      pages: List.of(currentPages)..add(page),
    );
  }

  void _popPage() {
    final pageCount = _navigationStack.value.pages.length;
    if (pageCount > 1) {
      final poppedList = _navigationStack.value.pages.sublist(0, pageCount - 1);
      _navigationStack.value = AppNavigationStack(pages: poppedList);
    }
  }

  void onNewRoutePathSet(AppRouteConfiguration configuration) {
    final coffeeOrderId = configuration.queryParams[AppRoutePath.queryParamId];
    late AppNavigationStack updatedStack;

    switch (configuration.appRoutePath) {
      case AppRoutePath.bootstrap:
        updatedStack = AppNavigationStack.bootstrapStack();
        break;
      case AppRoutePath.login:
        updatedStack = AppNavigationStack.loginStack();
        break;
      case AppRoutePath.orders:
        updatedStack = AppNavigationStack.ordersStack();
        break;
      case AppRoutePath.tutorials:
        updatedStack = AppNavigationStack.tutorialsStack();
        break;
      case AppRoutePath.grindTutorial:
        updatedStack = AppNavigationStack.tutorialsStack(CoffeeMakerStep.grind);
        break;
      case AppRoutePath.waterTutorial:
        updatedStack =
            AppNavigationStack.tutorialsStack(CoffeeMakerStep.addWater);
        break;
      case AppRoutePath.readyTutorial:
        updatedStack = AppNavigationStack.tutorialsStack(CoffeeMakerStep.ready);
        break;
      case AppRoutePath.grindCoffeeModal:
        updatedStack = AppNavigationStack.ordersStack(
          coffeeOrderId: coffeeOrderId,
          step: CoffeeMakerStep.grind,
        );
        break;
      case AppRoutePath.addWater:
        updatedStack = AppNavigationStack.ordersStack(
          coffeeOrderId: coffeeOrderId,
          step: CoffeeMakerStep.addWater,
        );
        break;
      case AppRoutePath.readyCoffeeModal:
        updatedStack = AppNavigationStack.ordersStack(
          coffeeOrderId: coffeeOrderId,
          step: CoffeeMakerStep.ready,
        );
        break;
      case AppRoutePath.unknown:
        final isLoggedIn = authService.authStateListenable.value ?? false;
        updatedStack = isLoggedIn
            ? AppNavigationStack.ordersStack()
            : AppNavigationStack.loginStack();
        break;
      case AppRoutePath.onboarding:
        updatedStack = AppNavigationStack.ordersStack(
          shouldShowOnboardingModal: true,
        );
        break;
    }
    _navigationStack.value = updatedStack;
  }
}
