import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';

class AuthScreenViewModel extends ChangeNotifier {
  final AuthService authService;

  AuthScreenViewModel({required this.authService});

  Future<void> logIn(String email, String password) async {
    await authService.logIn(email, password);
  }
}
