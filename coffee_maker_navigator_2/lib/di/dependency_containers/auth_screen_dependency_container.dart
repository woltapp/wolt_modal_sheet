import 'package:coffee_maker_navigator_2/di/dependency_containers/app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/ui/auth/view_model/auth_screen_view_model.dart';

class AuthScreenDependencyContainer extends LocalDependencyContainer {
  late final AuthService _authService;

  AuthScreenDependencyContainer({required super.resolver}) {
    final appDeps = bindWith<AppLevelDependencyContainer>();
    _authService = appDeps.authService;
  }

  AuthScreenViewModel createViewModel() {
    return AuthScreenViewModel(authService: _authService);
  }

  @override
  void dispose() {
    // Only unbind, without disposing AuthService, becuase we are using but not owning.
    unbindFrom<AppLevelDependencyContainer>();
  }
}
