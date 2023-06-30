import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_animated_switcher.dart';
import 'package:wolt_modal_sheet/src/multi_child_layout/wolt_modal_multi_child_layout_delegate.dart';
import 'package:wolt_modal_sheet/src/utils/bottom_sheet_suspended_curve.dart';
import 'package:wolt_modal_sheet/src/wolt_modal_sheet_route.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _minFlingVelocity = 700.0;

const double _closeProgressThreshold = 0.5;

const int defaultWoltModalTransitionAnimationDuration = 350;

/// Signature for a function that builds a list of [WoltModalSheetPage] based on the given [BuildContext].
typedef WoltModalSheetPageListBuilder = List<WoltModalSheetPage> Function(BuildContext context);

/// Signature for a function that returns the [WoltModalType] based on the given [BuildContext].
typedef WoltModalTypeBuilder = WoltModalType Function(BuildContext context);

class WoltModalSheet<T> extends StatefulWidget {
  const WoltModalSheet({
    required this.pageListBuilderNotifier,
    required this.pageIndexNotifier,
    required this.onModalDismissedWithBarrierTap,
    required this.decorator,
    required this.modalTypeBuilder,
    required this.animationController,
    required this.route,
    required this.enableDragForBottomSheet,
    required this.useSafeArea,
    super.key,
  });

  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;
  final ValueNotifier<int> pageIndexNotifier;
  final VoidCallback? onModalDismissedWithBarrierTap;
  final Widget Function(Widget)? decorator;
  final WoltModalType Function(BuildContext context) modalTypeBuilder;
  final AnimationController? animationController;
  final WoltModalSheetRoute<T> route;
  final bool enableDragForBottomSheet;
  final bool useSafeArea;

  static const ParametricCurve<double> animationCurve = decelerateEasing;

  @override
  State<WoltModalSheet> createState() => _WoltModalSheetState();

  static Future<T?> show<T>({
    required BuildContext context,
    required ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier,
    required WoltModalTypeBuilder modalTypeBuilder,
    ValueNotifier<int>? pageIndexNotifier,
    Widget Function(Widget)? decorator,
    bool useRootNavigator = false,
    bool barrierDismissible = true,
    bool enableDragForBottomSheet = true,
    RouteSettings? routeSettings,
    Duration? transitionDuration,
    VoidCallback? onModalDismissedWithBarrierTap,
    AnimationController? transitionAnimationController,
    bool useSafeArea = false,
  }) {
    final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);

    return navigator.push<T>(
      WoltModalSheetRoute<T>(
        decorator: decorator,
        pageIndexNotifier: pageIndexNotifier ?? ValueNotifier(0),
        pageListBuilderNotifier: pageListBuilderNotifier,
        modalTypeBuilder: modalTypeBuilder,
        barrierDismissible: barrierDismissible,
        routeSettings: routeSettings,
        transitionDuration: transitionDuration,
        enableDragForBottomSheet: enableDragForBottomSheet,
        onModalDismissedWithBarrierTap: onModalDismissedWithBarrierTap,
        transitionAnimationController: transitionAnimationController,
        onDismissed: onModalDismissedWithBarrierTap,
        useSafeArea: useSafeArea,
      ),
    );
  }
}

class _WoltModalSheetState extends State<WoltModalSheet> {
  late WoltModalType modalType;

  ParametricCurve<double> animationCurve = decelerateEasing;

  ValueNotifier<int> get pageIndexNotifier => widget.pageIndexNotifier;

  ValueNotifier<WoltModalSheetPageListBuilder> get pagesListBuilderNotifier =>
      widget.pageListBuilderNotifier;

  Widget Function(Widget) get _decorator =>
      widget.decorator ?? (widget) => Builder(builder: (_) => widget);

  bool get _dismissUnderway => widget.animationController!.status == AnimationStatus.reverse;

  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  static const barrierLayoutId = 'barrierLayoutId';

  static const contentLayoutId = 'contentLayoutId';

  static const double _containerRadiusAmount = 24;

  @override
  void initState() {
    super.initState();
    pageIndexNotifier.addListener(() {
      final currentPageIndexValue = pageIndexNotifier.value;
      pageIndexNotifier.value = max(currentPageIndexValue, 0);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    modalType = widget.modalTypeBuilder(context);
  }

  @override
  Widget build(BuildContext context) {
    final decoratedCustomLayout = _decorator(
      // The order of the notifier builders matter because we want to use the same instance of
      // the page list whenever page index is updated.
      ValueListenableBuilder<WoltModalSheetPageListBuilder>(
        valueListenable: pagesListBuilderNotifier,
        builder: (_, pagesBuilder, __) {
          final pages = pagesBuilder(context);
          return ValueListenableBuilder<int>(
            valueListenable: pageIndexNotifier,
            builder: (_, int pageIndex, __) {
              final page = pages[pageIndex];
              return AnimatedBuilder(
                animation: widget.route.animation!,
                builder: (BuildContext context, Widget? child) {
                  // Disable the initial animation when accessible navigation is on so
                  // that the semantics are added to the tree at the correct time.
                  final double animationValue = animationCurve.transform(
                    MediaQuery.of(context).accessibleNavigation
                        ? 1.0
                        : widget.route.animation!.value,
                  );
                  final enableDrag =
                      modalType == WoltModalType.bottomSheet && widget.enableDragForBottomSheet;
                  return CustomMultiChildLayout(
                    delegate: WoltModalMultiChildLayoutDelegate(
                      contentLayoutId: contentLayoutId,
                      barrierLayoutId: barrierLayoutId,
                      modalType: modalType,
                      maxPageHeight: page.maxPageHeight,
                      minPageHeight: page.minPageHeight,
                      animationProgress: animationValue,
                    ),
                    children: [
                      LayoutId(
                        id: barrierLayoutId,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            widget.onModalDismissedWithBarrierTap?.call();
                            Navigator.of(context).pop();
                          },
                          child: const SizedBox.expand(),
                        ),
                      ),
                      LayoutId(
                        id: contentLayoutId,
                        child: KeyedSubtree(
                          key: _childKey,
                          child: GestureDetector(
                            onVerticalDragStart: enableDrag ? _handleDragStart : null,
                            onVerticalDragUpdate: enableDrag ? _handleDragUpdate : null,
                            onVerticalDragEnd: enableDrag ? _handleDragEnd : null,
                            child: Material(
                              color: page.backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: modalType.borderRadiusGeometry(
                                  /// TODO: Make this configurable through theme extension
                                  _containerRadiusAmount,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: LayoutBuilder(
                                builder: (_, constraints) {
                                  return  WoltModalSheetAnimatedSwitcher(
                                    woltModalType: modalType,
                                    pageIndex: pageIndex,
                                    pages: pages,
                                    sheetWidth: constraints.maxWidth,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: widget.useSafeArea ? SafeArea(child: decoratedCustomLayout) : decoratedCustomLayout,
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) {
      return;
    }
    widget.animationController!.value -= details.primaryDelta! / _childHeight;
  }

  void _handleDragStart(DragStartDetails details) {
    // Allow the bottom sheet to track the user's finger accurately.
    animationCurve = Curves.linear;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) {
      return;
    }
    bool isClosing = false;
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        isClosing = true;
      }
    } else if (widget.animationController!.value < _closeProgressThreshold) {
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: -1.0);
      }
      isClosing = true;
    } else {
      widget.animationController!.forward();
    }

    // Allow the bottom sheet to animate smoothly from its current position.
    animationCurve = BottomSheetSuspendedCurve(
      widget.route.animation!.value,
      curve: animationCurve,
    );

    if (isClosing && widget.route.isCurrent) {
      Navigator.pop(context);
    }
  }
}
