import 'package:coffee_maker_navigator_2/ui/extensions/context_extensions.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/modal_pages/grind/reject_order_reason.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/orders_screen.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RejectOrderModalPage extends WoltModalSheetPage {
  static final _buttonEnabledListener = ValueNotifier(false);

  RejectOrderModalPage(
    String coffeeOrderId,
    OnCoffeeOrderStatusChange onCoffeeOrderStatusChange,
  ) : super(
          stickyActionBar: ValueListenableBuilder<bool>(
            valueListenable: _buttonEnabledListener,
            builder: (_, isEnabled, __) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Builder(builder: (context) {
                  return WoltElevatedButton(
                    onPressed: () {
                      onCoffeeOrderStatusChange(coffeeOrderId);
                      context.routerViewModel
                          .onGrindStepExit(hasStartedGrinding: false);
                    },
                    theme: WoltElevatedButtonTheme.secondary,
                    colorName: WoltColorName.red,
                    enabled: isEnabled,
                    child: const Text('Reject'),
                  );
                }),
              );
            },
          ),
          pageTitle: const ModalSheetTitle('Reject order'),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
          leadingNavBarWidget: const WoltModalSheetBackButton(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: ModalSheetContentText(
                        'Please select a reason for rejecting the order'),
                  ),
                  WoltSelectionList<RejectOrderReason>.singleSelect(
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
                      _buttonEnabledListener.value =
                          selectedItemData.isSelected;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
}
