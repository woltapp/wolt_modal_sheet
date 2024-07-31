import 'package:coffee_maker_navigator_2/data/auth/local/auth_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/auth/repository/auth_repository.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/local/onboarding_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/repository/onboarding_repository.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/domain/onboarding/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/ui/router/view/app_router_delegate.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that manages app-level dependencies.
///
/// The `AppLevelDependencies` initializes and manages dependencies which are required for the
/// entire lifecycle of the application.
class AppLevelDependencyContainer extends GlobalDependencyContainer {
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

  AppLevelDependencyContainer();

  @override
  Future<void> init() async {
    // Mikhail: How to lazily initialize SharedPreferences and inject to Auth?
    // We cannot handle shared pref lazily, because it starts asynchronously,
    // and we have to wait for this async process, so we only can init it here.
    // But all other things can be lazy because they don't need to be awaited.
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
    )..onInit();
  }
}
