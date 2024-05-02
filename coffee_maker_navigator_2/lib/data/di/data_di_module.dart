import 'package:coffee_maker_navigator_2/data/auth/local/auth_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/auth/repository/auth_repository.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/local/onboarding_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/repository/onboarding_repository.dart';
import 'package:coffee_maker_navigator_2/data/orders/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/data/orders/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/di/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataDiModule {
  static Future<void> setup() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    /// Auth
    DependencyInjection.bind<AuthLocalDataSource>(
      (i) => AuthLocalDataSource(sharedPreferences: sharedPrefs),
      isSingleton: true,
    );
    DependencyInjection.bind<AuthRepository>(
      (i) => AuthRepository(localAuthDataSource: i.get()),
      isSingleton: true,
    );

    /// Orders
    DependencyInjection.bind<OrdersRemoteDataSource>(
      (i) => i.get<OrdersRemoteDataSourceImpl>(),
    );
    DependencyInjection.bind<OrdersRemoteDataSourceImpl>(
      (i) => OrdersRemoteDataSourceImpl(),
      isSingleton: true,
    );
    DependencyInjection.bind<OrdersRepository>(
      (i) => OrdersRepository(ordersRemoteDataSource: i.get()),
      isSingleton: true,
    );

    /// Tutorial
    DependencyInjection.bind<OnboardingLocalDataSource>(
      (i) => OnboardingLocalDataSource(sharedPreferences: sharedPrefs),
      isSingleton: true,
    );
    DependencyInjection.bind<OnboardingRepository>(
      (i) => OnboardingRepository(localDataSource: i.get()),
      isSingleton: true,
    );
  }
}
