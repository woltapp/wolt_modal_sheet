import 'package:coffee_maker_navigator_2/app/di/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/app/auth/domain/auth_service.dart';
import 'package:coffee_maker_navigator_2/features/login/ui/view_model/login_screen_view_model.dart';
import 'package:wolt_di/wolt_di.dart';

class LoginScreenDependencyContainer extends FeatureLevelDependencyContainer {
  late final AuthService _authService;

  LoginScreenDependencyContainer() {
    final appLevelDependencies =
        bindWith<CoffeeMakerAppLevelDependencyContainer>();
    _authService = appLevelDependencies.authService;
  }

  // ViewModel should always be created lazily.
  LoginScreenViewModel createViewModel() {
    return LoginScreenViewModel(authService: _authService);
  }

  @override
  void dispose() {
    // Only unbind, without disposing AuthService, because we are using but not owning.
    unbindFrom<CoffeeMakerAppLevelDependencyContainer>();
  }
}
