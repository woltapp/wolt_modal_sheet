import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:playground/home/pages/root_sheet_page.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _contentWidth = 300.0;
const double _breakPoint = 524.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.onThemeBrightnessChanged, super.key});

  final void Function(bool) onThemeBrightnessChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSlowAnimation = false;
  bool _isLightTheme = true;
  _Responsiveness _selectedResponsiveness = _Responsiveness.auto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wolt Modal Sheet Playground'),
        actions: [
          WoltCircularElevatedButton(
            onPressed: () {
              timeDilation = _isSlowAnimation ? 1.0 : 8.0;
              _isSlowAnimation = !_isSlowAnimation;
            },
            icon: Icons.speed_outlined,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Builder(builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: _contentWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select responsiveness',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      WoltSelectionList<_Responsiveness>.singleSelect(
                        tilePadding:
                            const EdgeInsetsDirectional.symmetric(vertical: 8),
                        itemTileDataGroup: WoltSelectionListItemDataGroup(
                          group: _Responsiveness.values
                              .map(
                                (e) => WoltSelectionListItemData(
                                  title: e.label,
                                  value: e,
                                  isSelected: _selectedResponsiveness == e,
                                ),
                              )
                              .toList(),
                        ),
                        onSelectionUpdateInSingleSelectionList: (selectedItem) {
                          _selectedResponsiveness = selectedItem.value;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                    width: _contentWidth,
                    child: WoltElevatedButton(
                      onPressed: () {
                        WoltModalSheet.show(
                          context: context,
                          modalTypeBuilder: (BuildContext context) {
                            final woltDialogType = _isLightTheme
                                ? const WoltDialogType()
                                : const WoltDialogType().copyWith(
                                    shapeBorder: const BeveledRectangleBorder(),
                                  );
                            final bottomSheetType = _isLightTheme
                                ? const WoltBottomSheetType()
                                : const WoltBottomSheetType().copyWith(
                                    shapeBorder: const BeveledRectangleBorder(),
                                  );
                            final sideSheetType = _isLightTheme
                                ? const WoltSideSheetType()
                                : const WoltSideSheetType().copyWith(
                                    shapeBorder: const BeveledRectangleBorder(),
                                  );
                            switch (_selectedResponsiveness) {
                              case _Responsiveness.alwaysDialog:
                                return woltDialogType;
                              case _Responsiveness.alwaysBottomSheet:
                                return bottomSheetType;
                              case _Responsiveness.alwaysSideSheet:
                                return sideSheetType;
                              case _Responsiveness.auto:
                                final width = MediaQuery.sizeOf(context).width;
                                return width < _breakPoint
                                    ? bottomSheetType
                                    : woltDialogType;
                            }
                          },
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
                      child: const Text('Show Modal Sheet'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

enum _Responsiveness {
  alwaysDialog('Always dialog'),
  alwaysBottomSheet('Always bottom sheet'),
  alwaysSideSheet('Always side sheet'),
  auto('Auto');

  final String label;

  const _Responsiveness(this.label);
}
