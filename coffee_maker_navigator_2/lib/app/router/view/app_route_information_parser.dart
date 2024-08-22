import 'package:coffee_maker_navigator_2/app/router/entities/app_route_configuration.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_path.dart';
import 'package:flutter/material.dart';

typedef QueryParams = Map<String, String>;

class AppRouteInformationParser
    extends RouteInformationParser<AppRouteConfiguration> {
  const AppRouteInformationParser();

  @override
  Future<AppRouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final queryParams = uri.queryParameters;
    final appRoutePath =
        AppRoutePath.findFromPageName(uri.path, queryParams.keys);
    return AppRouteConfiguration(
      appRoutePath: appRoutePath,
      queryParams: queryParams,
    );
  }

  @override
  RouteInformation restoreRouteInformation(
      AppRouteConfiguration configuration) {
    return RouteInformation(uri: configuration.toUri());
  }
}
