import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/wolt_modal_sheet_page_transition_state.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SabAnimatedBuilder extends StatelessWidget {
  final AnimationController controller;
  final WoltModalSheetPageTransitionState pageTransitionState;
  final Widget child;
  final WoltModalSheetPaginationAnimationStyle paginationAnimationStyle;

  const SabAnimatedBuilder({
    required this.controller,
    required this.child,
    required this.pageTransitionState,
    required this.paginationAnimationStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final opacity =
        pageTransitionState.sabOpacity(controller, paginationAnimationStyle);
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext _, __) {
        return Opacity(opacity: opacity.value, child: child);
      },
    );
  }
}
