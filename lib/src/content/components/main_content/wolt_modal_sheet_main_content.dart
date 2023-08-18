import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_hero_image.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// The main content widget within the scrollable modal sheet.
///
/// This widget is responsible for displaying the main content of the scrollable modal sheet.
/// It handles the scroll behavior, page layout, and interactions within the modal sheet.
class WoltModalSheetMainContent extends StatefulWidget {
  final ValueNotifier<double> currentScrollPosition;
  final GlobalKey pageTitleKey;
  final WoltModalSheetPage page;
  final WoltModalType woltModalType;

  const WoltModalSheetMainContent({
    required this.currentScrollPosition,
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

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final page = widget.page;
    final heroImageHeight = page.heroImage == null
        ? 0.0
        : (widget.page.heroImageHeight ??
            themeData?.heroImageHeight ??
            defaultThemeData.heroImageHeight);
    final pageHasTopBarLayer =
        page.hasTopBarLayer ?? themeData?.hasTopBarLayer ?? defaultThemeData.hasTopBarLayer;
    final navBarHeight = page.navBarHeight ??
        themeData?.navBarHeight ??
        defaultThemeData.navBarHeight;
    final topBarHeight =
        pageHasTopBarLayer || page.leadingNavBarWidget != null || page.trailingNavBarWidget != null
            ? navBarHeight
            : 0.0;
    final singleChildContent = widget.page.singleChildContent;
    final sliverList = widget.page.sliverList;
    final scrollView = CustomScrollView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                final heroImage = widget.page.heroImage;
                return heroImage != null
                    ? WoltModalSheetHeroImage(
                        topBarHeight: topBarHeight,
                        heroImage: heroImage,
                        heroImageHeight: heroImageHeight,
                      )
                    : SizedBox(height: topBarHeight);
              } else {
                final pageTitle = widget.page.pageTitle;
                return KeyedSubtree(
                  key: widget.pageTitleKey,
                  child: pageTitle ?? const SizedBox.shrink(),
                );
              }
            },
            childCount: 2,
          ),
        ),
        (singleChildContent != null
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => singleChildContent,
                      childCount: 1,
                    ),
                  )
                : sliverList) ??
            const SizedBox.shrink(),
        if (widget.page.forceMaxHeight)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox.shrink(),
          ),
      ],
    );
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        final isVerticalScrollNotification = scrollNotification is ScrollUpdateNotification &&
            scrollNotification.metrics.axis == Axis.vertical;
        if (isVerticalScrollNotification) {
          widget.currentScrollPosition.value = scrollNotification.metrics.pixels;
        }
        return false;
      },
      child: scrollView,
    );
  }
}
