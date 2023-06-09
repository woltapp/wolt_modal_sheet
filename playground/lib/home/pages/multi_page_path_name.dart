import 'package:playground/home/pages/root_sheet_page.dart';
import 'package:playground/home/pages/sheet_page_with_forced_max_height.dart';
import 'package:playground/home/pages/sheet_page_with_hero_image.dart';
import 'package:playground/home/pages/sheet_page_with_lazy_list.dart';
import 'package:playground/home/pages/sheet_page_with_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum MultiPagePathName {
  forcedMaxHeight,
  heroImage,
  lazyLoadingList,
  textField,
  allPagesPath;

  List<WoltModalSheetPage> Function(BuildContext context) pageListBuilder({
    required VoidCallback goToNextPage,
    required VoidCallback goToPreviousPage,
    required void Function(BuildContext) close,
    required void Function(MultiPagePathName pathName) onMultiPagePathSelected,
  }) {
    WoltModalSheetPage root(BuildContext context) => RootSheetPage.build(
          context,
          onFooterPressed: goToNextPage,
          onPathSelectedFromList: onMultiPagePathSelected,
          onClosed: () => close(context),
        );
    WoltModalSheetPage forcedMaxHeight(BuildContext context, {bool isLastPage = true}) =>
        SheetPageWithForcedMaxHeight.build(
          onFooterPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage heroImage(BuildContext context, {bool isLastPage = true}) =>
        SheetPageWithHeroImage.build(
          onFooterPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage lazyList(BuildContext context, {bool isLastPage = true}) =>
        SheetPageWithLazyList.build(
          onFooterPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage textField(BuildContext context) => SheetPageWithTextField.build(
          onFooterPressed: () => close(context),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: true,
        );
    switch (this) {
      case MultiPagePathName.forcedMaxHeight:
        return (context) => [root(context), forcedMaxHeight(context)];
      case MultiPagePathName.heroImage:
        return (context) => [root(context), heroImage(context)];
      case MultiPagePathName.lazyLoadingList:
        return (context) => [root(context), lazyList(context)];
      case MultiPagePathName.textField:
        return (context) => [root(context), textField(context)];
      case MultiPagePathName.allPagesPath:
        return (context) => [
              root(context),
              heroImage(context, isLastPage: false),
              lazyList(context, isLastPage: false),
              forcedMaxHeight(context, isLastPage: false),
              textField(context),
            ];
    }
  }
}
