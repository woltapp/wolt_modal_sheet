import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

class StickyActionBarWrapper extends StatelessWidget {
  const StickyActionBarWrapper({
    required this.child,
    this.padding,
    this.backgroundColor = Colors.white,
    super.key,
  });

  final Widget child;
  final Color backgroundColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final defaultPaddingSize = context.screenSize == WoltScreenSize.small ? 16.0 : 32.0;
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(defaultPaddingSize, 0, defaultPaddingSize, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 24.0,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  backgroundColor,
                  backgroundColor.withOpacity(0),
                ],
              ),
            ),
          ),
          ColoredBox(color: backgroundColor, child: child),
          ColoredBox(
            color: backgroundColor,
            child: SizedBox(
              height: defaultPaddingSize,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
