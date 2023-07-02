import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Unknown page :(', style: Theme.of(context).textTheme.displayLarge!),
      ),
    );
  }
}
