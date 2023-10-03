import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/wolt_modal_sheet_page_transition_state.dart';

class SabAnimatedBuilder extends StatelessWidget {
  final AnimationController controller;
  final WoltModalSheetPageTransitionState pageTransitionState;
  final Widget child;

  const SabAnimatedBuilder({
    required this.controller,
    required this.child,
    required this.pageTransitionState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = pageTransitionState.sabOpacity(controller);
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext _, Widget? __) {
        return Opacity(
          opacity: opacity.value,
          child: child,
        );
      },
    );
  }
}
