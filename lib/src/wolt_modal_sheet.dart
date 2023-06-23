import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_animated_layout_builder.dart';
import 'package:wolt_modal_sheet/src/multi_child_layout/wolt_modal_multi_child_layout_barrier_child.dart';
import 'package:wolt_modal_sheet/src/multi_child_layout/wolt_modal_multi_child_layout_delegate.dart';
import 'package:wolt_modal_sheet/src/multi_child_layout/wolt_modal_multi_child_layout_dialog_child.dart';
import 'package:wolt_modal_sheet/src/wolt_modal_sheet_route.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'multi_child_layout/wolt_modal_multi_child_layout_sheet_child_bottom_sheet.dart';

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

  ValueNotifier<int> get pageIndexNotifier => widget.pageIndexNotifier;

  ValueNotifier<WoltModalSheetPageListBuilder> get pagesListBuilderNotifier =>
      widget.pageListBuilderNotifier;

  Widget Function(Widget) get _decorator =>
      widget.decorator ?? (widget) => Builder(builder: (_) => widget);

  static const barrierLayoutId = 'barrierLayoutId';

  static const contentLayoutId = 'contentLayoutId';

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
    final content = AnimatedBuilder(
      animation: Listenable.merge([
        pageIndexNotifier,
        pagesListBuilderNotifier,
        widget.route.animation,
      ]),
      builder: (BuildContext context, Widget? child) {
        // Disable the initial animation when accessible navigation is on so
        // that the semantics are added to the tree at the correct time.
        final double animationValue = WoltModalSheet.animationCurve.transform(
          MediaQuery.of(context).accessibleNavigation ? 1.0 : widget.route.animation!.value,
        );
        final pageIndex = pageIndexNotifier.value;
        final pages = pagesListBuilderNotifier.value(context);
        final page = pages[pageIndex];
        return _decorator(
          CustomMultiChildLayout(
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
                child: WoltModalMultiChildLayoutBarrierChild(
                    onTap: widget.onModalDismissedWithBarrierTap),
              ),
              LayoutId(
                id: contentLayoutId,
                child: Builder(
                  builder: (BuildContext context) {
                    final layout = WoltModalSheetAnimatedLayoutBuilder(
                      woltModalType: modalType,
                      pageIndex: pageIndex,
                      pages: pages,
                    );
                    switch (modalType) {
                      case WoltModalType.bottomSheet:
                        return WoltModalMultiChildLayoutBottomSheetChild(
                          pageBackgroundColor: page.backgroundColor,
                          animationController: widget.route.animationController!,
                          enableDrag: widget.enableDragForBottomSheet,
                          route: widget.route,
                          child: layout,
                        );
                      case WoltModalType.dialog:
                        return WoltModalMultiChildLayoutDialogChild(
                          pageBackgroundColor: page.backgroundColor,
                          child: layout,
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    // If useSafeArea is true, a SafeArea is inserted.
    // If useSafeArea is false, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    final Widget modal = widget.useSafeArea
        ? SafeArea(child: content)
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: content,
          );

    return Scaffold(backgroundColor: Colors.transparent, body: modal);
  }
}
