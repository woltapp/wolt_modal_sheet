import 'package:flutter/cupertino.dart';
import 'package:playground_navigator2/modal/pages/root_sheet_page.dart';
import 'package:playground_navigator2/modal/pages/sheet_page_with_forced_max_height.dart';
import 'package:playground_navigator2/modal/pages/sheet_page_with_hero_image.dart';
import 'package:playground_navigator2/modal/pages/sheet_page_with_lazy_list.dart';
import 'package:playground_navigator2/modal/pages/sheet_page_with_text_field.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum MultiPagePathName {
  forcedMaxHeight(pageCount: 2, queryParamName: "forcedMaxHeight"),
  heroImage(pageCount: 2, queryParamName: "heroImage"),
  lazyLoadingList(pageCount: 2, queryParamName: "lazyList"),
  textField(pageCount: 2, queryParamName: "textField"),
  allPagesPath(pageCount: 5, queryParamName: "all");

  static const defaultPath = MultiPagePathName.allPagesPath;

  final int pageCount;
  final String queryParamName;

  const MultiPagePathName({required this.pageCount, required this.queryParamName});

  WoltModalSheetPageListBuilder get pageListBuilder {
    WoltModalSheetPage root(BuildContext context) => RootSheetPage.build(context);

    WoltModalSheetPage forcedMaxHeight(
      BuildContext context, {
      bool isLastPage = true,
      required int currentPage,
    }) =>
        SheetPageWithForcedMaxHeight.build(
          context,
          isLastPage: isLastPage,
          currentPage: currentPage,
        );

    WoltModalSheetPage heroImage(
      BuildContext context, {
      bool isLastPage = true,
      required int currentPage,
    }) =>
        SheetPageWithHeroImage.build(
          context,
          isLastPage: isLastPage,
          currentPage: currentPage,
        );

    WoltModalSheetPage lazyList(
      BuildContext context, {
      bool isLastPage = true,
      required int currentPage,
    }) =>
        SheetPageWithLazyList.build(
          context,
          isLastPage: isLastPage,
          currentPage: currentPage,
        );

    WoltModalSheetPage textField(
      BuildContext context, {
      bool isLastPage = true,
      required int currentPage,
    }) =>
        SheetPageWithTextField.build(
          context,
          isLastPage: isLastPage,
          currentPage: currentPage,
        );

    switch (this) {
      case MultiPagePathName.forcedMaxHeight:
        return (context) => [root(context), forcedMaxHeight(context, currentPage: 1)];
      case MultiPagePathName.heroImage:
        return (context) => [root(context), heroImage(context, currentPage: 1)];
      case MultiPagePathName.lazyLoadingList:
        return (context) => [root(context), lazyList(context, currentPage: 1)];
      case MultiPagePathName.textField:
        return (context) => [root(context), textField(context, currentPage: 1)];
      case MultiPagePathName.allPagesPath:
        return (context) => [
              root(context),
              heroImage(context, isLastPage: false, currentPage: 1),
              lazyList(context, isLastPage: false, currentPage: 2),
              textField(context, isLastPage: false, currentPage: 3),
              forcedMaxHeight(context, isLastPage: true, currentPage: 4),
            ];
    }
  }

  static bool isValidQueryParam(String path, int pageIndex) {
    return MultiPagePathName.values.any(
      (element) =>
          element.queryParamName == path && element.pageCount > pageIndex && pageIndex >= 0,
    );
  }
}
