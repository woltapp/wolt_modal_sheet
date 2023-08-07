import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_layout_transformation_utils.dart';

/// `WoltModalSheetTopBarFlow` controls the top bar behavior within the modal sheet page
/// provided by the [WoltModalSheetPage] when `isTopBarLayerAlwaysVisible` is set to true.
///
/// It is responsible for the positioning, translation, and opacity of the top bar as the user
/// scrolls through the content. Utilizing the [Flow] widget, it listens to the current scroll
/// position and performs transformations to achieve the desired effects on the top bar, such as
/// fading in/out and translating vertically.
class WoltModalSheetTopBarFlow extends StatelessWidget {
  final double topBarHeight;
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final double topBarTranslationYAmountInPx;
  final WoltModalSheetPage page;
  final Widget topBar;

  const WoltModalSheetTopBarFlow({
    required this.page,
    required this.topBarHeight,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.topBarTranslationYAmountInPx,
    required this.topBar,
    Key? key,
  }) : super(key: key);

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
      children: [topBar],
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

    pageTitleHeight = pageTitleHeight == 0 ? pageTitlePaddingTop : pageTitleHeight;

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
