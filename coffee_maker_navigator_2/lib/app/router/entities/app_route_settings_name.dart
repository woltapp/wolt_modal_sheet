enum RouteSettingsName {
  auth('auth'),
  orders('orders'),
  tutorials('tutorials'),
  singleTutorial('singleTutorial'),
  addWater('addWater'),
  grindCoffee('grindCoffee'),
  onboarding('welcomeModal');

  final String routeName;

  const RouteSettingsName(this.routeName);

  static RouteSettingsName findFromPageName(String routeSettingsName) {
    return RouteSettingsName.values.firstWhere(
      (element) => element.routeName == routeSettingsName,
      orElse: () => throw StateError('Invalid page name'),
    );
  }
}
