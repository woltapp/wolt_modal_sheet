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
class AppRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final RouterViewModel routerViewModel;

  AppRouterDelegate(this.routerViewModel) {
    // Setting up listeners to monitor changes in the navigation state. Listens to changes in the
    // list of pages. When changes are detected, it triggers a rebuild for the Navigator widget.
    routerViewModel.pages.addListener(notifyListeners);
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

  @override
  Future<void> setNewRoutePath(Object configuration) {
    return Future.value();
  }
}
