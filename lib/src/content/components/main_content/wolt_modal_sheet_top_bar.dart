import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_layout_transformation_utils.dart';

/// The top bar widget within the scrollable modal sheet.
///
/// This widget represents the top bar displayed at the top of the modal sheet when scrolled.
/// It includes the title and background color of the top bar, and handles the
/// scrolling and opacity effects as the user scrolls through the content.
///
/// [topBarHeight] represents the height of the top bar.
///
/// [currentScrollPositionListenable] is a `ValueListenable` that holds the current
/// scroll position of the modal sheet. It is used to update the scrolling and opacity effects.
///
/// [titleKey] is a global key for the title widget.
///
/// [topBarTranslationYAmountInPx] represents the translation amount of the top bar in pixels.
///
/// [page] represents the [WoltModalSheetPage] containing the configuration for the modal sheet.
class WoltModalSheetTopBar extends StatelessWidget {
  final double topBarHeight;
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final double topBarTranslationYAmountInPx;
  final WoltModalSheetPage page;

  const WoltModalSheetTopBar({
    required this.page,
    required this.topBarHeight,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.topBarTranslationYAmountInPx,
    Key? key,
  }) : super(key: key);

  // TODO: get this information from ThemeData extensions
  static const _elevation = 1.0;
  static const _topBarTitleTranslationYAmount = 8.0;

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _TopBarFlowDelegate(
        topBarHeight: topBarHeight,
        heroImageHeight: page.heroImageHeight ?? 0,
        currentScrollPositionListenable: currentScrollPositionListenable,
        titleKey: titleKey,
        pageTitlePaddingTop: page.pageTitlePaddingTop,
        topBarTranslationYAmountInPx: topBarTranslationYAmountInPx,
        buildContext: context,
      ),
      children: [
        Material(
          elevation: _elevation,
          child: Container(height: topBarHeight - _elevation, color: page.backgroundColor),
        ),
        Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            page.topBarTitle ?? const SizedBox.shrink(),
            const SizedBox(height: _topBarTitleTranslationYAmount),
          ],
        )),
      ],
    );
  }
}

class _TopBarFlowDelegate extends FlowDelegate {
  final double topBarHeight;
  final double heroImageHeight;
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final double pageTitlePaddingTop;
  final double topBarTranslationYAmountInPx;
  final BuildContext buildContext;

  _TopBarFlowDelegate({
    required this.topBarHeight,
    required this.heroImageHeight,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.pageTitlePaddingTop,
    required this.topBarTranslationYAmountInPx,
    required this.buildContext,
  }) : super(repaint: currentScrollPositionListenable);

  double get currentScrollPosition => currentScrollPositionListenable.value;

  @override
  void paintChildren(FlowPaintingContext context) {
    double pageTitleHeight = titleKey.currentContext!.size!.height;

    const topBarTranslationYStart = 0.0;
    final topBarTranslationYEnd = topBarTranslationYAmountInPx;
    final topBarTranslationYAndOpacityStartPoint =
    heroImageHeight == 0 ? 0 : heroImageHeight - topBarHeight;

    const topBarTitleTranslationYStart = 0.0;
    const topBarTitleTranslationYAmount = WoltModalSheetTopBar._topBarTitleTranslationYAmount;
    const topBarTitleTranslationYEnd =
        topBarTitleTranslationYStart + topBarTitleTranslationYAmount;

    pageTitleHeight = pageTitleHeight == 0 ? pageTitlePaddingTop : pageTitleHeight;

    final topBarTitleTranslationYAndOpacityStartPoint = heroImageHeight == 0
        ? pageTitlePaddingTop
        : heroImageHeight - topBarHeight + pageTitlePaddingTop;

    /// Top bar translation Y
    final topBarTranslationY = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: pageTitlePaddingTop + pageTitleHeight,
      progressInRangeInPx: currentScrollPosition - topBarTranslationYAndOpacityStartPoint,
      startValue: topBarTranslationYStart,
      endValue: topBarTranslationYEnd,
    );

    /// Top bar opacity
    final topBarOpacity = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: pageTitlePaddingTop,
      progressInRangeInPx: currentScrollPosition - topBarTranslationYAndOpacityStartPoint,
      startValue: 0.0,
      endValue: 1.0,
    );

    /// Paint Top Bar
    context.paintChild(
      0,
      transform: Matrix4.translationValues(0.0, topBarTranslationY, 0.0),
      opacity: topBarOpacity,
    );

    /// Top Bar Title translation Y
    final topBarTitleTranslationY = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: pageTitleHeight,
      progressInRangeInPx: currentScrollPosition - topBarTitleTranslationYAndOpacityStartPoint,
      startValue: topBarTitleTranslationYStart,
      endValue: topBarTitleTranslationYEnd,
    );

    /// Top Bar Title Opacity
    final topBarTitleOpacity = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: topBarHeight / 2,
      progressInRangeInPx: currentScrollPosition - topBarTitleTranslationYAndOpacityStartPoint,
      startValue: 0.0,
      endValue: 1.0,
    );

    /// Paint Top Bar Title
    context.paintChild(
      1,
      transform: Matrix4.translationValues(0.0, topBarTitleTranslationY, 0.0),
      opacity: topBarTitleOpacity,
    );
  }

  @override
  bool shouldRepaint(covariant _TopBarFlowDelegate oldDelegate) {
    return heroImageHeight != oldDelegate.heroImageHeight ||
        titleKey != oldDelegate.titleKey ||
        currentScrollPosition != oldDelegate.currentScrollPosition ||
        pageTitlePaddingTop != oldDelegate.pageTitlePaddingTop ||
        topBarTranslationYAmountInPx != oldDelegate.topBarTranslationYAmountInPx ||
        topBarHeight != oldDelegate.topBarHeight;
  }
}
