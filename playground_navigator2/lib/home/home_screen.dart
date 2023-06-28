import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/playground_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSlowAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wolt Modal Sheet Playground'),
        actions: [
          WoltCircularElevatedButton(
            onPressed: () {
              setState(() {
                timeDilation = isSlowAnimation ? 1.0 : 8.0;
                isSlowAnimation = !isSlowAnimation;
              });
            },
            icon: Icons.speed_outlined,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Builder(builder: (context) {
        return Center(
          child: SizedBox(
            width: 200,
            child: WoltElevatedButton(
              onPressed: context.read<PlaygroundCubit>().onButtonPressed,
              child: const Text('Show Modal Sheet'),
            ),
          ),
        );
      }),
    );
  }
}
