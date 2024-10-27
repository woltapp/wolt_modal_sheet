import 'package:coffee_maker_navigator_2/app/auth/domain/auth_service.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

class LoginScreenViewModel {
  LoginScreenViewModel({required AuthService authService}) : _authService = authService {
    _loginState.setIdle(value: false);
  }

  final AuthService _authService;

  final _loginState = StatefulValueNotifier<bool>.idle(false);

  StatefulValueListenable<bool> get loginState => _loginState;

  Future<void> onLoginPressed(String email, String password) async {
    _loginState.setLoading();
    try {
      await _authService.logIn(email, password);
      _loginState.setIdle(value: true);
    } catch (e) {
      _loginState.setError(error: e);
    }
  }

  void dispose() {
    _loginState.dispose();
  }
}
