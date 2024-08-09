import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'wolt_modal_sheet_page_transition_state.dart';

class NavigationToolbarAnimatedBuilder extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final WoltModalSheetPageTransitionState pageTransitionState;
  final WoltModalSheetPaginationAnimationStyle paginationAnimationStyle;

  const NavigationToolbarAnimatedBuilder({
    required this.pageTransitionState,
    required this.controller,
    required this.child,
    required this.paginationAnimationStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = pageTransitionState.navigationToolbarOpacity(
      controller,
      paginationAnimationStyle,
    );
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext _, __) {
        return Opacity(opacity: opacity.value, child: child);
      },
    );
  }
}
