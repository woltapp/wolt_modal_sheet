import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_hero_image.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';

/// The main content widget within the scrollable modal sheet.
///
/// This widget is responsible for displaying the main content of the scrollable modal sheet.
/// It handles the scroll behavior, page layout, and interactions within the modal sheet.
///
/// [currentScrollPosition] is updated as the user scrolls through the content.
///
/// [topBarHeight] represents the height of the top bar displayed in the modal sheet.
///
/// [pageTitleKey] represents the global key for the page title widget, if present.
///
/// [woltModalType] represents the type of the scrollable modal.
///
/// [page] represents the [WoltModalSheetPage] containing the configuration for the modal sheet.
class WoltModalSheetMainContent extends StatefulWidget {
  final ValueNotifier<double> currentScrollPosition;
  final double topBarHeight;
  final GlobalKey pageTitleKey;
  final WoltModalSheetPage page;
  final WoltModalType woltModalType;

  const WoltModalSheetMainContent({
    required this.currentScrollPosition,
    required this.topBarHeight,
    required this.pageTitleKey,
    required this.page,
    required this.woltModalType,
    Key? key,
  }) : super(key: key);

  @override
  State<WoltModalSheetMainContent> createState() => _WoltModalSheetMainContentState();
}

class _WoltModalSheetMainContentState extends State<WoltModalSheetMainContent> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.page.scrollController ??
        ScrollController(initialScrollOffset: widget.currentScrollPosition.value);
  }

  static const _defaultTopBarHeight = 56.0;

  EdgeInsetsDirectional get _mainContentPadding {
    final mainContentPadding = widget.page.mainContentPadding;
    if (mainContentPadding != null) {
      return mainContentPadding;
    }
    switch (widget.woltModalType) {
      case WoltModalType.bottomSheet:
        return const EdgeInsetsDirectional.all(16);
      case WoltModalType.dialog:
        return const EdgeInsetsDirectional.all(32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heroImageHeight = widget.page.heroImageHeight ?? 0;
    final scrollView = CustomScrollView(
      shrinkWrap: true,
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsetsDirectional.only(
            top: widget.topBarHeight == 0 && heroImageHeight == 0 ? _defaultTopBarHeight : 0,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  final heroImage = widget.page.heroImage;
                  return heroImage != null && heroImageHeight != 0
                      ? WoltModalSheetHeroImage(
                          topBarHeight: widget.topBarHeight,
                          heroImage: heroImage,
                          heroImageHeight: heroImageHeight,
                        )
                      : SizedBox(height: widget.topBarHeight);
                } else {
                  final pageTitle = widget.page.pageTitle;
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: _mainContentPadding.start,
                      end: _mainContentPadding.end,
                    ),
                    child: KeyedSubtree(
                      key: widget.pageTitleKey,
                      child: pageTitle ?? const SizedBox.shrink(),
                    ),
                  );
                }
              },
              childCount: 2,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsDirectional.only(
            bottom: _mainContentPadding.bottom,
            start: _mainContentPadding.start,
            end: _mainContentPadding.end,
          ),
          sliver: widget.page.singleChildContent != null
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => widget.page.singleChildContent,
                    childCount: 1,
                  ),
                )
              : widget.page.sliverList,
        ),
        if (widget.page.forceMaxHeight)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox.shrink(),
          ),
      ],
    );
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          widget.currentScrollPosition.value = scrollNotification.metrics.pixels;
        }
        return false;
      },
      child: scrollView,
    );
  }
}
