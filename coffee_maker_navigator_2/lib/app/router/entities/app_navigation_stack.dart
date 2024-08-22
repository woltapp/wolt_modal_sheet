import 'package:coffee_maker_navigator_2/app/router/entities/app_route_page.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:equatable/equatable.dart';

class AppNavigationStack extends Equatable {
  final List<AppRoutePage> pages;

  const AppNavigationStack({required this.pages});

  @override
  List<Object?> get props => [pages];

  AppRoutePage get lastPage => pages.last;

  factory AppNavigationStack.bootstrapStack() {
    return const AppNavigationStack(
      pages: [BootstrapRoutePage()],
    );
  }

  factory AppNavigationStack.ordersStack({
    CoffeeMakerStep? step,
    String? coffeeOrderId,
    bool shouldShowOnboardingModal = false,
  }) {
    return AppNavigationStack(
      pages: [
        const OrdersRoutePage(),
        if (shouldShowOnboardingModal) const OnboardingModalRoutePage(),
        if (step == CoffeeMakerStep.grind && coffeeOrderId != null)
          GrindCoffeeModalRoutePage(
            coffeeOrderId: coffeeOrderId,
          ),
        if (step == CoffeeMakerStep.addWater && coffeeOrderId != null)
          AddWaterRoutePage(coffeeOrderId),
        if (step == CoffeeMakerStep.ready && coffeeOrderId != null)
          ReadyCoffeeModalRoutePage(
            coffeeOrderId: coffeeOrderId,
          ),
      ],
    );
  }

  factory AppNavigationStack.loginStack() {
    return const AppNavigationStack(
      pages: [LoginRoutePage()],
    );
  }

  factory AppNavigationStack.tutorialsStack([CoffeeMakerStep? step]) {
    return AppNavigationStack(
      pages: [
        const OrdersRoutePage(),
        const TutorialsRoutePage(),
        if (step != null) SingleTutorialRoutePage(step),
      ],
    );
  }
}
