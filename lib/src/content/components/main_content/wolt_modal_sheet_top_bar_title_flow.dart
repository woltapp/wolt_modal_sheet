import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_layout_transformation_utils.dart';

/// This class represents the top bar title behavior within a modal sheet page.
///
/// It leverages properties like [WoltModalSheetTopBarTitleFlow.topBarHeight],
/// [WoltModalSheetTopBarTitleFlow.currentScrollPositionListenable],
/// [WoltModalSheetTopBarTitleFlow.titleKey], and [WoltModalSheetPage.heroImageHeight]
/// (from [WoltModalSheetTopBarTitleFlow.page]) to provide a smooth transition and motion
/// animation for the top bar title as the user scrolls.
class WoltModalSheetTopBarTitleFlow extends StatelessWidget {
  final double topBarHeight;
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final WoltModalSheetPage page;
  final Widget topBarTitle;

  const WoltModalSheetTopBarTitleFlow({
    required this.page,
    required this.topBarHeight,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.topBarTitle,
    Key? key,
  }) : super(key: key);

  static const _topBarTitleTranslationYAmount = 8.0;

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _TopBarTitleFlowDelegate(
        topBarHeight: topBarHeight,
        heroImageHeight: page.heroImageHeight ?? 0,
        currentScrollPositionListenable: currentScrollPositionListenable,
        titleKey: titleKey,
        pageTitlePaddingTop: page.pageTitlePaddingTop,
        buildContext: context,
      ),
      children: [Center(child: topBarTitle)],
    );
  }
}

class _TopBarTitleFlowDelegate extends FlowDelegate {
  final double topBarHeight;
  final double heroImageHeight;
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final double pageTitlePaddingTop;
  final BuildContext buildContext;

  _TopBarTitleFlowDelegate({
    required this.topBarHeight,
    required this.heroImageHeight,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.pageTitlePaddingTop,
    required this.buildContext,
  }) : super(repaint: currentScrollPositionListenable);

  double get currentScrollPosition => currentScrollPositionListenable.value;

  @override
  void paintChildren(FlowPaintingContext context) {
    double pageTitleHeight = titleKey.currentContext!.size!.height;
    const topBarTitleTranslationYStart =
        -1 * WoltModalSheetTopBarTitleFlow._topBarTitleTranslationYAmount;
    const topBarTitleTranslationYAmount =
        WoltModalSheetTopBarTitleFlow._topBarTitleTranslationYAmount;
    const topBarTitleTranslationYEnd = topBarTitleTranslationYStart + topBarTitleTranslationYAmount;

    pageTitleHeight = pageTitleHeight == 0 ? pageTitlePaddingTop : pageTitleHeight;

    final topBarTitleTranslationYAndOpacityStartPoint = heroImageHeight == 0
        ? pageTitlePaddingTop
        : heroImageHeight - topBarHeight + pageTitlePaddingTop;

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
      0,
      transform: Matrix4.translationValues(0.0, topBarTitleTranslationY, 0.0),
      opacity: topBarTitleOpacity,
    );
  }

  @override
  bool shouldRepaint(covariant _TopBarTitleFlowDelegate oldDelegate) {
    return heroImageHeight != oldDelegate.heroImageHeight ||
        titleKey != oldDelegate.titleKey ||
        currentScrollPosition != oldDelegate.currentScrollPosition ||
        pageTitlePaddingTop != oldDelegate.pageTitlePaddingTop ||
        topBarHeight != oldDelegate.topBarHeight;
  }
}
