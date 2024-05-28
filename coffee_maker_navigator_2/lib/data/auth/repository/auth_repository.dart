import 'dart:async';

import 'package:coffee_maker_navigator_2/data/auth/local/auth_local_data_source.dart';

class AuthRepository {
  final AuthLocalDataSource localAuthDataSource;

  AuthRepository({required this.localAuthDataSource});

  bool isUserLogged() {
    return localAuthDataSource.isUserLoggedIn();
  }

  Future<void> logOut() async {
    await localAuthDataSource.setUserLoggedIn(false);
  }

  Future<void> logIn(String email, String password) async {
    // Simulate a login request. In a real app, this would be an HTTP request, and the email and
    // password would be used to authenticate the user. Then the token would be stored in the local.
    await localAuthDataSource.setUserLoggedIn(true);
  }
}
