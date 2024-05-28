import 'dart:async';

import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/domain/onboarding/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/ui/router/entities/app_route_page.dart';
import 'package:coffee_maker_navigator_2/ui/router/entities/app_route_settings_name.dart';
import 'package:coffee_maker_navigator_2/ui/router/entities/router_view_model_state.dart';
import 'package:coffee_maker_navigator_2/ui/widgets/app_navigation_drawer.dart';
import 'package:flutter/material.dart';

class RouterViewModel extends ChangeNotifier {
  final AuthService authService;
  final OnboardingService onboardingService;

  RouterViewModelState state;

  RouterViewModel({
    required bool isUserLoggedIn,
    required bool isTutorialShown,
    required this.authService,
    required this.onboardingService,
  }) : state = RouterViewModelState.initial(
          isLoggedIn: isUserLoggedIn,
          isTutorialModalShown: isTutorialShown,
        );

  void onInit() {
    authService.authStateListenable.addListener(_authStateChangeSubscription);
  }

  @override
  void dispose() {
    authService.authStateListenable
        .removeListener(_authStateChangeSubscription);
    super.dispose();
  }

  void _authStateChangeSubscription() {
    final isLoggedIn = authService.authStateListenable.value ?? false;
    if (isLoggedIn) {
      final shouldShowTutorial = !onboardingService.isTutorialShown();
      state = state.copyWith(
        pages: [
          OrdersRoutePage(),
          if (shouldShowTutorial) const OnboardingModalRoutePage(),
        ],
      );
    } else {
      state = state.copyWith(pages: [const AuthRoutePage()]);
    }
    notifyListeners();
  }

  void _navigateToOrdersScreen({
    CoffeeMakerStep? destinationBottomNavBarTab,
  }) {
    final destination =
        destinationBottomNavBarTab ?? state.bottomNavigationTabInOrdersPage;
    state = state.copyWith(
      pages: [OrdersRoutePage(destination)],
      bottomNavigationTabInOrdersPage: destination,
    );
    notifyListeners();
  }

  void _navigateToTutorialsScreen() {
    state = state.copyWith(
      pages: [
        const TutorialsRoutePage(),
      ],
    );
    notifyListeners();
  }

  void _navigateToSingleTutorialScreen(
    CoffeeMakerStep coffeeMakerStep,
  ) {
    state = state.copyWith(
      pages: [
        const TutorialsRoutePage(),
        SingleTutorialRoutePage(coffeeMakerStep),
      ],
    );
    notifyListeners();
  }

  void _navigateToAddWaterScreen(String coffeeOrderId) {
    state = state.copyWith(
      pages: [
        OrdersRoutePage(state.bottomNavigationTabInOrdersPage),
        AddWaterRoutePage(coffeeOrderId),
      ],
    );
    notifyListeners();
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
        _navigateToOrdersScreen();
    }
  }

  /// The pops caused by Android swipe gesture and hardware button
  /// is handled in here instead of Navigator's onPopPage callback.
  /// Returning false will cause the entire app to be popped.
  Future<bool> onPagePoppedWithOperatingSystemIntent() {
    switch (state.pages.last) {
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
}
