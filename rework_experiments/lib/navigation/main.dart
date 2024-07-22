import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_page.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_route.dart';
import 'package:rework_experiments/navigation/wolt_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: WoltModalSheet(
          supportedPages: supportedPages.values.toList(),
          initialPage: initialPage,
        ),
      ),
    );
  }
}

const initialPage = [
  WoltModalSheetPath(name: 'firstScreen', arguments: Colors.pinkAccent),
];

final Map<String, WoltModalSheetRoute> supportedPages =
    <String, WoltModalSheetRoute>{
  'firstScreen': WoltModalSheetRoute(
    name: 'firstScreen',
    pageBuilder: (color) => WoltModalSheetPage(
      child: FirstPage(color: color as Color),
      // name: 'testScreen',
    ),
  ),
  'secondScreen': WoltModalSheetRoute(
    name: 'secondScreen',
    pageBuilder: (color) => WoltModalSheetPage(
      child: SecondPage(color: color as Color,),
      // name: 'testScreen',
    ),
  ),
  'thirdScreen': WoltModalSheetRoute(
    name: 'thirdScreen',
    pageBuilder: (color) => WoltModalSheetPage(
      child: ThirdPage(color: color as Color,),
    ),
  ),
};

class FirstPage extends StatelessWidget {
  final Color color;

  const FirstPage({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              WoltNavigator.of(context).pushNamed('secondScreen', Colors.blue);
            },
            child: const Text('Go to SecondScreen'),
          ),
          ElevatedButton(
            onPressed: () {
              WoltNavigator.of(context).pop();
            },
            child: const Text('POP'),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final Color color;

  const SecondPage({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              WoltNavigator.of(context).pushNamed('thirdScreen', Colors.orange);
            },
            child: const Text('Go to ThirdPage'),
          ),
          ElevatedButton(
            onPressed: () {
              WoltNavigator.of(context).pop();
            },
            child: const Text('POP'),
          ),
        ],
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  final Color color;

  const ThirdPage({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                WoltNavigator.of(context).pushNamed('firstScreen', Colors.pinkAccent);
              },
              child: const Text('Go to First Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                WoltNavigator.of(context).pop();
              },
              child: const Text('POP'),
            ),
          ],
        ),
      ),
    );
  }
}
