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

  /// STEP #4: Inject dependencies into the ViewModel's constructor.
  ///
  /// In this step, the AuthService and OnboardingService are injected into the
  /// RouterViewModel through its constructor. These services together represent the Model
  /// in the MVVM pattern, providing the data and business logic related to authentication
  /// and onboarding. By injecting these services, the ViewModel can interact with the
  /// underlying data and logic, allowing it to manage the state of the View.
  RouterViewModel({
    required this.authService,
    required this.onboardingService,
  }) {
    /// STEP #5: Subscribe to authentication state changes.
    ///
    /// Here, we listen to changes in the user's authentication state by subscribing
    /// to the `authStateListenable` from AuthService. This allows the ViewModel to
    /// respond to changes in the Model (AuthService) and update the UI (the View) accordingly.
    /// For instance, when the user logs in or out, the ViewModel updates the list of pages to be
    /// displayed in the app, ensuring the UI always reflects the current authentication state.
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
    /// STEP #8: Implement the navigation logic for drawer destinations in the ViewModel.
    ///
    /// This step defines how the app should respond when a user selects an item from the
    /// navigation drawer. Based on the selected destination, the ViewModel updates the
    /// page stack to display the appropriate screen(s).
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

  void _authStateChangeSubscription() {
    final isLoggedIn = authService.authStateListenable.value ?? false;
    if (isLoggedIn) {
      final shouldShowOnboardingModal = !onboardingService.isTutorialShown();
      _pages.value = [
        const OrdersRoutePage(),
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
