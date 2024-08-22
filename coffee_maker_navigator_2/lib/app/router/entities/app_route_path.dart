import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';

enum AppRoutePath {
  bootstrap('/'),
  login('/login'),
  orders('/orders'),
  tutorials('/tutorials'),
  grindTutorial('/tutorials/grind'),
  waterTutorial('/tutorials/water'),
  readyTutorial('/tutorials/ready'),
  addWater('/orders/addWater', [queryParamId]),
  grindCoffeeModal('/orders/grind', [queryParamId, queryParamPageIndex]),
  readyCoffeeModal('/orders/ready', [queryParamId, queryParamPageIndex]),
  unknown('/unknown'),
  onboarding('/welcome');

  final String path;
  final List<String> params;

  static const queryParamId = 'id';
  static const queryParamPageIndex = 'pageIndex';

  const AppRoutePath(this.path, [this.params = const []]);

  static AppRoutePath findFromPageName(String path,
      [Iterable<String> params = const []]) {
    return AppRoutePath.values.firstWhere(
      (element) =>
          element.path == path &&
          params.every((e) => element.params.contains(e)),
      orElse: () => AppRoutePath.unknown,
    );
  }

  static AppRoutePath fromCoffeeMakerStep(CoffeeMakerStep step) {
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
