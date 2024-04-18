import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:playground/home/pages/sheet_page_with_custom_top_bar.dart';
import 'package:playground/home/pages/sheet_page_with_dynamic_page_properties.dart';
import 'package:playground/home/pages/sheet_page_with_forced_max_height.dart';
import 'package:playground/home/pages/sheet_page_with_hero_image.dart';
import 'package:playground/home/pages/sheet_page_with_lazy_list.dart';
import 'package:playground/home/pages/sheet_page_with_no_page_title_and_no_top_bar.dart';
import 'package:playground/home/pages/sheet_page_with_non_scrolling_layout.dart';
import 'package:playground/home/pages/sheet_page_with_text_field.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RootSheetPage {
  RootSheetPage._();

  static WoltModalSheetPage build(BuildContext context) {
    final ValueNotifier<bool> isButtonEnabledNotifier = ValueNotifier(false);
    const title = 'Choose a use case';

    return WoltModalSheetPage(
      stickyActionBar: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabledNotifier,
        builder: (_, value, __) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltElevatedButton(
              onPressed: WoltModalSheet.of(context).showNext,
              enabled: value,
              child: const Text("Let's start!"),
            ),
          );
        },
      ),
      pageTitle: const ModalSheetTitle(title),
      hasTopBarLayer: false,
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: Builder(builder: (context) {
        final allPagesAfterRootPage = [
          SheetPageWithForcedMaxHeight.build(context, Theme.of(context).brightness, isLastPage: false),
          SheetPageWithHeroImage.build(context, isLastPage: false),
          SheetPageWithLazyList.build(context, isLastPage: false),
          SheetPageWithTextField.build(context, isLastPage: false),
          SheetPageWithCustomTopBar.build(context, isLastPage: false),
          SheetPageWithNoPageTitleNoTopBar.build(context, isLastPage: false),
          SheetPageWithDynamicPageProperties.build(context, isLastPage: true),
        ];
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            children: [
              WoltSelectionList<ModalPageName?>.singleSelect(
                itemTileDataGroup: const WoltSelectionListItemDataGroup(
                  group: [
                    WoltSelectionListItemData(
                      title: 'Page with forced max height',
                      value: SheetPageWithForcedMaxHeight.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'Page with hero image',
                      value: SheetPageWithHeroImage.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'Page with lazy loading list',
                      value: SheetPageWithLazyList.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'Page with auto-focus text field',
                      value: SheetPageWithTextField.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'Page with custom top bar',
                      value: SheetPageWithCustomTopBar.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'Page with no title and no top bar',
                      value: SheetPageWithNoPageTitleNoTopBar.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'Page with dynamic properties',
                      value: SheetPageWithDynamicPageProperties.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'NonScrollingWoltModalSheetPage example',
                      value: SheetPageWithNonScrollingLayout.pageId,
                      isSelected: false,
                    ),
                    WoltSelectionListItemData(
                      title: 'All the pages in one flow',
                      value: null,
                      isSelected: false,
                    ),
                  ],
                ),
                onSelectionUpdateInSingleSelectionList: (selectedItemData) {
                  final pathName = selectedItemData.value;
                  late SliverWoltModalSheetPage destinationPage;
                  switch (pathName) {
                    case ModalPageName.forcedMaxHeight:
                      destinationPage =
                          SheetPageWithForcedMaxHeight.build(context, Theme.of(context).brightness);
                      break;
                    case ModalPageName.heroImage:
                      destinationPage = SheetPageWithHeroImage.build(context);
                      break;
                    case ModalPageName.lazyLoadingList:
                      destinationPage = SheetPageWithLazyList.build(context);
                      break;
                    case ModalPageName.textField:
                      destinationPage = SheetPageWithTextField.build(context);
                      break;
                    case ModalPageName.noTitleNoTopBar:
                      destinationPage = SheetPageWithNoPageTitleNoTopBar.build(context);
                      break;
                    case ModalPageName.customTopBar:
                      destinationPage = SheetPageWithCustomTopBar.build(context);
                      break;
                    case ModalPageName.dynamicPageProperties:
                      destinationPage = SheetPageWithDynamicPageProperties.build(context);
                      break;
                    case ModalPageName.flexibleLayout:
                      destinationPage = SheetPageWithNonScrollingLayout.build(context);
                      break;
                    case null:
                      WoltModalSheet.of(context).addOrReplacePages(allPagesAfterRootPage);
                      return;
                  }
                  WoltModalSheet.of(context).addOrReplacePage(destinationPage);
                  isButtonEnabledNotifier.value = selectedItemData.isSelected;
                },
              ),
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.arrow_forward_ios),
                title: const Text('All the pages in one flow'),
                subtitle: const Text(
                  'Pressing this tile will append the page list and show the next page',
                ),
                onTap: () {
                  WoltModalSheet.of(context).pushPages(allPagesAfterRootPage);
                  isButtonEnabledNotifier.value = true;
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
