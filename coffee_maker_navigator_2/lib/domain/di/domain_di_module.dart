import 'package:coffee_maker_navigator_2/di/dependency_injection.dart';
import 'package:coffee_maker_navigator_2/domain/add_water/add_water_service.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/domain/onboarding/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';

class DomainDiModule {
  static Future<void> setup() async {
    /// Auth
    DependencyInjection.bind<AuthService>(
      (i) => i.get<AuthServiceImpl>(),
      isSingleton: true,
    );
    DependencyInjection.bind<AuthServiceImpl>(
      (i) => AuthServiceImpl(
        authRepository: i.get(),
      )..onInit(),
      isSingleton: true,
    );

    /// Add Water
    DependencyInjection.bind((i) => AddWaterService());

    /// Orders
    DependencyInjection.bind<OrdersService>(
      (i) => OrdersService(ordersRepository: i.get()),
      isSingleton: true,
    );

    /// Tutorial
    DependencyInjection.bind<OnboardingService>(
      (i) => OnboardingService(tutorialRepository: i.get()),
      isSingleton: true,
    );
  }
}
