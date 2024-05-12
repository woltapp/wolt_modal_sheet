import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:playground/home/dynamic_page_properties.dart';
import 'package:playground/home/pages/root_sheet_page.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

const double _buttonWidth = 200.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.onThemeBrightnessChanged, super.key});

  final void Function(bool) onThemeBrightnessChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSlowAnimation = false;
  bool _isLightTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wolt Modal Sheet Playground'),
        actions: [
          WoltCircularElevatedButton(
            onPressed: () {
              setState(() {
                timeDilation = _isSlowAnimation ? 1.0 : 8.0;
                _isSlowAnimation = !_isSlowAnimation;
              });
            },
            icon: Icons.speed_outlined,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Builder(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Light Theme'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Switch(
                    value: !_isLightTheme,
                    onChanged: (bool newValue) {
                      _isLightTheme = !newValue;
                      widget.onThemeBrightnessChanged(_isLightTheme);
                    },
                  ),
                ),
                const Text('Dark Theme'),
              ],
            ),
            SizedBox(
              width: _buttonWidth,
              child: WoltElevatedButton(
                onPressed: () {
                  WoltModalSheet.show(
                    context: context,
                    modalTypeBuilder: _modalTypeBuilder,
                    onModalDismissedWithDrag: () {
                      debugPrint('Bottom sheet is dismissed with drag.');
                      Navigator.of(context).pop();
                    },
                    onModalDismissedWithBarrierTap: () {
                      debugPrint('Modal is dismissed with barrier tap.');
                      Navigator.of(context).pop();
                    },
                    decorator: (child) {
                      return DynamicPageProperties(
                        notifier: DynamicPagePropertiesNotifier(
                          DynamicPagePropertiesModel(enableCloseDrag: true),
                        ),
                        child: child,
                      );
                    },
                    enableDrag: true,
                    maxDialogWidth: 560,
                    minDialogWidth: 400,
                    minPageHeight: 0.0,
                    maxPageHeight: 0.9,
                    pageListBuilder: (BuildContext context) {
                      return [RootSheetPage.build(context)];
                    },
                  );
                },
                child: const Text('Show Modal Sheet'),
              ),
            ),
          ],
        );
      }),
    );
  }

  WoltModalType _modalTypeBuilder(BuildContext context) {
    switch (context.screenSize) {
      case WoltScreenSize.small:
        return WoltModalType.bottomSheet;
      case WoltScreenSize.large:
        return WoltModalType.dialog;
    }
  }
}
