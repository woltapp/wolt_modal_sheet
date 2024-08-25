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

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: routerViewModel.pages
          .value, // The list of pages defining the current navigation stack.
      onPopPage: (route, result) {
        routerViewModel.onPagePoppedImperatively();
        return route.didPop(result);
      },
      observers: [AppRouteObserver(Theme.of(context).colorScheme)],
    );
  }

  /// Handles pop actions initiated by the operating system (e.g., back gestures or hardware
  /// buttons). This method ensures that such interactions are managed consistently with the
  /// app's navigation logic.
  @override
  Future<bool> popRoute() {
    return routerViewModel.onPagePoppedWithOperatingSystemIntent();
  }

  @override
  AppRouteConfiguration get currentConfiguration {
    // Returns the current route configuration, used to update the browser's URL
    // and keep it in sync with the application's state.
    return routerViewModel.onUriRestoration();
  }

  @override
  Future<void> setNewRoutePath(AppRouteConfiguration configuration) async {
    // Updates the navigation stack based on a new route configuration, allowing
    // the application to respond to changes such as URL updates or deep links.
    routerViewModel.onNewUriParsed(configuration);
  }
}
