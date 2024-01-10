import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/utils/soft_keyboard_closed_event.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_layout_transformation_utils.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// [WoltModalSheetTopBarTitleFlow] controls the top bar title behavior within the modal sheet page
/// provided by the [WoltModalSheetPage] when `isTopBarLayerAlwaysVisible` is set to false.
///
/// It is responsible for the positioning, translation, and opacity of the top bar title as the user
/// scrolls through the content. Utilizing the [Flow] widget, it listens to the current scroll
/// position and soft keyboard closing events, then, performs transformations to achieve the
/// desired  effects on the top bar title, such as fading in/out and translating vertically.
class WoltModalSheetTopBarTitleFlow extends StatelessWidget {
  final ScrollController scrollController;
  final GlobalKey titleKey;
  final SliverWoltModalSheetPage page;
  final Widget topBarTitle;
  final ValueListenable<SoftKeyboardClosedEvent> softKeyboardClosedListenable;

  const WoltModalSheetTopBarTitleFlow({
    required this.page,
    required this.scrollController,
    required this.titleKey,
    required this.topBarTitle,
    required this.softKeyboardClosedListenable,
    Key? key,
  }) : super(key: key);

  static const _topBarTitleTranslationYAmount = 8.0;

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
      delegate: _TopBarTitleFlowDelegate(
        topBarHeight: topBarHeight,
        heroImageHeight: heroImageHeight,
        scrollController: scrollController,
        titleKey: titleKey,
        softKeyboardClosedNotifier: softKeyboardClosedListenable,
      ),
      children: [Center(child: topBarTitle)],
    );
  }
}

class _TopBarTitleFlowDelegate extends FlowDelegate {
  final double topBarHeight;
  final double heroImageHeight;
  final ScrollController scrollController;
  final GlobalKey titleKey;
  final ValueListenable<SoftKeyboardClosedEvent> softKeyboardClosedNotifier;

  _TopBarTitleFlowDelegate({
    required this.topBarHeight,
    required this.heroImageHeight,
    required this.scrollController,
    required this.titleKey,
    required this.softKeyboardClosedNotifier,
  }) : super(
          repaint: Listenable.merge([
            scrollController,
            softKeyboardClosedNotifier,
          ]),
        );

  double get currentScrollPosition => scrollController.position.pixels;

  @override
  void paintChildren(FlowPaintingContext context) {
    final double pageTitleHeight = titleKey.currentContext!.size!.height;
    const topBarTitleTranslationYStart =
        -1 * WoltModalSheetTopBarTitleFlow._topBarTitleTranslationYAmount;
    const topBarTitleTranslationYAmount =
        WoltModalSheetTopBarTitleFlow._topBarTitleTranslationYAmount;
    const topBarTitleTranslationYEnd =
        topBarTitleTranslationYStart + topBarTitleTranslationYAmount;

    final topBarTitleTranslationYAndOpacityStartPoint =
        heroImageHeight == 0 ? 8 : heroImageHeight - topBarHeight;

    /// Top Bar Title translation Y
    final topBarTitleTranslationY =
        WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: pageTitleHeight,
      progressInRangeInPx:
          currentScrollPosition - topBarTitleTranslationYAndOpacityStartPoint,
      startValue: topBarTitleTranslationYStart,
      endValue: topBarTitleTranslationYEnd,
    );

    /// Top Bar Title Opacity
    final topBarTitleOpacity =
        WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: pageTitleHeight / 2,
      progressInRangeInPx:
          currentScrollPosition - topBarTitleTranslationYAndOpacityStartPoint,
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
        scrollController.position.pixels !=
            oldDelegate.scrollController.position.pixels ||
        softKeyboardClosedNotifier.value !=
            oldDelegate.softKeyboardClosedNotifier.value ||
        topBarHeight != oldDelegate.topBarHeight;
  }
}
