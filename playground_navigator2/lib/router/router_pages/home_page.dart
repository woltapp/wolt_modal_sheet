import 'package:flutter/material.dart';
import 'package:playground_navigator2/home/home_screen.dart';

class HomePage extends Page<void> {
  const HomePage() : super(key: const ValueKey('HomePage'), name: 'Home Screen');

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      settings: this,
      builder: (context) => const HomeScreen(),
    );
  }
}
