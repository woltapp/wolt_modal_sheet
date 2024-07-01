import 'package:flutter/material.dart';

class WoltAnimatedModalBarrier extends StatelessWidget {
  final AnimationController animationController;
  final bool barrierDismissible;
  final VoidCallback? onModalDismissedWithBarrierTap;

  const WoltAnimatedModalBarrier({
    Key? key,
    required this.animationController,
    required this.barrierDismissible,
    this.onModalDismissedWithBarrierTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alphaAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 1.0, curve: Curves.linear),
    ));

    return FadeTransition(
      opacity: alphaAnimation,
      child: ModalBarrier(
        semanticsLabel: MaterialLocalizations.of(context).scrimLabel,
        dismissible: barrierDismissible,
        onDismiss: () {
          if (onModalDismissedWithBarrierTap != null) {
            onModalDismissedWithBarrierTap!();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
