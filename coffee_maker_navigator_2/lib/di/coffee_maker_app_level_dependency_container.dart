import 'package:coffee_maker_navigator_2/data/auth/local/auth_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/auth/repository/auth_repository.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/local/onboarding_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/repository/onboarding_repository.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/domain/onboarding/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/ui/router/view/app_router_delegate.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolt_di/wolt_di.dart';

/// A class that manages app-level dependencies.
class CoffeeMakerAppLevelDependencyContainer
    extends AppLevelDependencyContainer {
  late final SharedPreferences _sharedPreferences;

  late final _authLocalDataSource = _createAuthLocalDataSource();
  late final _authRepository = _createAuthRepository();
  late final _authService = _createAuthService();

  late final _onboardingLocalDataSource = _createOnboardingLocalDataSource();
  late final _onboardingRepository = _createOnboardingRepository();
  late final _onboardingService = _createOnboardingService();

  late final _appRouterDelegate = _createAppRouterDelegate();
  late final _backButtonDispatcher = _createRootBackButtonDispatcher();
  late final _routerViewModel = _createRouterViewModel();

  AppRouterDelegate get appRouterDelegate => _appRouterDelegate;
  BackButtonDispatcher get backButtonDispatcher => _backButtonDispatcher;
  RouterViewModel get routerViewModel => _routerViewModel;
  AuthService get authService => _authService;

  CoffeeMakerAppLevelDependencyContainer();

  @override
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  OnboardingLocalDataSource _createOnboardingLocalDataSource() {
    return OnboardingLocalDataSource(sharedPreferences: _sharedPreferences);
  }

  AuthLocalDataSource _createAuthLocalDataSource() {
    return AuthLocalDataSource(sharedPreferences: _sharedPreferences);
  }

  OnboardingRepository _createOnboardingRepository() {
    return OnboardingRepository(localDataSource: _onboardingLocalDataSource);
  }

  AuthRepository _createAuthRepository() {
    return AuthRepository(localAuthDataSource: _authLocalDataSource);
  }

  OnboardingService _createOnboardingService() {
    return OnboardingService(tutorialRepository: _onboardingRepository);
  }

  AuthServiceImpl _createAuthService() {
    return AuthServiceImpl(authRepository: _authRepository)..onInit();
  }

  AppRouterDelegate _createAppRouterDelegate() {
    return AppRouterDelegate();
  }

  RootBackButtonDispatcher _createRootBackButtonDispatcher() {
    return RootBackButtonDispatcher();
  }

  RouterViewModel _createRouterViewModel() {
    return RouterViewModel(
      authService: _authService,
      onboardingService: _onboardingService,
      isUserLoggedIn: _authService.authStateListenable.value ?? false,
      isTutorialShown: _onboardingService.isTutorialShown(),
    );
  }
}
