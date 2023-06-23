import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

class WoltModalMultiChildLayoutDialogChild extends StatelessWidget {
  final Widget child;
  final Color pageBackgroundColor;

  const WoltModalMultiChildLayoutDialogChild({
    required this.child,
    required this.pageBackgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WoltResponsiveLayoutGrid.centered(
      centerWidgetColumnCount: 2,
      paddedColumnCountPerSide: 1,
      child: Material(
        color: pageBackgroundColor,
        shape: const RoundedRectangleBorder(
          // TODO: Make this configurable through theme extension
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
