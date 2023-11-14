import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_layout_transformation_utils.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// `WoltModalSheetTopBarFlow` controls the top bar behavior within the modal sheet page
/// provided by the [WoltModalSheetPage] when `isTopBarLayerAlwaysVisible` is set to true.
///
/// It is responsible for the positioning, translation, and opacity of the top bar as the user
/// scrolls through the content. Utilizing the [Flow] widget, it listens to the current scroll
/// position and performs transformations to achieve the desired effects on the top bar, such as
/// fading in/out and translating vertically.
class WoltModalSheetTopBarFlow extends StatelessWidget {
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final double topBarTranslationYAmountInPx;
  final SliverWoltModalSheetPage page;

  const WoltModalSheetTopBarFlow({
    required this.page,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.topBarTranslationYAmountInPx,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final topBarHeight = page.navBarHeight ??
        themeData?.navBarHeight ??
        defaultThemeData.navBarHeight;
    final heroImageHeight = page.heroImage == null
        ? 0.0
        : (page.heroImageHeight ??
            themeData?.heroImageHeight ??
            defaultThemeData.heroImageHeight);

    return Flow(
      delegate: _TopBarFlowDelegate(
        topBarHeight: topBarHeight,
        heroImageHeight: heroImageHeight,
        currentScrollPositionListenable: currentScrollPositionListenable,
        titleKey: titleKey,
        topBarTranslationYAmountInPx: topBarTranslationYAmountInPx,
        buildContext: context,
      ),
      children: [WoltModalSheetTopBar(page: page)],
    );
  }
}

class _TopBarFlowDelegate extends FlowDelegate {
  final double topBarHeight;
  final double heroImageHeight;
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final double topBarTranslationYAmountInPx;
  final BuildContext buildContext;

  _TopBarFlowDelegate({
    required this.topBarHeight,
    required this.heroImageHeight,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.topBarTranslationYAmountInPx,
    required this.buildContext,
  }) : super(repaint: currentScrollPositionListenable);

  double get currentScrollPosition => currentScrollPositionListenable.value;

  @override
  void paintChildren(FlowPaintingContext context) {
    final pageTitleHeight = titleKey.currentContext!.size!.height;

    final topBarTranslationYStart = -1 * topBarTranslationYAmountInPx;
    const topBarTranslationYEnd = 0.0;
    final topBarTranslationYAndOpacityStartPoint =
        heroImageHeight == 0 ? 0 : heroImageHeight - topBarHeight - 8;

    /// Top bar translation Y
    final topBarTranslationY =
        WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: 8 + pageTitleHeight,
      progressInRangeInPx:
          currentScrollPosition - topBarTranslationYAndOpacityStartPoint,
      startValue: topBarTranslationYStart,
      endValue: topBarTranslationYEnd,
    );

    /// Top bar opacity
    final topBarOpacity =
        WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: 8,
      progressInRangeInPx:
          currentScrollPosition - topBarTranslationYAndOpacityStartPoint,
      startValue: 0.0,
      endValue: 1.0,
    );

    /// Paint Top Bar
    context.paintChild(
      0,
      transform: Matrix4.translationValues(0.0, topBarTranslationY, 0.0),
      opacity: topBarOpacity,
    );
  }

  @override
  bool shouldRepaint(covariant _TopBarFlowDelegate oldDelegate) {
    return heroImageHeight != oldDelegate.heroImageHeight ||
        titleKey != oldDelegate.titleKey ||
        currentScrollPosition != oldDelegate.currentScrollPosition ||
        topBarTranslationYAmountInPx !=
            oldDelegate.topBarTranslationYAmountInPx ||
        topBarHeight != oldDelegate.topBarHeight;
  }
}
