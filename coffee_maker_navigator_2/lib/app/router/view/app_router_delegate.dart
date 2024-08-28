import 'package:coffee_maker_navigator_2/app/router/view/app_route_observer.dart';
import 'package:coffee_maker_navigator_2/app/router/view_model/router_view_model.dart';
import 'package:flutter/material.dart';

class AppRouterDelegate extends RouterDelegate<Object>
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
      pages: routerViewModel.pages.value,
      onPopPage: (route, result) {
        /// Step #14: Handle the pop page event.
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
    /// Step #15: Handle the pop route event.
    return routerViewModel.onPagePoppedWithOperatingSystemIntent();
  }

  @override
  Future<void> setNewRoutePath(Object configuration) {
    return Future.value();
  }
}
