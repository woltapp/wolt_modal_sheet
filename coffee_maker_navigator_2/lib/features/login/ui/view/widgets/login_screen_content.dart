import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class LoginScreenContent extends StatelessWidget {
  const LoginScreenContent({super.key, required this.onLoginPressed});

  final void Function(String, String) onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage('assets/images/dash_coffee.webp',
                        package: 'assets'),
                    fit: BoxFit.cover,
                    height: 216,
                    width: 384,
                  ),
                  Text(
                    'Welcome to Coffee Maker!',
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  const SizedBox(height: 50),
                  const AppTextFormField(
                    labelText: 'Username',
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const AppTextFormField(
                    labelText: 'Password',
                    obscureText: true,
                    autocorrect: false,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 30),
                  WoltElevatedButton(
                    onPressed: () {
                      onLoginPressed('email', 'password');
                    },
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
