import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_page.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path_settings.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_navigator.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_route.dart';
import 'package:rework_experiments/wolt_page_layout/wolt_page_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
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
  'testScreen': WoltModalSheetPathSettings(
    path: 'testScreen',
    pageBuilder: (_) => const WoltModalInternalPage(
      child: _TestScreen(),
    ),
  ),
};

final supportedPathsMaterial = <String, WoltModalSheetPathSettings>{
  'firstScreen': WoltModalSheetPathSettings(
    path: 'firstScreen',
    pageBuilder: (color) => MaterialPage(
      child: FirstScreen(color: color as Color),
    ),
  ),
  'secondScreen': WoltModalSheetPathSettings(
    path: 'secondScreen',
    pageBuilder: (color) => MaterialPage(
      child: SecondScreen(
        color: color as Color,
      ),
    ),
  ),
  'thirdScreen': WoltModalSheetPathSettings(
    path: 'thirdScreen',
    pageBuilder: (color) => MaterialPage(
      child: ThirdScreen(
        color: color as Color,
      ),
    ),
  ),
  'testScreen': WoltModalSheetPathSettings(
    path: 'testScreen',
    pageBuilder: (_) => const MaterialPage(
      child: _TestScreen(),
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
    return Container(
      color: color,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'First Screen',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 40),
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
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop();
              },
              child: const Text('POP'),
            ),
            const SizedBox(height: 40),
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
    return Container(
      height: 300,
      color: color,
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Second Screen',
            style: TextStyle(fontSize: 30),
          ),
          ElevatedButton(
            onPressed: () {
              // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
              WoltModalSheetNavigator.of(context)
                  .pushNamed('thirdScreen', Colors.orange);
            },
            child: const Text('Go to ThirdPage'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
              WoltModalSheetNavigator.of(context).pop();
            },
            child: const Text('POP'),
          ),
        ],
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
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Third Screen',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
                WoltModalSheetNavigator.of(context).pushNamed(
                  'testScreen',
                );
              },
              child: const Text('Go to Test Screen'),
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

class _TestScreen extends StatelessWidget {
  const _TestScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      color: Colors.red,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: WoltPageLayout(
              header: const _CollapsedContent('header', Colors.blue),
              footer: const _CollapsedContent('footer', Colors.green),
              slivers: [
                SliverList.builder(
                  itemBuilder: (context, index) {
                    debugPrint('1st seq $index');
                    return _Slice(index);
                  },
                  itemCount: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
              WoltModalSheetNavigator.of(context).pushNamed(
                'firstScreen',
                Colors.blueGrey,
              );
            },
            child: const Text('Go to First Screen'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
              WoltModalSheetNavigator.of(context).pop();
            },
            child: const Text('POP'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _CollapsedContent extends StatefulWidget {
  final String title;
  final Color color;

  const _CollapsedContent(this.title, this.color);

  @override
  State<_CollapsedContent> createState() => _CollapsedContentState();
}

class _CollapsedContentState extends State<_CollapsedContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: widget.color,
      height: _isExpanded ? 300 : 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(widget.title)),
          Checkbox(
            value: _isExpanded,
            onChanged: (value) => setState(() => _isExpanded = value!),
          ),
        ],
      ),
    );
  }
}

class _Slice extends StatelessWidget {
  final int index;

  const _Slice(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: const EdgeInsets.all(8),
      height: 25,
      child: Text('Item $index'),
    );
  }
}
