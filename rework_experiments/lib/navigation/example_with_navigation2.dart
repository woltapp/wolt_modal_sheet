import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_page.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path_settings.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_navigator.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Navigator 2.0 example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            GoRouter.of(context).goNamed('bottom_sheet',
                pathParameters: {'pages': 'firstScreen'});
          },
          child: const Text('Open WoltModalSheet'),
        ),
      ),
    );
  }
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const _HomeScreen();
      },
      routes: [
        GoRoute(
          name: 'bottom_sheet',
          path: 'bottom_sheet/:pages',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Here can be an implementation of any complexity of working with
            // parameters. It does not depend on how wolt_modal_sheet works,
            // and more related to operating with a concrete chosen navigation.
            //
            // This particular implementation is a simple straightforward
            // way provided as an example.
            final requestedPages = state.uri.pathSegments.toList();
            requestedPages.removeAt(0);
            final listRequestedPages = requestedPages[0].split(',');
            final pages = <WoltModalSheetPath>[];
            for (var path in listRequestedPages) {
              if (path.contains('..')) {
                final pageAndParams = path.split('..');
                final pageName = pageAndParams[0];
                final params = pageAndParams.length > 1 ? pageAndParams[1] : '';
                if (params.isNotEmpty) {
                  pages.add(WoltModalSheetPath(
                      path: pageName, arguments: params == 'true'));
                }
              } else if (path.isNotEmpty) {
                pages.add(WoltModalSheetPath(path: path));
              }
            }
            return WoltModalSheetPage(
              supportedPaths: supportedPaths.values.toList(),
              initialPath: pages,
              constraints: const BoxConstraints(maxHeight: 500),
              onPathChangedInternal: (currentWoltModalSheetPaths) =>
                  onPathChangedInternal(context, currentWoltModalSheetPaths),
            );
          },
        ),
      ],
    ),
  ],
);

/// Callback on internal changing path.
void onPathChangedInternal(
  BuildContext context,
  List<WoltModalSheetPath> currentWoltModalSheetPaths,
) {
  // Here can be an implementation of any complexity of working with
  // parameters. It does not depend on how wolt_modal_sheet works,
  // and more related to operating with a concrete chosen navigation.
  //
  // This particular implementation is a simple straightforward
  // way provided as an example.
  List<String> currentWoltModalSheetPath = <String>[];
  for (WoltModalSheetPath path in currentWoltModalSheetPaths) {
    if (path.arguments != null) {
      currentWoltModalSheetPath.add('${path.path}..${path.arguments},');
    } else {
      currentWoltModalSheetPath.add('${path.path},');
    }
  }
  String pages = '';
  currentWoltModalSheetPath.map((path) {
    pages = '$pages$path';
  }).toList();

  GoRouter.of(context)
      .goNamed('bottom_sheet', pathParameters: {'pages': pages});
}

final Map<String, WoltModalSheetPathSettings> supportedPaths =
    <String, WoltModalSheetPathSettings>{
  'firstScreen': WoltModalSheetPathSettings(
    path: 'firstScreen',
    pageBuilder: (arguments) => WoltModalInternalPage(
      arguments: arguments,
      child: const _FirstScreen(),
      name: 'firstScreen',
    ),
  ),
  'secondScreen': WoltModalSheetPathSettings(
    path: 'secondScreen',
    pageBuilder: (arguments) {
      return WoltModalInternalPage(
        arguments: arguments,
        child: _SecondScreen(
          isChecked: arguments as bool,
        ),
        name: 'secondScreen',
      );
    },
  ),
  'thirdScreen': WoltModalSheetPathSettings(
    path: 'thirdScreen',
    pageBuilder: (arguments) => WoltModalInternalPage(
      arguments: arguments,
      child: const _ThirdScreen(),
      name: 'thirdScreen',
    ),
  ),
};

class _FirstScreen extends StatefulWidget {
  const _FirstScreen();

  @override
  State<_FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<_FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pinkAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'First Screen',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 40.0,
          ),
          ElevatedButton(
            onPressed: () {
              // The GoRouter is used here to close the WoltModalSheet.
              GoRouter.of(context).pop();
            },
            child: const Text('Close WoltModalBottomSheet'),
          ),
          const SizedBox(
            height: 40.0,
          ),
          ElevatedButton(
            onPressed: () {
              // This uses WoltModalSheetNavigator to navigate within the WoltModalSheet.
              WoltModalSheetNavigator.of(context).pushNamed(
                'secondScreen',
                false,
              );
            },
            child: const Text('Go to SecondScreen'),
          ),
          const SizedBox(
            height: 40.0,
          ),
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

class _SecondScreen extends StatefulWidget {
  final bool isChecked;

  const _SecondScreen({
    required this.isChecked,
  });

  @override
  State<_SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<_SecondScreen> {
  late final _isCheckedState = ValueNotifier<bool>(widget.isChecked);

  @override
  void didUpdateWidget(_SecondScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      _isCheckedState.value = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.lightBlueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Second Screen',
            style: TextStyle(fontSize: 30),
          ),
          ValueListenableBuilder(
            valueListenable: _isCheckedState,
            builder: (_, isChecked, __) => Checkbox(
              value: isChecked,
              onChanged: (value) {
                if (value != null) {
                  _isCheckedState.value = value;
                }
              },
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          ElevatedButton(
            onPressed: () {
              WoltModalSheetNavigator.of(context).pushNamed(
                'thirdScreen',
              );
            },
            child: const Text('Go to ThirdPage'),
          ),
          const SizedBox(
            height: 40.0,
          ),
          ElevatedButton(
            onPressed: () {
              WoltModalSheetNavigator.of(context).pop();
            },
            child: const Text('POP'),
          ),
        ],
      ),
    );
  }
}

class _ThirdScreen extends StatelessWidget {
  const _ThirdScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Third Screen',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
              onPressed: () {
                WoltModalSheetNavigator.of(context).pushNamed(
                  'firstScreen',
                );
              },
              child: const Text('Go to First Screen'),
            ),
            const SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
              onPressed: () {
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
