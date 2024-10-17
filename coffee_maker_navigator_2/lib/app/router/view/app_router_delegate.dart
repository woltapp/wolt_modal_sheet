import 'package:coffee_maker_navigator_2/app/router/entities/app_route_configuration.dart';
import 'package:coffee_maker_navigator_2/app/router/view/app_route_observer.dart';
import 'package:coffee_maker_navigator_2/app/router/view_model/router_view_model.dart';
import 'package:flutter/material.dart';

/// The [AppRouterDelegate] is the core component of the navigation system, specifically designed
/// to work with the Navigator 2.0 API. It extends the [RouterDelegate] class, which
/// is responsible for building the [Navigator] widget every time the app navigation state changes.
///
/// This class integrates with the [RouterViewModel], which holds and manages the list of pages
/// and the state of the navigation, making it easier to handle dynamic changes in the navigation
/// stack.
///
/// **Key Responsibilities:**
/// - **Building the Navigation Stack:** The `build` method constructs the [Navigator] widget,
///   which is the core of the navigation system. It defines the list of pages to display,
///   how to handle pop actions, and observers for navigation events.
/// - **Handling Pop Actions:** The `onPopPage` method is used to handle page pops from the
///   [Navigator]. It integrates with the [RouterViewModel] to manage state changes when a
///   page is popped specifically pop actions initiated by the operating system (e.g., Android's
///   back gesture or hardware button).
/// - **Synchronizing Navigation State:** The `currentConfiguration` getter returns the
///   current navigation state as an [AppRouteConfiguration], which is used to update the
///   browser's URL or sync with the app's state. The `setNewRoutePath` method allows the app to
///   respond to changes in the route configuration, such as when a new URL is entered in the
///   browser or deep links are used.
/// - **Listening to State Changes:** The constructor sets up listeners to react to changes
///   in the [RouterViewModel], such as updates to the pages or visibility of specific tabs.
///   These listeners trigger the `notifyListeners` method, ensuring that the [Navigator] widget
///   is rebuilt whenever relevant state changes occur.

class AppRouterDelegate extends RouterDelegate<AppRouteConfiguration>
    with ChangeNotifier {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final RouterViewModel routerViewModel;

  AppRouterDelegate(this.routerViewModel) {
    // Setting up listeners to monitor changes in the navigation state.
    // Listens to changes in the list of pages and the visibility of specific tabs.
    // When changes are detected, it triggers a rebuild for the Navigator widget.
    Listenable.merge([
      routerViewModel.pages,
      routerViewModel.visibleOrderScreenNavBarTab,
    ]).addListener(notifyListeners);
  }

  /// STEP #6: Build the navigation stack.
  ///
  /// This method is responsible for building the `Navigator` widget, which manages
  /// the app's navigation stack. It uses the list of pages provided by the `RouterViewModel` to
  /// define what pages are currently displayed. The `Navigator` widget is the View part of MVVM,
  /// and it updates automatically whenever the ViewModel (RouterViewModel) changes, ensuring the
  /// UI reflects the current navigation state. This connection allows for a reactive and dynamic
  /// navigation experience in the app.
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: routerViewModel.pages.value,
      onPopPage: (route, result) {
        /// STEP #9: Handle the pop page event.
        ///
        /// This callback is invoked when a [Route] created from a [Page] in the [pages] list is
        /// popped. In other words, it handles the scenario where a declaratively added route is
        /// removed using an imperative pop call to the [Navigator] widget. For example, the back
        /// button in the [AddWaterScreen] can trigger a pop event that removes the screen from the
        ///
        /// The `RouterViewModel` is notified about the page pop event, allowing it to update and sync
        /// the [pages] list accordingly, ensuring that the navigation state remains consistent.
        routerViewModel.onPagePoppedImperatively();
        return route.didPop(result);
      },
      observers: [AppRouteObserver(Theme.of(context).colorScheme)],
    );
  }

  /// STEP #10: Handle the pop route event.
  ///
  /// This method manages pop actions initiated by the operating system, such as back gestures or
  /// hardware back button presses on devices like Android. It ensures these interactions are
  /// handled consistently with the app's navigation logic as defined in the `RouterViewModel`,
  /// which tracks and updates the list of pages in the navigation stack.
  @override
  Future<bool> popRoute() {
    return routerViewModel.onPagePoppedWithOperatingSystemIntent();
  }

  /// STEP #17: Get the current route configuration.
  ///
  /// This method retrieves the current route configuration, which reflects the app's current
  /// navigation state. The router widget calls this method whenever it needs to update the
  /// browser's URL or sync the app state with the URL. This ensures that the displayed URL
  /// accurately represents the current visible screen in the app.
  @override
  AppRouteConfiguration get currentConfiguration {
    return routerViewModel.onUriRestoration();
  }

  /// STEP #14: Set a new navigation stack for the app configuration.
  ///
  /// This method updates the navigation stack based on a new route configuration. It is used to handle
  /// changes such as URL updates or deep links, ensuring the app responds appropriately to these changes.
  /// By parsing the new route configuration and updating the state in the `RouterViewModel`, the app
  /// can dynamically adjust its navigation stack to reflect the user's intent, whether it's through
  /// direct URL input, deep links, or other routing events.
  @override
  Future<void> setNewRoutePath(AppRouteConfiguration configuration) async {
    routerViewModel.onNewUriParsed(configuration);
  }
}
