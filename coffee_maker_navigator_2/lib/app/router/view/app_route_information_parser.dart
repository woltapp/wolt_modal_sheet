import 'package:coffee_maker_navigator_2/app/router/entities/app_route_configuration.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_uri_template.dart';
import 'package:flutter/material.dart';

/// Parses and restores [RouteInformation] for the application, facilitating the interaction
/// between the app's internal navigation state and the external representation in the browser's URL.
///
/// This class extends [RouteInformationParser] and handles the conversion between
/// [RouteInformation] (used for browser URL) and [AppRouteConfiguration] (used for app
/// navigation state).
///
/// In the context of Flutter Navigator 2.0, the [AppRouteInformationParser] plays a pivotal role
/// in managing navigation state transitions, ensuring that the app responds correctly to both
/// user-initiated navigation (e.g., via the browser's address bar) and programmatic navigation
/// changes within the app. It ensures that navigation is consistent, predictable, and synced with the
/// visible URL.
///
/// **Key Methods:**
///   - `parseRouteInformation`: This method is responsible for translating a [RouteInformation] object,
///     typically generated from a URL change (e.g., when a user types a new address or uses the browser
///     back button), into an [AppRouteConfiguration] object. By doing this, it allows the application
///     to update its navigation stack to reflect changes in the browser's address bar, ensuring that
///     the app's state is in sync with the URL.
///   - `restoreRouteInformation`: This method converts an [AppRouteConfiguration] back into a
///     [RouteInformation] object. It is used to update the browser's URL to reflect the current
///     navigation state within the app, ensuring that the displayed URL is always up-to-date with the
///     app's state. This is crucial for maintaining the correct state during internal navigation and
///     for enabling users to bookmark or share URLs accurately.
///
/// By using [AppRouteUriTemplate], this class ensures that the parsing and restoration processes
/// are exhaustive and aligned with the predefined route templates. This comprehensive approach helps
/// avoid mismatches and ensures that every route and its parameters are correctly interpreted and represented.
class AppRouteInformationParser
    extends RouteInformationParser<AppRouteConfiguration> {
  const AppRouteInformationParser();

  /// Parses the given [RouteInformation] into an [AppRouteConfiguration].
  ///
  /// This method extracts the URI from the [RouteInformation], identifies the route path using
  /// [AppRouteUriTemplate.findFromUri], and captures any query parameters. The resulting
  /// [AppRouteConfiguration] represents the application's navigation state based on the provided URI,
  /// facilitating the app's response to changes in the browser's address bar.
  @override
  Future<AppRouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    return AppRouteConfiguration(
      appRouteUriTemplate: AppRouteUriTemplate.findFromUri(uri),
      queryParams: uri.queryParameters,
    );
  }

  /// Restores the [RouteInformation] from a given [AppRouteConfiguration].
  ///
  /// This method converts the application's current navigation state back into a URI,
  /// which can be used to update the browser's address bar, ensuring consistency between
  /// the app's internal state and the URL displayed to the user. This helps maintain
  /// correct navigation behavior and supports deep linking, back/forward navigation, and
  /// sharing of accurate URLs.
  @override
  RouteInformation restoreRouteInformation(
    AppRouteConfiguration configuration,
  ) {
    return RouteInformation(uri: configuration.toUri());
  }
}
