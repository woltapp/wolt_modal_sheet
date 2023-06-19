import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:playground/home/pages/multi_page_path_name.dart';
import 'package:demo_ui_components/src/text/modal_sheet_title.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RootSheetPage {
  RootSheetPage._();

  static WoltModalSheetPage build(
    BuildContext context, {
    required VoidCallback onFooterPressed,
    required VoidCallback onClosed,
    required Function(MultiPagePathName flowName) onPathSelectedFromList,
  }) {
    final ValueNotifier<bool> isButtonEnabledNotifier = ValueNotifier(false);
    return WoltModalSheetPage(
      footer: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabledNotifier,
        builder: (_, value, __) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: WoltElevatedButton(
              onPressed: onFooterPressed,
              enabled: value,
              child: const Text("Let's start!"),
            ),
          );
        },
      ),
      pageTitle: const ModalSheetTitle('Choose a use case'),
      closeButton: WoltModalSheetCloseButton(onClosed: onClosed),
      singleChildContent: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: WoltSelectionList<MultiPagePathName>.singleSelect(
          itemTileDataGroup: const WoltSelectionListItemDataGroup(
            group: [
              WoltSelectionListItemData(
                title: 'Page with forced max height',
                value: MultiPagePathName.forcedMaxHeight,
                isSelected: false,
              ),
              WoltSelectionListItemData(
                title: 'Page with hero image',
                value: MultiPagePathName.heroImage,
                isSelected: false,
              ),
              WoltSelectionListItemData(
                title: 'Page with lazy loading list',
                value: MultiPagePathName.lazyLoadingList,
                isSelected: false,
              ),
              WoltSelectionListItemData(
                title: 'Page with auto-focus text field',
                value: MultiPagePathName.textField,
                isSelected: false,
              ),
              WoltSelectionListItemData(
                title: 'All the pages in one flow',
                value: MultiPagePathName.allPagesPath,
                isSelected: false,
              ),
            ],
          ),
          onSelectionUpdateInSingleSelectionList: (selectedItemData) {
            onPathSelectedFromList(selectedItemData.value);
            isButtonEnabledNotifier.value = selectedItemData.isSelected;
          },
        ),
      ),
    );
  }
}
