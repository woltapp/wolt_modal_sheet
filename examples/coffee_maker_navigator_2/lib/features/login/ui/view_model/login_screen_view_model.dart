import 'package:coffee_maker_navigator_2/app/auth/domain/auth_service.dart';

class LoginScreenViewModel {
  final AuthService authService;

  LoginScreenViewModel({required this.authService});

  Future<void> onLoginPressed(String email, String password) async {
    await authService.logIn(email, password);
  }
}
