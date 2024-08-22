import 'package:coffee_maker_navigator_2/app/router/entities/app_route_page.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class AppRouteObserver extends RouteObserver<PageRoute<void>> {
  final ColorScheme colorScheme;

  AppRouteObserver(this.colorScheme);

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
      hasBottomNavigationBar: route.settings.name == OrdersRoutePage.routeName,
    );
  }
}
