import 'package:coffee_maker_navigator_2/di/dependency_containers/app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/ui/auth/view_model/auth_screen_view_model.dart';

class AuthScreenDependencyContainer extends SyncDependencyContainer {
  late final AuthService _authService;

  AuthScreenDependencyContainer(
      AppLevelDependencyContainer appLevelDependencyContainer)
      : _authService = appLevelDependencyContainer.authService;

  AuthScreenViewModel createViewModel() {
    return AuthScreenViewModel(authService: _authService);
  }
}
