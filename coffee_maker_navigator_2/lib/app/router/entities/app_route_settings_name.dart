enum RouteSettingsName {
  bootstrap('bootstrap'),
  auth('auth'),
  orders('orders'),
  tutorials('tutorials'),
  singleTutorial('singleTutorial'),
  addWater('addWater'),
  grindCoffeeModal('grindCoffeeModal'),
  readyCoffeeModal('readyCoffeeModal'),
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
