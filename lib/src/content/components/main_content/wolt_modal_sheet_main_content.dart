import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_hero_image.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// The main content widget within the scrollable modal sheet.
///
/// This widget is responsible for displaying the main content of the scrollable modal sheet.
/// It handles the scroll behavior, page layout, and interactions within the modal sheet.
class WoltModalSheetMainContent extends StatelessWidget {
  final ScrollController? scrollController;
  final GlobalKey pageTitleKey;
  final SliverWoltModalSheetPage page;
  final WoltModalType woltModalType;

  const WoltModalSheetMainContent({
    required this.scrollController,
    required this.pageTitleKey,
    required this.page,
    required this.woltModalType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final heroImageHeight = page.heroImage == null
        ? 0.0
        : (page.heroImageHeight ??
            themeData?.heroImageHeight ??
            defaultThemeData.heroImageHeight);
    final pageHasTopBarLayer = page.hasTopBarLayer ??
        themeData?.hasTopBarLayer ??
        defaultThemeData.hasTopBarLayer;
    final isTopBarLayerAlwaysVisible =
        pageHasTopBarLayer && page.isTopBarLayerAlwaysVisible == true;
    final navBarHeight = page.navBarHeight ??
        themeData?.navBarHeight ??
        defaultThemeData.navBarHeight;
    final topBarHeight = pageHasTopBarLayer ||
            page.leadingNavBarWidget != null ||
            page.trailingNavBarWidget != null
        ? navBarHeight
        : 0.0;
    final isFlexiblePage = page is FlexibleWoltModalSheetPage;
    final scrollView = CustomScrollView(
      shrinkWrap: true,
      physics: themeData?.mainContentScrollPhysics ??
          defaultThemeData.mainContentScrollPhysics,
      controller: scrollController,
      slivers: [
        if (!isFlexiblePage)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  final heroImage = page.heroImage;
                  return heroImage != null
                      ? WoltModalSheetHeroImage(
                          topBarHeight: topBarHeight,
                          heroImage: heroImage,
                          heroImageHeight: heroImageHeight,
                        )
                      // If top bar layer is always visible, the padding is explicitly added to the
                      // scroll view since top bar will not be integrated to scroll view at all.
                      // Otherwise, we implicitly create a spacing as a part of the scroll view.
                      : SizedBox(
                          height:
                              isTopBarLayerAlwaysVisible ? 0 : topBarHeight);
                } else {
                  final pageTitle = page.pageTitle;
                  return KeyedSubtree(
                    key: pageTitleKey,
                    child: pageTitle ?? const SizedBox.shrink(),
                  );
                }
              },
              childCount: 2,
            ),
          ),
        ...page.mainContentSlivers,
        if (page.forceMaxHeight && !isFlexiblePage)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox.shrink(),
          ),
      ],
    );
    return Padding(
      // The scroll view should be padded by the height of the top bar layer if it's always
      // visible. Otherwise, over scroll effect will not be visible due to the top bar layer.
      padding:
          EdgeInsets.only(top: isTopBarLayerAlwaysVisible ? topBarHeight : 0),
      child: scrollView,
    );
  }
}
