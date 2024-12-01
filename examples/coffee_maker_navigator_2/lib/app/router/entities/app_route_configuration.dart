import 'package:coffee_maker_navigator_2/app/router/entities/app_route_uri_template.dart';

/// This class provides a structured way to manage and represent the current navigation state,
/// including both the route and any relevant parameters.
///
/// [AppRouteConfiguration] represents the configuration of a specific route in the application,
/// holding both the static structure of the route as defined by the [AppRouteUriTemplate] and
/// the dynamic aspects such as query parameters.
///
/// In the context of Flutter's Navigator 2.0, this configuration is essential for translating
/// between the application's navigation state and the URL displayed in the browser. It enables
/// deep linking, dynamic navigation, and synchronization between the app's state and the browser URL.
///
/// **Components:**
///   - [appRouteUriTemplate]: A value from the [AppRouteUriTemplate] enum, representing the static
///     template of the route. It defines the modal or screen that should be navigated to based
///     on the URI path.
///   - [queryParams]: A map of query parameters, allowing additional dynamic information to be passed
///     with the route (e.g., selected tab, order id, etc.). This supports more complex navigation
///     patterns and enables passing state information directly through the URL.
///
/// **Usage:**
/// - **URL Generation:** The `toUri()` method converts the route configuration into a full URI,
///   combining the path from [AppRouteUriTemplate] with the actual query parameter values. This URI
///   is used to update the browser's address bar, ensuring that the visible URL reflects the current
///   state of the application.
/// - **Consistency with Defined Routes:** By utilizing [AppRouteUriTemplate], this class ensures that
///   all route configurations are consistent with the predefined route templates, making navigation
///   predictable and easier to manage.
class AppRouteConfiguration {
  final AppRouteUriTemplate appRouteUriTemplate;
  final QueryParams queryParams;

  /// STEP #16: Define the AppRouteConfiguration class.
  ///
  /// This class represents the navigation state by combining a static route template
  /// from [AppRouteUriTemplate] with dynamic query parameters. It is used in handling
  /// deep linking, dynamic navigation, and keeping the app's state in sync with the browser's URL.
  const AppRouteConfiguration({
    required this.appRouteUriTemplate,
    this.queryParams = const {},
  });

  /// Converts the route configuration to a URI, combining the path name from the template
  /// and any provided query parameters. This is used for generating URLs that reflect
  /// the application's current state, aiding in deep linking and navigation state management.
  Uri toUri() =>
      Uri(path: appRouteUriTemplate.path, queryParameters: queryParams);
}

typedef QueryParams = Map<String, String>;
