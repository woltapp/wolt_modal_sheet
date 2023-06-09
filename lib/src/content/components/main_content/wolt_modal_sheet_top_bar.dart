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
  static const _elevation = 4.0;

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _TopBarFlowDelegate(
        topBarHeight: topBarHeight,
        heroImageHeight: page.heroImageHeight ?? 0,
        currentScrollPositionListenable: currentScrollPositionListenable,
        titleKey: titleKey,
        pageTitleTopPadding: 12,
        topBarTranslationYAmountInPx: topBarTranslationYAmountInPx,
        buildContext: context,
      ),
      children: [
        Material(
          elevation: _elevation,
          child: Container(height: topBarHeight - _elevation, color: page.backgroundColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 28.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: page.topBarTitle ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _TopBarFlowDelegate extends FlowDelegate {
  final double topBarHeight;
  final double heroImageHeight;
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final double pageTitleTopPadding;
  final double topBarTranslationYAmountInPx;
  final BuildContext buildContext;

  _TopBarFlowDelegate({
    required this.topBarHeight,
    required this.heroImageHeight,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.pageTitleTopPadding,
    required this.topBarTranslationYAmountInPx,
    required this.buildContext,
  }) : super(repaint: currentScrollPositionListenable);

  @override
  void paintChildren(FlowPaintingContext context) {
    final currentScrollPosition = currentScrollPositionListenable.value;
    double pageTitleHeight = titleKey.currentContext!.size!.height;

    const topBarTranslationYStart = 0.0;
    final topBarTranslationYEnd = topBarTranslationYAmountInPx;
    final totalTopBarTranslationYAmount = topBarTranslationYEnd - topBarTranslationYStart;
    final topBarTranslationYAndOpacityStartPoint =
        heroImageHeight == 0 ? 0 : heroImageHeight - totalTopBarTranslationYAmount - topBarHeight;

    const topBarTitleTranslationYStart = 0.0;
    const topBarTitleTranslationYEnd = 8.0;
    const totalTopBarTitleTranslationYAmount =
        topBarTitleTranslationYEnd - topBarTitleTranslationYStart;

    pageTitleHeight = pageTitleHeight == 0 ? 12.0 : pageTitleHeight;

    final topBarTitleTranslationYAndOpacityStartPoint = heroImageHeight == 0
        ? totalTopBarTranslationYAmount + pageTitleTopPadding
        : heroImageHeight - topBarHeight + pageTitleTopPadding;

    /// Top bar translation Y
    final topBarTranslationY = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx:
          totalTopBarTranslationYAmount + totalTopBarTitleTranslationYAmount + pageTitleHeight,
      progressInRangeInPx: currentScrollPosition - topBarTranslationYAndOpacityStartPoint,
      startValue: topBarTranslationYStart,
      endValue: topBarTranslationYEnd,
    );

    /// Top bar opacity
    final topBarOpacity = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: totalTopBarTranslationYAmount + pageTitleTopPadding,
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
      rangeInPx: totalTopBarTitleTranslationYAmount + pageTitleHeight - pageTitleTopPadding,
      progressInRangeInPx: currentScrollPosition - topBarTitleTranslationYAndOpacityStartPoint,
      startValue: topBarTitleTranslationYStart,
      endValue: topBarTitleTranslationYEnd,
    );

    /// Top Bar Title Opacity
    final topBarTitleOpacity = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: pageTitleHeight * 0.75,
      progressInRangeInPx: currentScrollPosition - topBarTitleTranslationYAndOpacityStartPoint,
      startValue: 0.0,
      endValue: 1.0,
    );

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
        currentScrollPositionListenable != oldDelegate.currentScrollPositionListenable ||
        pageTitleTopPadding != oldDelegate.pageTitleTopPadding ||
        topBarTranslationYAmountInPx != oldDelegate.topBarTranslationYAmountInPx ||
        topBarHeight != oldDelegate.topBarHeight;
  }
}
