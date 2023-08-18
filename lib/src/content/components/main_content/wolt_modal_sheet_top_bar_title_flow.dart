import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_layout_transformation_utils.dart';

/// This class represents the top bar title behavior within a modal sheet page.
class WoltModalSheetTopBarTitleFlow extends StatelessWidget {
  final ValueListenable<double> currentScrollPositionListenable;
  final GlobalKey titleKey;
  final WoltModalSheetPage page;
  final Widget topBarTitle;

  const WoltModalSheetTopBarTitleFlow({
    required this.page,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.topBarTitle,
    Key? key,
  }) : super(key: key);

  static const _topBarTitleTranslationYAmount = 8.0;

  @override
  Widget build(BuildContext context) {
    final topBarHeight = page.navigationBarHeight;
    final heroImageHeight = page.heroImage == null ? 0.0 : (page.heroImageHeight ?? 0.0);

    return Flow(
      delegate: _TopBarTitleFlowDelegate(
        topBarHeight: topBarHeight,
        heroImageHeight: heroImageHeight,
        currentScrollPositionListenable: currentScrollPositionListenable,
        titleKey: titleKey,
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
  final BuildContext buildContext;

  _TopBarTitleFlowDelegate({
    required this.topBarHeight,
    required this.heroImageHeight,
    required this.currentScrollPositionListenable,
    required this.titleKey,
    required this.buildContext,
  }) : super(repaint: currentScrollPositionListenable);

  double get currentScrollPosition => currentScrollPositionListenable.value;

  @override
  void paintChildren(FlowPaintingContext context) {
    final double pageTitleHeight = titleKey.currentContext!.size!.height;
    const topBarTitleTranslationYStart =
        -1 * WoltModalSheetTopBarTitleFlow._topBarTitleTranslationYAmount;
    const topBarTitleTranslationYAmount =
        WoltModalSheetTopBarTitleFlow._topBarTitleTranslationYAmount;
    const topBarTitleTranslationYEnd = topBarTitleTranslationYStart + topBarTitleTranslationYAmount;

    final topBarTitleTranslationYAndOpacityStartPoint = heroImageHeight == 0
        ? 8
        : heroImageHeight - topBarHeight;

    /// Top Bar Title translation Y
    final topBarTitleTranslationY = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: pageTitleHeight,
      progressInRangeInPx: currentScrollPosition - topBarTitleTranslationYAndOpacityStartPoint,
      startValue: topBarTitleTranslationYStart,
      endValue: topBarTitleTranslationYEnd,
    );

    /// Top Bar Title Opacity
    final topBarTitleOpacity = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: pageTitleHeight / 2,
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
        topBarHeight != oldDelegate.topBarHeight;
  }
}
