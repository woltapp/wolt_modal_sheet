import 'package:flutter/material.dart';

class OutgoingTopBarWidgetsAnimatedBuilder extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> _opacity;
  final Widget child;

  OutgoingTopBarWidgetsAnimatedBuilder({
    required this.controller,
    required this.child,
    super.key,
  })  : _opacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0,
              100 / 350,
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? _) {
        return Opacity(
          opacity: _opacity.value,
          child: child,
        );
      },
    );
  }
}
