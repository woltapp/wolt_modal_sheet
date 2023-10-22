import 'package:flutter/material.dart';
import 'package:playground/home/pages/root_sheet_page.dart';
import 'package:playground/home/pages/sheet_page_with_custom_top_bar.dart';
import 'package:playground/home/pages/sheet_page_with_dynamic_page_properties.dart';
import 'package:playground/home/pages/sheet_page_with_forced_max_height.dart';
import 'package:playground/home/pages/sheet_page_with_hero_image.dart';
import 'package:playground/home/pages/sheet_page_with_lazy_list.dart';
import 'package:playground/home/pages/sheet_page_with_no_page_title_and_no_top_bar.dart';
import 'package:playground/home/pages/sheet_page_with_text_field.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum MultiPagePathName {
  forcedMaxHeight(pageCount: 2, queryParamName: "forcedMaxHeight"),
  heroImage(pageCount: 2, queryParamName: "heroImage"),
  lazyLoadingList(pageCount: 2, queryParamName: "lazyList"),
  textField(pageCount: 2, queryParamName: "textField"),
  noTitleNoTopBar(pageCount: 2, queryParamName: "noTitleNoTopBar"),
  customTopBar(pageCount: 2, queryParamName: "customTopBar"),
  dynamicPageProperties(pageCount: 2, queryParamName: "dynamicPageProperties"),
  allPagesPath(pageCount: 6, queryParamName: "all");

  static const defaultPath = MultiPagePathName.allPagesPath;

  final int pageCount;
  final String queryParamName;

  const MultiPagePathName(
      {required this.pageCount, required this.queryParamName});

  WoltModalSheetPageListBuilder pageListBuilder({
    required VoidCallback goToNextPage,
    required VoidCallback goToPreviousPage,
    required void Function(BuildContext) close,
    required void Function(MultiPagePathName pathName) onMultiPagePathSelected,
  }) {
    WoltModalSheetPage root(BuildContext context) => RootSheetPage.build(
          context,
          onSabPressed: goToNextPage,
          onPathSelectedFromList: onMultiPagePathSelected,
          onClosed: () => close(context),
        );
    WoltModalSheetPage forcedMaxHeight(BuildContext context,
            {bool isLastPage = true}) =>
        SheetPageWithForcedMaxHeight.build(
          brightness: Theme.of(context).brightness,
          onSabPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage heroImage(BuildContext context,
            {bool isLastPage = true}) =>
        SheetPageWithHeroImage.build(
          onSabPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage lazyList(BuildContext context,
            {bool isLastPage = true}) =>
        SheetPageWithLazyList.build(
          onSabPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage noTitleNoTopBar(BuildContext context,
            {bool isLastPage = true}) =>
        SheetPageWithNoPageTitleNoTopBar.build(
          onSabPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage customTopBar(BuildContext context,
            {bool isLastPage = true}) =>
        SheetPageWithCustomTopBar.build(
          onSabPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage dynamicPageProperties(BuildContext context,
            {bool isLastPage = true}) =>
        SheetPageWithDynamicPageProperties.build(
          onSabPressed: () => isLastPage ? close(context) : goToNextPage(),
          onClosed: () => close(context),
          onBackPressed: goToPreviousPage,
          context: context,
          isLastPage: isLastPage,
        );
    WoltModalSheetPage textField(BuildContext context,
            {bool isLastPage = true}) =>
        SheetPageWithTextField.build(
          onSabPressed: () => isLastPage ? close(context) : goToNextPage(),
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
      case MultiPagePathName.noTitleNoTopBar:
        return (context) => [root(context), noTitleNoTopBar(context)];
      case MultiPagePathName.customTopBar:
        return (context) => [root(context), customTopBar(context)];
      case MultiPagePathName.dynamicPageProperties:
        return (context) => [root(context), dynamicPageProperties(context)];
      case MultiPagePathName.allPagesPath:
        return (context) => [
              root(context),
              heroImage(context, isLastPage: false),
              lazyList(context, isLastPage: false),
              textField(context, isLastPage: false),
              noTitleNoTopBar(context, isLastPage: false),
              customTopBar(context, isLastPage: false),
              dynamicPageProperties(context, isLastPage: false),
              forcedMaxHeight(context, isLastPage: true),
            ];
    }
  }

  static bool isValidQueryParam(String path, int pageIndex) {
    return MultiPagePathName.values.any(
      (element) =>
          element.queryParamName == path &&
          element.pageCount > pageIndex &&
          pageIndex >= 0,
    );
  }
}
