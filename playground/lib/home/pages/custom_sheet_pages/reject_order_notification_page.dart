import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum RejectOrderReason {
  runOutOfCoffee(
    title: 'Run out of coffee',
    subtitle: 'One or more items are out of stock',
    leadingIcon: Icons.search_off,
  ),
  tooBusy(
    title: 'Too busy',
    subtitle: 'There is not enough time to prepare the order',
    leadingIcon: Icons.people,
  ),
  closingSoon(
    title: 'Closing soon',
    subtitle: 'Not enough time to prepare the order before closing',
    leadingIcon: Icons.timelapse,
  );

  const RejectOrderReason({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
  });

  final IconData leadingIcon;
  final String title;
  final String subtitle;
}

final _buttonEnabledListener = ValueNotifier(false);

class RejectOrderNotificationPage extends WoltModalSheetPage {
  RejectOrderNotificationPage()
      : super(
          stickyActionBar: ValueListenableBuilder<bool>(
            valueListenable: _buttonEnabledListener,
            builder: (_, isEnabled, __) {
              return Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: WoltElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _buttonEnabledListener.value = false;
                    },
                    theme: WoltElevatedButtonTheme.secondary,
                    colorName: WoltColorName.red,
                    enabled: isEnabled,
                    height: 24.0,
                    child: const Text('Reject'),
                  ),
                );
              });
            },
          ),
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: const ModalSheetTopBarTitle('Reject reason'),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
          leadingNavBarWidget: const WoltModalSheetBackButton(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 72),
            child: WoltSelectionList<RejectOrderReason>.singleSelect(
              itemTileDataGroup: WoltSelectionListItemDataGroup(
                group: RejectOrderReason.values
                    .map(
                      (e) => WoltSelectionListItemData(
                        title: e.title,
                        subtitle: e.subtitle,
                        leadingIcon: e.leadingIcon,
                        value: e,
                        isSelected: false,
                      ),
                    )
                    .toList(),
              ),
              onSelectionUpdateInSingleSelectionList: (selectedItemData) {
                _buttonEnabledListener.value = selectedItemData.isSelected;
              },
            ),
          ),
        );
}
