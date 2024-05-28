import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/ui/router/entities/app_route_page.dart';

class RouterViewModelState {
  final List<AppRoutePage> pages;
  final CoffeeMakerStep bottomNavigationTabInOrdersPage;

  const RouterViewModelState({
    required this.pages,
    required this.bottomNavigationTabInOrdersPage,
  });

  factory RouterViewModelState.initial({
    required bool isLoggedIn,
    required bool isTutorialModalShown,
  }) {
    return RouterViewModelState(
      pages: isLoggedIn
          ? [
              OrdersRoutePage(),
              if (!isTutorialModalShown) const OnboardingModalRoutePage(),
            ]
          : const [AuthRoutePage()],
      bottomNavigationTabInOrdersPage: CoffeeMakerStep.grind,
    );
  }

  RouterViewModelState copyWith({
    List<AppRoutePage>? pages,
    CoffeeMakerStep? bottomNavigationTabInOrdersPage,
  }) {
    return RouterViewModelState(
      bottomNavigationTabInOrdersPage: bottomNavigationTabInOrdersPage ??
          this.bottomNavigationTabInOrdersPage,
      pages: pages ?? this.pages,
    );
  }
}
