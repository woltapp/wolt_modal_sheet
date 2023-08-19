import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/multi_page_path_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RootSheetPage {
  RootSheetPage._();

  static WoltModalSheetPage build(
    BuildContext context, {
    required VoidCallback onSabPressed,
    required VoidCallback onClosed,
    required Function(MultiPagePathName flowName) onPathSelectedFromList,
  }) {
    final ValueNotifier<bool> isButtonEnabledNotifier = ValueNotifier(false);
    const title = 'Choose a use case';
    return WoltModalSheetPage(
      stickyActionBar: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabledNotifier,
        builder: (_, value, __) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltElevatedButton(
              onPressed: onSabPressed,
              enabled: value,
              child: const Text("Let's start!"),
            ),
          );
        },
      ),
      pageTitle: const ModalSheetTitle(title),
      hasTopBarLayer: false,
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: onClosed),
      singleChildContent: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
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
                title: 'Page with no title and no top bar',
                value: MultiPagePathName.noTitleNoTopBar,
                isSelected: false,
              ),
              WoltSelectionListItemData(
                title: 'Page with dynamic properties',
                value: MultiPagePathName.dynamicPageProperties,
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
