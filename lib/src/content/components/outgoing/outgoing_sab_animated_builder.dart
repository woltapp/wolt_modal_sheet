import 'package:flutter/material.dart';

class OutgoingSabAnimatedBuilder extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> _opacity;
  final Widget sab;

  OutgoingSabAnimatedBuilder({
    required this.controller,
    required this.sab,
    super.key,
  }) : _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
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
      builder: (BuildContext _, Widget? __) {
        return Opacity(opacity: _opacity.value, child: sab);
      },
    );
  }
}
