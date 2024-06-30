import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltAlertDialogType extends WoltDialogType {
  const WoltAlertDialogType();

  @override
  BoxConstraints layoutModal(Size availableSize) {
    const padding = 32.0;
    final availableWidth = availableSize.width;
    double width = availableWidth > 523.0 ? 312.0 : availableWidth - padding;

    if (availableWidth > 523.0) {
      width = 312.0; // optimal width for larger screens
    } else if (availableWidth > 240.0) {
      width = 240.0; // standard width for moderate screens
    } else {
      width = availableWidth - padding; // adjust for very small screens
    }

    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: 0,
      maxHeight: availableSize.height * 0.8,
    );
  }

  /// Defines a transition animation for the alert dialog's appearance.
  ///
  /// [context] is the build context.
  /// [animation] is the primary animation controller for the dialog's appearance.
  /// [secondaryAnimation] manages the coordination with other routes' transitions.
  /// [child] is the content widget to be animated.
  ///
  /// Returns a transition widget that manages the dialog's transition animation.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isClosing = animation.status == AnimationStatus.reverse;

    const enteringInterval = Interval(100.0 / 250.0, 1.0, curve: Curves.linear);
    const exitingInterval = Interval(0.0, 100.0 / 300.0, curve: Curves.linear);

    const enteringCubic = Cubic(0.2, 0.6, 0.4, 1.0);
    const exitingCubic = Cubic(0.5, 0, 0.7, 0.2);

    final interval = isClosing ? exitingInterval : enteringInterval;
    final reverseInterval = isClosing ? enteringInterval : exitingInterval;

    final cubic = isClosing ? exitingCubic : enteringCubic;
    final reverseCubic = isClosing ? enteringCubic : exitingCubic;

    final alphaAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: interval,
      reverseCurve: reverseInterval,
    ));

    final scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: cubic,
      reverseCurve: reverseCubic,
    ));

    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: alphaAnimation,
        child: child,
      ),
    );
  }
}
