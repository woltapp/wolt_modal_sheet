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

    WoltModalSheetPage forcedMaxHeight(BuildContext context, {bool isLastPage = true}) =>
        SheetPageWithForcedMaxHeight.build(context, isLastPage: isLastPage);

    WoltModalSheetPage heroImage(BuildContext context, {bool isLastPage = true}) =>
        SheetPageWithHeroImage.build(context, isLastPage: isLastPage);

    WoltModalSheetPage lazyList(BuildContext context, {bool isLastPage = true}) =>
        SheetPageWithLazyList.build(context, isLastPage: isLastPage);

    WoltModalSheetPage textField(BuildContext context, {bool isLastPage = true}) =>
        SheetPageWithTextField.build(context, isLastPage: isLastPage);

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
              textField(context, isLastPage: false),
              forcedMaxHeight(context, isLastPage: true),
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
