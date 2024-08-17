import 'dart:async';

import 'package:coffee_maker_navigator_2/app/auth/data/repository/auth_repository.dart';
import 'package:flutter/foundation.dart';

abstract interface class AuthService {
  void onInit();

  ValueListenable<bool?> get authStateListenable;

  Future<void> logOut();

  Future<void> logIn(String email, String password);

  void dispose();
}

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;

  final ValueNotifier<bool?> _authStateNotifier = ValueNotifier(null);

  AuthServiceImpl({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  void onInit() {
    _authStateNotifier.value = _authRepository.isUserLogged();
  }

  @override
  ValueListenable<bool?> get authStateListenable => _authStateNotifier;

  @override
  Future<void> logOut() async {
    try {
      await _authRepository.logOut();
      _authStateNotifier.value = false;
    } catch (e) {
      // TODO error handling
      _authStateNotifier.value = true;
    }
  }

  @override
  Future<void> logIn(String email, String password) async {
    try {
      await _authRepository.logIn(email, password);
      _authStateNotifier.value = true;
    } catch (e) {
      // TODO error handling
      _authStateNotifier.value = false;
    }
  }

  @override
  void dispose() {
    _authStateNotifier.dispose();
  }
}
