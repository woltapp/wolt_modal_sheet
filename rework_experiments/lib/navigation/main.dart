import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_page.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path_settings.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_navigator.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Function call for declarative use of navigation.
            showWoltModalSheet(
              supportedPaths: supportedPaths.values.toList(),
              context: context,
              initialPath: initialPath,
              useRootNavigator: false,
            );
          },
          child: const Text('Open WoltModalBottomSheet'),
        ),
      ),
    );
  }
}

const initialPath = [
  WoltModalSheetPath(path: 'firstScreen', arguments: Colors.pinkAccent),
];

final supportedPaths = <String, WoltModalSheetPathSettings>{
  'firstScreen': WoltModalSheetPathSettings(
    path: 'firstScreen',
    pageBuilder: (color) => WoltModalInternalPage(
      child: FirstScreen(color: color as Color),
    ),
  ),
  'secondScreen': WoltModalSheetPathSettings(
    path: 'secondScreen',
    pageBuilder: (color) => WoltModalInternalPage(
      child: SecondScreen(
        color: color as Color,
      ),
    ),
  ),
  'thirdScreen': WoltModalSheetPathSettings(
    path: 'thirdScreen',
    pageBuilder: (color) => WoltModalInternalPage(
      child: ThirdScreen(
        color: color as Color,
      ),
    ),
  ),
};

class FirstScreen extends StatelessWidget {
  final Color color;

  const FirstScreen({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .5,
      heightFactor: .7,
      child: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // The default navigator is used here to close the WoltModalSheet.
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop();
              },
              child: const Text('Close WoltModalBottomSheet'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
                WoltModalSheetNavigator.of(context)
                    .pushNamed('secondScreen', Colors.blue);
              },
              child: const Text('Go to SecondScreen'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
                WoltModalSheetNavigator.of(context).pop();
              },
              child: const Text('POP'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final Color color;

  const SecondScreen({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .5,
      heightFactor: .7,
      child: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
                WoltModalSheetNavigator.of(context)
                    .pushNamed('thirdScreen', Colors.orange);
              },
              child: const Text('Go to ThirdPage'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
                WoltModalSheetNavigator.of(context).pop();
              },
              child: const Text('POP'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  final Color color;

  const ThirdScreen({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .5,
      heightFactor: .7,
      child: Container(
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
                  WoltModalSheetNavigator.of(context)
                      .pushNamed('firstScreen', Colors.pinkAccent);
                },
                child: const Text('Go to First Screen'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
                  WoltModalSheetNavigator.of(context).pop();
                },
                child: const Text('POP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
