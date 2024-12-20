import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// This file does not exist yet,
// it will be generated in the next step
import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      appBuilder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: true,
        backButtonDispatcher: RootBackButtonDispatcher(),
        routerDelegate: SingleChildRouterDelegate(
          child: child,
        ),
      ),
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Default',
              data: AppThemeData.themeData(),
            )
          ],
        ),
        DeviceFrameAddon(
          devices: Devices.all,
          initialDevice: Devices.android.mediumPhone,
        ),
        TextScaleAddon(),
      ],
    );
  }
}

final globalNavKey = GlobalKey<NavigatorState>();

class SingleChildRouterDelegate extends RouterDelegate<int>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  SingleChildRouterDelegate({
    required this.child,
  });

  final Widget child;

  @override
  GlobalKey<NavigatorState> get navigatorKey => globalNavKey;

  @override
  Future<void> setNewRoutePath(int configuration) async {}

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: globalNavKey,
      pages: [
        MaterialPage(
          child: child,
        ),
      ],
    );
  }
}
