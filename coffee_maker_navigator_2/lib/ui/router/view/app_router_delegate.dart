import 'dart:async';

import 'package:coffee_maker_navigator_2/ui/extensions/context_extensions.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/coffee_order_list_view_for_step.dart';
import 'package:coffee_maker_navigator_2/ui/router/entities/app_route_page.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class AppRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AppRoutePage>>(
      valueListenable: context.routerViewModel.pages,
      builder: (context, pages, __) {
        return Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            final context = navigatorKey.currentContext;
            final name = route.settings.name;

            if (context != null && name != null) {
              context.routerViewModel
                  .onPagePoppedImperatively(poppingPageName: name);
            }

            return route.didPop(result);
          },
          observers: [_AppRouteObserver(Theme.of(context).colorScheme)],
        );
      },
    );
  }

  /// The pops caused by Android swipe gesture and hardware button
  /// is handled in here instead of [Navigator]'s onPopPage callback.
  @override
  Future<bool> popRoute() {
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      if (_isImperativePopFromOrderScreenModals(currentContext)) {
        return Future.value(true);
      }
      return currentContext.routerViewModel
          .onPagePoppedWithOperatingSystemIntent();
    }

    return Future.value(false);
  }

  @override
  // ignore: no-empty-block, nothing to do
  Future<void> setNewRoutePath(void configuration) async {
    /* Do Nothing */
  }

  bool _isImperativePopFromOrderScreenModals(BuildContext currentContext) {
    // Modals on order screen are opened imperatively. We .
    final navigatorState = Navigator.of(currentContext);

    // Navigator widget doesn't expose the current route. This seem to be the only way to access it.
    late Route<void> currentRoute;
    navigatorState.popUntil((route) {
      currentRoute = route;
      return true;
    });

    final routeName = currentRoute.settings.name;
    if (routeName == CoffeeOrderListViewForStep.modalRouteSettingName) {
      navigatorState.pop();
      return true;
    }

    return false;
  }
}

class _AppRouteObserver extends RouteObserver<PageRoute<void>> {
  final ColorScheme colorScheme;

  _AppRouteObserver(this.colorScheme);

  @override
  void didReplace({Route<void>? newRoute, Route<void>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is ModalRoute) {
      _updateSystemUIOverlayStyle(newRoute);
    }
  }

  @override
  void didPush(Route<void> route, Route<void>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is ModalRoute) {
      _updateSystemUIOverlayStyle(route);
    }
  }

  @override
  void didPop(Route<void> route, Route<void>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _updateSystemUIOverlayStyle(previousRoute);
    }
  }

  void _updateSystemUIOverlayStyle(Route<void> route) {
    SystemUIAnnotationWrapper.setSystemUIOverlayStyle(
      colorScheme,
      hasBottomNavigationBar:
          route.settings.name == const OrdersRoutePage().name,
    );
  }
}
