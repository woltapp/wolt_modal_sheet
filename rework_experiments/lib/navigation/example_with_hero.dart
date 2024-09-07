import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_page.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_path_settings.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_navigator.dart';
import 'package:rework_experiments/navigation/lib/navigation/external/wolt_modal_sheet_route.dart';
import 'package:rework_experiments/wolt_page_layout/wolt_page_layout.dart';

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
};

class FirstScreen extends StatelessWidget {
  final Color color;

  const FirstScreen({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final headerListenable = ValueNotifier<bool>(false);
    final footerListenable = ValueNotifier<bool>(false);

    return WoltPageLayout(
      header: _CollapsedContent('header', Colors.blue, headerListenable),
      footer: _CollapsedContent('footer', Colors.green, footerListenable),
      slivers: [
        SliverToBoxAdapter(
          child: ElevatedButton(
            onPressed: () {
              // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
              WoltModalSheetNavigator.of(context)
                  .pushNamed('secondScreen', Colors.blue);
            },
            child: const Text('Go to SecondScreen'),
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) {
            debugPrint('1st seq $index');
            return _Slice(index);
          },
          itemCount: 10,
        ),
      ],
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
    final headerListenable = ValueNotifier<bool>(false);
    final ValueNotifier<bool> footerListenable = ValueNotifier<bool>(false);

    return WoltPageLayout(
      header: _CollapsedContent('header', Colors.blue, headerListenable),
      footer: _CollapsedContent('footer', Colors.green, footerListenable),
      slivers: [
        SliverToBoxAdapter(
          child: ElevatedButton(
            onPressed: () {
              // The default navigator is used here to close the WoltModalSheet.
              WoltModalSheetNavigator.of(
                context,
              ).pop();
            },
            child: const Text('POP'),
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) {
            debugPrint('1st seq $index');
            return _Slice(index);
          },
          itemCount: 10,
        ),
      ],
    );
  }
}

class _CollapsedContent extends StatefulWidget {
  final ValueNotifier<bool> isExpandedListener;
  final String title;
  final Color color;

  const _CollapsedContent(
    this.title,
    this.color,
    this.isExpandedListener,
  );

  @override
  State<_CollapsedContent> createState() => _CollapsedContentState();
}

class _CollapsedContentState extends State<_CollapsedContent> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isExpandedListener,
      builder: (BuildContext context, bool value, Widget? child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: widget.color,
          height: value ? 300 : 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(widget.title)),
              Checkbox(
                  value: value,
                  onChanged: (value) {
                    widget.isExpandedListener.value = value!;
                  }),
            ],
          ),
        );
      },
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
