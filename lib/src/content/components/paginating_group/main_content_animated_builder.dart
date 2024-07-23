import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/wolt_modal_sheet_page_transition_state.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MainContentAnimatedBuilder extends StatefulWidget {
  final AnimationController controller;
  final GlobalKey outgoingOffstagedMainContentKey;
  final GlobalKey incomingOffstagedMainContentKey;
  final Widget child;
  final bool forwardMove;
  final double sheetWidth;
  final WoltModalSheetPageTransitionState pageTransitionState;
  final WoltModalSheetPaginationAnimationStyle paginationAnimationStyle;

  const MainContentAnimatedBuilder({
    required this.controller,
    required this.child,
    required this.outgoingOffstagedMainContentKey,
    required this.incomingOffstagedMainContentKey,
    required this.forwardMove,
    required this.sheetWidth,
    required this.pageTransitionState,
    required this.paginationAnimationStyle,
    super.key,
  });

  @override
  State<MainContentAnimatedBuilder> createState() =>
      _MainContentAnimatedBuilderState();
}

class _MainContentAnimatedBuilderState
    extends State<MainContentAnimatedBuilder> {
  Animation<double>? _sizeFactor;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      BuildContext? incomingContext =
          widget.incomingOffstagedMainContentKey.currentContext;
      BuildContext? outgoingContext =
          widget.outgoingOffstagedMainContentKey.currentContext;
      if (_sizeFactor == null &&
          incomingContext?.mounted == true &&
          outgoingContext?.mounted == true) {
        _sizeFactor = widget.pageTransitionState.mainContentHeightTransition(
          widget.controller,
          widget.paginationAnimationStyle,
          incomingMainContentHeight: incomingContext!.size!.height,
          outgoingMainContentHeight: outgoingContext!.size!.height,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final controller = widget.controller;
    final pageTransitionState = widget.pageTransitionState;
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        return SizeTransition(
          axisAlignment: -1.0,
          sizeFactor: _sizeFactor ??
              pageTransitionState.defaultMainContentSizeFactor(controller),
          child: Opacity(
            opacity: pageTransitionState
                .mainContentOpacity(controller, widget.paginationAnimationStyle)
                .value,
            child: SlideTransition(
              position: pageTransitionState.mainContentSlidePosition(
                controller,
                widget.paginationAnimationStyle,
                sheetWidth: widget.sheetWidth,
                screenWidth: screenWidth,
                isForwardMove: widget.forwardMove,
                textDirection: Directionality.of(context),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
