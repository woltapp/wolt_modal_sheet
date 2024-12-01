import 'dart:async';

import 'package:coffee_maker_navigator_2/app/auth/domain/auth_service.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_configuration.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_page.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_uri_template.dart';
import 'package:coffee_maker_navigator_2/app/ui/widgets/app_navigation_drawer.dart';
import 'package:coffee_maker_navigator_2/features/onboarding/domain/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// The `RouterViewModel` class acts as the central manager for navigation state within the application.
/// It serves as the bridge between the app's state management and the navigation system, providing
/// a clear and structured way to handle navigation events, manage the navigation stack, and synchronize
/// the app's state with the browser's URL in a declarative manner using Flutter's Navigator 2.0 API.
///
/// The primary role of `RouterViewModel` is to manage the current navigation state of the
/// application. It maintains a stack of pages, represented by [AppRoutePage] objects, which
/// define the current route and any additional navigation state (e.g., query parameters). This
/// stack is directly tied to the app's navigation flow, making it easier to control and monitor
/// state changes as users navigate through the app.
///
/// The class interacts with services such as [AuthService] and [OnboardingService] to
/// determine the navigation flow based on user authentication state and onboarding status. By
/// reacting to changes in these services, `RouterViewModel` dynamically adjusts the navigation
/// stack, ensuring that the app responds appropriately to state changes like login/logout
/// or completion of onboarding.
///
/// By using [ValueNotifier]s to manage the list of pages and visible tabs, `RouterViewModel`
/// provides a declarative approach to navigation. This makes the navigation logic more
/// predictable, easier to reason about, and simplifies the process of syncing the UI with the
/// underlying state.
///
/// **Exhaustiveness and Robustness:**
/// By using a well-defined structure for handling different route configurations and navigation events,
/// `RouterViewModel` ensures exhaustiveness in route handling. Every potential route and navigation event
/// is accounted for, minimizing the risk of unhandled cases and navigation errors. This is achieved by:
///
/// - **Explicit Route Handling:** Methods like [onNewUriParsed], [onUriRestoration],
/// [onPagePoppedWithOperatingSystemIntent] explicitly handle all defined routes, using
/// exhaustive switch cases based on [AppRouteUriTemplate]. This guarantees that the app can
/// handle any valid route configuration, ensuring robustness in the face of various navigation scenarios.
/// - **Centralized Navigation Logic:** By centralizing navigation logic within `RouterViewModel`, the app reduces
///  complexity and avoids scattered navigation handling, making the codebase easier to maintain and extend.
/// - **Integration with Navigator 2.0:** The class integrates seamlessly with Navigator 2.0, providing methods
///  to update the navigation state based on URL changes and to reflect navigation state changes in the URL.
/// **Design Considerations:**
/// - **Scalability:** `RouterViewModel` is designed to scale with the application's needs. As new features and
///  routes are added, they can be integrated into the existing structure, ensuring that the app's navigation
///  remains cohesive and manageable.
/// - **Singleton Usage Pattern:** Typically, `RouterViewModel` is used as a singleton, ensuring a single source
///  of truth for navigation state across the application. However, methods like `dispose` are implemented to
///  support scenarios where the singleton pattern may change, adhering to best practices for resource management.
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

  /// Step #18: Handles the update of the routing URL (visible on the Browser
  /// address bar) when the
  /// app navigation state changes.
  ///
  /// This method is triggered by changes to either the [pages] list or the
  /// [visibleOrderScreenNavBarTab]. It constructs a new [AppRouteConfiguration]
  /// based on the last page in the navigation stack. This configuration includes both the
  /// path and any associated query parameters. The newly constructed configuration will be
  /// utilized by the [RouteInformationParser] to reflect the changes in the browser's URL.
  ///
  /// Returns:
  ///   - [AppRouteConfiguration]: The route configuration for the current state.
  AppRouteConfiguration onUriRestoration() {
    final lastPage = _pages.value.last;
    return AppRouteConfiguration(
      appRouteUriTemplate: lastPage.appRouteUriTemplate,
      queryParams: lastPage.queryParams ?? {},
    );
  }

  /// Step #15: Respond to the parsing of a new URL route.
  ///
  /// Responds to the parsing of a new URL route by the [RouteInformationParser] and returns sets
  /// the new navigation stack defined by the [pages] list based on the provided
  /// [AppRouteConfiguration].
  ///
  /// This method is called when a new route URI is detected, typically initiated by the user
  /// modifying the URL in the browser's address bar. It instructs the [RouterDelegate] to
  /// reconstruct the navigation stack based on the specified [AppRouteConfiguration]. The
  /// configuration provides the necessary details to accurately rebuild the stack, reflecting
  /// the new intended navigation state.
  ///
  /// Parameters:
  ///   - configuration: The [AppRouteConfiguration] that encapsulates the desired route details.
  void onNewUriParsed(AppRouteConfiguration configuration) {
    final queryParams = configuration.queryParams;
    final selectedCoffeeOrderId =
        queryParams[AppRouteUriTemplate.queryParamKeyId];
    final orderScreenNavBarTab =
        queryParams[AppRouteUriTemplate.queryParamKeyOrderScreenTab];
    if (orderScreenNavBarTab != null) {
      _visibleOrderScreenNavBarTab.value =
          CoffeeMakerStep.fromQueryParameter(orderScreenNavBarTab);
    }

    late List<AppRoutePage> newPath;

    switch (configuration.appRouteUriTemplate) {
      case AppRouteUriTemplate.login:
        newPath = [
          const LoginRoutePage(),
        ];
        break;
      case AppRouteUriTemplate.orders:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
        ];
        break;
      case AppRouteUriTemplate.tutorials:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          const TutorialsRoutePage(),
        ];
        break;
      case AppRouteUriTemplate.grindTutorial:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          const TutorialsRoutePage(),
          SingleTutorialRoutePage(CoffeeMakerStep.grind),
        ];
        break;
      case AppRouteUriTemplate.waterTutorial:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          const TutorialsRoutePage(),
          SingleTutorialRoutePage(CoffeeMakerStep.addWater),
        ];
        break;
      case AppRouteUriTemplate.readyTutorial:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          const TutorialsRoutePage(),
          SingleTutorialRoutePage(CoffeeMakerStep.ready),
        ];
        break;
      case AppRouteUriTemplate.grindCoffeeModal:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          if (selectedCoffeeOrderId != null)
            GrindCoffeeModalRoutePage(coffeeOrderId: selectedCoffeeOrderId),
        ];
        break;
      case AppRouteUriTemplate.addWater:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          if (selectedCoffeeOrderId != null)
            AddWaterRoutePage(selectedCoffeeOrderId),
        ];
        break;
      case AppRouteUriTemplate.readyCoffeeModal:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          if (selectedCoffeeOrderId != null)
            ReadyCoffeeModalRoutePage(coffeeOrderId: selectedCoffeeOrderId),
        ];
        break;
      case AppRouteUriTemplate.onboarding:
        newPath = [
          OrdersRoutePage(_visibleOrderScreenNavBarTab),
          const OnboardingModalRoutePage(),
        ];
        break;
      case AppRouteUriTemplate.bootstrap:
      case AppRouteUriTemplate.unknown:
        final isLoggedIn = authService.authStateListenable.value ?? false;
        newPath = isLoggedIn
            ? [OrdersRoutePage(_visibleOrderScreenNavBarTab)]
            : [const LoginRoutePage()];
        break;
    }
    _pages.value = newPath;
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
