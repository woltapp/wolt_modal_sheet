import 'package:coffee_maker_navigator_2/data/auth/local/auth_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/auth/repository/auth_repository.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/local/onboarding_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/repository/onboarding_repository.dart';
import 'package:coffee_maker_navigator_2/data/orders/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/data/orders/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/domain/onboarding/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DependencyContainer {
  void dispose();
}

class AppDependencies extends DependencyContainer {
  late final SharedPreferences _sharedPreferences;
  late final OnboardingLocalDataSource _onboardingLocalDataSource =
      OnboardingLocalDataSource(
    sharedPreferences: _sharedPreferences,
  );
  late final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSource(
    sharedPreferences: _sharedPreferences,
  );
  late final OnboardingRepository _onboardingRepository = OnboardingRepository(
    localDataSource: _onboardingLocalDataSource,
  );
  late final AuthRepository _authRepository =
      AuthRepository(localAuthDataSource: _authLocalDataSource);
  late final AuthService _authService =
      AuthServiceImpl(authRepository: _authRepository);
  late final OnboardingService _onboardingService = OnboardingService(
    tutorialRepository: _onboardingRepository,
  );
  late final RouterViewModel _routerViewModel = RouterViewModel(
    authService: _authService,
    onboardingService: _onboardingService,
    isUserLoggedIn: _authService.authStateListenable.value ?? false,
    isTutorialShown: _onboardingService.isTutorialShown(),
  );

  RouterViewModel get routerViewModel => _routerViewModel;

  AppDependencies();

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _authService.onInit();
  }

  void dispose() {}
}

class OrdersDependencies extends DependencyContainer {
  late final OrdersRemoteDataSource _ordersRemoteDataSource =
      OrdersRemoteDataSourceImpl();
  late final OrdersRepository _ordersRepository =
      OrdersRepository(ordersRemoteDataSource: _ordersRemoteDataSource);
  late final OrdersService _ordersService =
      OrdersService(ordersRepository: _ordersRepository);

  OrdersService get ordersService => _ordersService;

  OrdersDependencies(AppDependencies appDependencies) {
    //
  }

  OrdersScreenViewModel createOrderScreenViewModel() {
    return OrdersScreenViewModel(ordersService: ordersService);
  }

  void dispose() {
    
  }
}
