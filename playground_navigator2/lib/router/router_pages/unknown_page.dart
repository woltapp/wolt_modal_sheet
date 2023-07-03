import 'package:flutter/material.dart';
import 'package:playground_navigator2/unknown/unknown_screen.dart';

class UnknownPage extends Page<void> {
  const UnknownPage() : super(key: const ValueKey('UnknownPage'));

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      settings: this,
      builder: (context) => const UnknownScreen(),
    );
  }

  @override
  String get name => 'Unknown Screen';
}
