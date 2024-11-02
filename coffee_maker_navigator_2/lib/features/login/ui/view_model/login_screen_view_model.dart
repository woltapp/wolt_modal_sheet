import 'package:coffee_maker_navigator_2/app/auth/domain/auth_service.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

class LoginScreenViewModel {
  LoginScreenViewModel({required AuthService authService}) : _authService = authService {
    _isLoggedIn.setIdle(value: false);
  }

  final AuthService _authService;

  final _isLoggedIn = StatefulValueNotifier<bool>.idle(false);

  StatefulValueListenable<bool> get isLoggedIn => _isLoggedIn;

  Future<void> onLoginPressed(String email, String password) async {
    _isLoggedIn.setLoading();
    try {
      await _authService.logIn(email, password);
      _isLoggedIn.setIdle(value: true);
    } catch (e) {
      _isLoggedIn.setError(error: e);
    }
  }

  void dispose() {
    _isLoggedIn.dispose();
  }
}
