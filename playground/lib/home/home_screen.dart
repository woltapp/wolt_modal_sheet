import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:playground/home/custom_sheets/floating_bottom_sheet.dart';
import 'package:playground/home/custom_sheets/top_notification_sheet.dart';
import 'package:playground/home/pages/custom_sheet_pages/new_order_notification_page.dart';
import 'package:playground/home/pages/root_sheet_page.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

const double _buttonWidth = 250.0;

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
                      pageListBuilder: (BuildContext context) {
                        return [RootSheetPage.build(context)];
                      },
                    );
                  },
                  child: const Text('Show ALC Wolt Modal Sheet'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: _buttonWidth,
                child: WoltElevatedButton(
                  onPressed: () {
                    WoltModalSheet.show(
                      barrierDismissible: false,
                      context: context,
                      modalTypeBuilder: (_) =>
                          const TopNotificationModalSheet(),
                      pageListBuilder: (_) => [NewOrderNotificationPage()],
                    );
                  },
                  child: const Text('Show Custom Modal Sheet'),
                ),
              )
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            WoltModalSheet.show(
              barrierDismissible: false,
              context: context,
              modalTypeBuilder: (_) => const FloatingBottomSheet(),
              pageListBuilder: (_) => [NewOrderNotificationPage()],
            );
          },
          child: const Icon(Icons.notifications_active),
        ));
  }

  WoltModalType _modalTypeBuilder(BuildContext context) {
    switch (context.screenSize) {
      case WoltScreenSize.small:
        return WoltModalType.bottomSheet();
      case WoltScreenSize.large:
        return WoltModalType.sideSheet();
    }
  }
}
