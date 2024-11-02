import 'package:coffee_maker_navigator_2/features/login/di/login_screen_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/login/ui/view/widgets/login_screen_content.dart';
import 'package:coffee_maker_navigator_2/features/login/ui/view_model/login_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:wolt_di/wolt_di.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with DependencyContainerSubscriptionMixin<LoginScreenDependencyContainer, LoginScreen> {
  late LoginScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final container = DependencyInjector.container<LoginScreenDependencyContainer>(context);
    _viewModel = container.createViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreenContent(
      isLoggedIn: _viewModel.isLoggedIn,
      onLoginPressed: _viewModel.onLoginPressed,
    );
  }
}
