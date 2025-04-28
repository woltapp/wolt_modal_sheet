import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/utils/soft_keyboard_closed_event.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_layout_transformation_utils.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// [WoltModalSheetTopBarFlow] controls the top bar behavior within the modal sheet page
/// provided by the [WoltModalSheetPage] when `isTopBarLayerAlwaysVisible` is set to false.
///
/// It is responsible for the positioning, translation, and opacity of the top bar as the user
/// scrolls through the content. Utilizing the [Flow] widget, it listens to the current scroll
/// position and soft keyboard closing events, then, performs transformations to achieve the
/// desired  effects on the top bar, such as fading in/out and translating vertically.
class WoltModalSheetTopBarFlow extends StatefulWidget {
  final ScrollController scrollController;
  final GlobalKey titleKey;
  final SliverWoltModalSheetPage page;
  final ValueListenable<SoftKeyboardClosedEvent> softKeyboardClosedListenable;
  final WoltModalSheetScrollAnimationStyle scrollAnimationStyle;

  const WoltModalSheetTopBarFlow({
    required this.page,
    required this.scrollController,
    required this.titleKey,
    required this.softKeyboardClosedListenable,
    required this.scrollAnimationStyle,
    Key? key,
  }) : super(key: key);

  @override
  _WoltModalSheetTopBarFlowState createState() =>
      _WoltModalSheetTopBarFlowState();
}

class _WoltModalSheetTopBarFlowState extends State<WoltModalSheetTopBarFlow> {
  double _currentScrollOffset = 0.0;
  bool _scrollUpdateScheduled = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current offset if possible
    if (widget.scrollController.hasClients) {
      _currentScrollOffset = widget.scrollController.position.pixels;
    }
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(covariant WoltModalSheetTopBarFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController.removeListener(_scrollListener);
      // Initialize with new controller's offset if possible
      if (widget.scrollController.hasClients) {
        _currentScrollOffset = widget.scrollController.position.pixels;
      } else {
        _currentScrollOffset = 0.0; // Reset if no clients
      }
      widget.scrollController.addListener(_scrollListener);
    }
    // Update offset immediately if controller has clients and offset differs
    if (widget.scrollController.hasClients &&
        _currentScrollOffset != widget.scrollController.position.pixels) {
      _scrollListener();
    }
  }

  void _scrollListener() {
    // Throttle updates to post-frame to avoid layout dirties during hit tests
    if (!widget.scrollController.hasClients) return;
    final newOffset = widget.scrollController.position.pixels;
    if (_currentScrollOffset == newOffset) return;
    _currentScrollOffset = newOffset;
    if (!_scrollUpdateScheduled) {
      _scrollUpdateScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
        _scrollUpdateScheduled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final topBarHeight = widget.page.navBarHeight ??
        themeData?.navBarHeight ??
        defaultThemeData.navBarHeight;
    final heroImageHeight = widget.page.heroImage == null
        ? 0.0
        : (widget.page.heroImageHeight ??
            themeData?.heroImageHeight ??
            defaultThemeData.heroImageHeight);

    return Flow(
      delegate: _TopBarFlowDelegate(
        topBarHeight: topBarHeight,
        heroImageHeight: heroImageHeight,
        scrollController: widget.scrollController,
        titleKey: widget.titleKey,
        softKeyboardClosedListenable: widget.softKeyboardClosedListenable,
        scrollAnimationStyle: widget.scrollAnimationStyle,
        currentScrollOffset: _currentScrollOffset,
      ),
      children: [WoltModalSheetTopBar(page: widget.page)],
    );
  }
}

class _TopBarFlowDelegate extends FlowDelegate {
  final double topBarHeight;
  final double heroImageHeight;
  final ScrollController scrollController;
  final GlobalKey titleKey;
  final ValueListenable<SoftKeyboardClosedEvent> softKeyboardClosedListenable;
  final WoltModalSheetScrollAnimationStyle scrollAnimationStyle;
  final double currentScrollOffset;

  _TopBarFlowDelegate({
    required this.topBarHeight,
    required this.heroImageHeight,
    required this.scrollController,
    required this.titleKey,
    required this.scrollAnimationStyle,
    required this.softKeyboardClosedListenable,
    required this.currentScrollOffset,
  }) : super(
          repaint: Listenable.merge([
            scrollController,
            softKeyboardClosedListenable,
          ]),
        );

  @override
  void paintChildren(FlowPaintingContext context) {
    final pageTitleHeight = titleKey.currentContext!.size!.height;

    final topBarTranslationYStart =
        -1 * scrollAnimationStyle.topBarTranslationYInPixels;
    const topBarTranslationYEnd = 0.0;
    final topBarTranslationYAndOpacityStartPoint =
        heroImageHeight == 0 ? 0 : heroImageHeight - topBarHeight - 8;

    /// Top bar translation Y
    final topBarTranslationY =
        WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: 8 + pageTitleHeight,
      progressInRangeInPx:
          currentScrollOffset - topBarTranslationYAndOpacityStartPoint,
      startValue: topBarTranslationYStart,
      endValue: topBarTranslationYEnd,
    );

    /// Top bar opacity
    final topBarOpacity =
        WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: 8,
      progressInRangeInPx:
          currentScrollOffset - topBarTranslationYAndOpacityStartPoint,
      startValue: scrollAnimationStyle.topBarOpacityStart,
      endValue: scrollAnimationStyle.topBarOpacityEnd,
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
        currentScrollOffset != oldDelegate.currentScrollOffset ||
        softKeyboardClosedListenable.value !=
            oldDelegate.softKeyboardClosedListenable.value ||
        topBarHeight != oldDelegate.topBarHeight;
  }
}
