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

  final ValueNotifier<CoffeeMakerStep> _visibleOrderScreenNavBarTab =
      ValueNotifier(CoffeeMakerStep.grind);

  ValueListenable<CoffeeMakerStep> get visibleOrderScreenNavBarTab =>
      _visibleOrderScreenNavBarTab;

  /// Step #4: Inject the model into the view model's constructor.
  RouterViewModel({
    required this.authService,
    required this.onboardingService,
  }) {
    /// Step #5: Subscribe to the auth state listenable to respond to changes in the user's
    /// authentication state.
    authService.authStateListenable.addListener(_authStateChangeSubscription);
  }

  /// Cleans up and releases all resources when the view model is no longer needed.
  ///
  /// This method is designed to be called when the [RouterViewModel] is being disposed of,
  /// ensuring that all event listeners and other disposable resources are properly released to
  /// prevent memory leaks.
  ///
  /// However, given that the [RouterViewModel] typically exists as a singleton, the likelihood
  /// of this method being invoked is low, but it is implemented to adhere to best practices
  /// for resource management and to ensure proper functionality in case the singleton usage
  /// pattern changes.
  void dispose() {
    authService.authStateListenable
        .removeListener(_authStateChangeSubscription);
    _pages.dispose();
  }

  /// Responds to route pop actions that are initiated imperatively using Flutter's Navigator
  /// widget. This method serves as a centralized handler for imperative pop requests, allowing for
  /// using imperative navigation methods together with the declarative navigation system of the
  /// Navigator 2.0.
  void onPagePoppedImperatively() {
    _popPage();
  }

  /// Handles page pop actions initiated by the operating system, such as the Android back swipe gesture
  /// or the hardware back button.
  ///
  /// Returning `false` from this method will result in the entire application being closed, as it
  /// indicates that no further navigation actions can be handled internally by the app.
  ///
  /// Returns:
  ///   - [Future<bool>]: A boolean value wrapped in a Future that indicates whether the pop action
  ///     has been successfully handled within the app (`true`) or if it should result in the app
  ///     being exited (`false`).
  Future<bool> onPagePoppedWithOperatingSystemIntent() {
    switch (_pages.value.last) {
      case BootstrapRoutePage():
      case LoginRoutePage():
      case OrdersRoutePage():
        return Future.value(false);
      case SingleTutorialRoutePage():
      case AddWaterRoutePage():
      case ReadyCoffeeModalRoutePage():
      case TutorialsRoutePage():
      case OnboardingModalRoutePage():
      case GrindCoffeeModalRoutePage():
        _popPage();
        return Future.value(true);
    }
  }

  /// Handles navigation actions triggered from the [AppNavigationDrawer] widget by updating the
  /// page stack based on the selected destination.
  ///
  /// This method manages navigation state transitions when a user selects a destination from a
  /// navigation drawer, ensuring the appropriate pages are loaded.
  ///
  /// Parameters:
  ///   - destination: The [AppNavigationDrawerDestination] enum value indicating which drawer
  ///                  menu item was selected by the user.
  void onDrawerDestinationSelected(
    AppNavigationDrawerDestination destination,
  ) {
    /// Step #6: Implement the drawer destination navigation logic in the view model.
    switch (destination) {
      case AppNavigationDrawerDestination.ordersScreen:
        _pages.value = [OrdersRoutePage(_visibleOrderScreenNavBarTab)];
        break;
      case AppNavigationDrawerDestination.tutorialsScreen:
        _pages.value = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          const TutorialsRoutePage(),
        ];
        break;
      case AppNavigationDrawerDestination.logOut:
        authService.logOut();
        break;
    }
  }

  void onUserRequestedTutorialFromOnboardingModal() {
    onboardingService.markTutorialShown();
    _pushPage(const TutorialsRoutePage());
  }

  void onTutorialDetailSelected(CoffeeMakerStep coffeeMakerStep) {
    _pushPage(SingleTutorialRoutePage(coffeeMakerStep));
  }

  void onOrderStepStarted(String id, CoffeeMakerStep step) {
    switch (step) {
      case CoffeeMakerStep.grind:
        _pushPage(GrindCoffeeModalRoutePage(coffeeOrderId: id));
        break;
      case CoffeeMakerStep.addWater:
        _pushPage(AddWaterRoutePage(id));
        break;
      case CoffeeMakerStep.ready:
        _pushPage(ReadyCoffeeModalRoutePage(coffeeOrderId: id));
        break;
    }
  }

  void onOrderStepCompleted() {
    _popPage();
  }

  void onOrderScreenNavBarTabSelected(CoffeeMakerStep selectedStep) {
    _visibleOrderScreenNavBarTab.value = selectedStep;
  }

  void _authStateChangeSubscription() {
    final isLoggedIn = authService.authStateListenable.value ?? false;
    if (isLoggedIn) {
      final shouldShowOnboardingModal = !onboardingService.isTutorialShown();
      _pages.value = [
        OrdersRoutePage(_visibleOrderScreenNavBarTab),
        if (shouldShowOnboardingModal) const OnboardingModalRoutePage(),
      ];
    } else {
      _pages.value = [const LoginRoutePage()];
    }
  }

  void _pushPage(AppRoutePage page) {
    _pages.value = List.of(_pages.value)..add(page);
  }

  void _popPage() {
    final pageCount = _pages.value.length;
    if (pageCount > 1) {
      _pages.value = _pages.value.sublist(0, pageCount - 1);
    }
  }
}
