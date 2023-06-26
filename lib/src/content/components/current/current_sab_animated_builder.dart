import 'package:flutter/material.dart';

class CurrentSabAnimatedBuilder extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> _opacity;
  final Widget stickyActionBar;

  CurrentSabAnimatedBuilder({
    required this.controller,
    required this.stickyActionBar,
    super.key,
  }) : _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              100 / 350,
              300 / 350,
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext _, Widget? __) {
        return Opacity(opacity: _opacity.value, child: stickyActionBar);
      },
    );
  }
}
