import 'package:coffee_maker_navigator_2/app/router/view/app_route_information_parser.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';

/// Represents the different route URI templates available in the application, each associated
/// with a specific screen or modal. This enum defines the static structure of URI paths and
/// expected query parameters, mapping these defined string paths to the application's navigation
/// routes.
///
/// This enum provides a centralized, consistent way to define and reference the URI paths used
/// throughout the app, ensuring that route handling is unified and easier to manage. By clearly
/// outlining the available routes and their associated query parameters, it helps avoid
/// hard-coded strings scattered throughout the codebase, reducing the likelihood of errors.
///
/// **Why this Enum is Necessary:**
/// - **Consistency:** Centralizes the definition of route paths, ensuring all references to routes
///   use a standardized format.
/// - **Clarity:** Makes it clear what routes are available and what parameters they expect, improving
///   code readability and maintainability.
/// - **Integration:** Provides a straightforward way to map URIs to specific routes, aiding in navigation
///   handling and making deep linking easier to manage.
/// - **Exhaustive Route Identification:** Helps to find the corresponding route from the URI in an
///   exhaustive manner, ensuring that every possible route defined in the application has a clear and
///   explicit mapping. This reduces ambiguity in navigation and ensures that all paths are accounted for.
///
/// **Where it is Used:**
/// - **Navigation Logic:** Used in conjunction with classes like `AppRouteConfiguration` to manage the
///   dynamic aspects of routing, such as the actual values of query parameters.
/// - **Route Matching:** The [AppRouteInformationParser] class used the static `findFromUri`
///   method defined in this enum to determine the correct route based on a given URI, allowing
///   the app to interpret and respond to changes in the browser's address bar.
///   This exhaustive approach ensures that all defined routes are considered and matched appropriately.
///
/// Each enum value corresponds to a unique route in the app, defining the path and, optionally, any query
/// parameters that can be used to pass additional data or control the state of a screen.
///
/// Additional Fields:
/// - `path`: The string path associated with each route, used for URI matching.
/// - `params`: Optional list of query parameter keys expected for the route, used for passing additional data.
enum AppRouteUriTemplate {
  bootstrap('/'),
  login('/login'),
  orders('/orders', [queryParamKeyOrderScreenTab]),
  tutorials('/tutorials'),
  grindTutorial('/tutorials/grind'),
  waterTutorial('/tutorials/water'),
  readyTutorial('/tutorials/ready'),
  addWater('/orders/addWater', [queryParamKeyId]),
  grindCoffeeModal('/orders/grind', [queryParamKeyId]),
  readyCoffeeModal('/orders/ready', [queryParamKeyId]),
  unknown('/unknown'),
  onboarding('/welcome');

  final String path; // The URL path for the route.
  final List<String>
      params; // Optional list of query parameter keys associated with the route.

  static const queryParamKeyId =
      'id'; // Standard query parameter for item identification.
  static const queryParamKeyOrderScreenTab =
      'tab'; // Query parameter for specifying order screen tabs.

  const AppRouteUriTemplate(this.path, [this.params = const []]);

  /// Finds and returns the [AppRouteUriTemplate] enum value based on the provided URI.
  /// This method uses both the path and the query parameters of the URI to match and
  /// identify the corresponding route. If no exact match is found, it defaults to
  /// [AppRouteUriTemplate.unknown].
  ///
  /// Parameters:
  ///   - uri: The [Uri] object representing the requested route.
  ///
  /// Returns:
  ///   - [AppRouteUriTemplate]: The corresponding enum value based on the URI path and query parameters.
  static AppRouteUriTemplate findFromUri(Uri uri) {
    final path = uri.path;
    final queryParams = uri.queryParameters;

    return AppRouteUriTemplate.values.firstWhere(
      (element) {
        // Check if the path matches
        if (element.path != path) {
          return false;
        }

        // Check if all expected query parameters are present
        if (element.params.isNotEmpty) {
          for (String param in element.params) {
            if (!queryParams.containsKey(param)) {
              return false; // Expected query param not found
            }
          }
        }

        // If the path matches and all expected query parameters are present, return true
        return true;
      },
      orElse: () => AppRouteUriTemplate
          .unknown, // Default to unknown if no match is found
    );
  }

  /// Maps a [CoffeeMakerStep] to the corresponding tutorial route.
  /// This method provides a straightforward way to navigate to specific tutorial screens
  /// based on the given coffee maker step.
  ///
  /// Parameters:
  ///   - step: The [CoffeeMakerStep] enum value representing the tutorial for the state.
  ///
  /// Returns:
  ///   - [AppRouteUriTemplate]: The corresponding tutorial route for the provided step.
  static AppRouteUriTemplate fromCoffeeMakerStep(CoffeeMakerStep step) {
    switch (step) {
      case CoffeeMakerStep.grind:
        return grindTutorial;
      case CoffeeMakerStep.addWater:
        return waterTutorial;
      case CoffeeMakerStep.ready:
        return readyTutorial;
    }
  }
}
