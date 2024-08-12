import 'package:coffee_maker_navigator_2/di/src/dependency_containers/coffee_maker_app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/src/framework/dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/ui/auth/view_model/auth_screen_view_model.dart';

class AuthScreenDependencyContainer extends FeatureLevelDependencyContainer {
  late final AuthService _authService;

  AuthScreenDependencyContainer(
      {required super.dependencyContainerAccessHandler}) {
    final appLevelDependencies =
        bindWith<CoffeeMakerAppLevelDependencyContainer>();
    _authService = appLevelDependencies.authService;
  }

  AuthScreenViewModel createViewModel() {
    return AuthScreenViewModel(authService: _authService);
  }

  @override
  void dispose() {
    // Only unbind, without disposing AuthService, because we are using but not owning.
    unbindFrom<CoffeeMakerAppLevelDependencyContainer>();
  }
}
