import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/utils/bottom_sheet_suspended_curve.dart';
import 'package:wolt_modal_sheet/src/wolt_modal_sheet_route.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _minFlingVelocity = 700.0;

const double _closeProgressThreshold = 0.5;

class WoltModalMultiChildLayoutBottomSheetChild extends StatefulWidget {
  final AnimationController animationController;
  final bool enableDrag;
  final WoltModalSheetRoute route;
  final Widget child;
  final Color pageBackgroundColor;

  const WoltModalMultiChildLayoutBottomSheetChild({
    super.key,
    required this.animationController,
    required this.enableDrag,
    required this.route,
    required this.child,
    required this.pageBackgroundColor,
  });

  @override
  State<WoltModalMultiChildLayoutBottomSheetChild> createState() =>
      _WoltModalMultiChildLayoutBottomSheetChildState();
}

class _WoltModalMultiChildLayoutBottomSheetChildState
    extends State<WoltModalMultiChildLayoutBottomSheetChild> {
  ParametricCurve<double> animationCurve = WoltModalSheet.animationCurve;

  bool get _dismissUnderway => widget.animationController.status == AnimationStatus.reverse;

  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Make this configurable through theme extension
    const radius = Radius.circular(24);
    return KeyedSubtree(
      key: _childKey,
      child: GestureDetector(
        onVerticalDragStart: widget.enableDrag ? _handleDragStart : null,
        onVerticalDragUpdate: widget.enableDrag ? _handleDragUpdate : null,
        onVerticalDragEnd: widget.enableDrag ? _handleDragEnd : null,
        child: Material(
          color: widget.pageBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.child,
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) {
      return;
    }
    widget.animationController.value -= details.primaryDelta! / _childHeight;
  }

  void _handleDragStart(DragStartDetails details) {
    // Allow the bottom sheet to track the user's finger accurately.
    animationCurve = Curves.linear;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) {
      return;
    }
    bool isClosing = false;
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController.value > 0.0) {
        widget.animationController.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        isClosing = true;
      }
    } else if (widget.animationController.value < _closeProgressThreshold) {
      if (widget.animationController.value > 0.0) {
        widget.animationController.fling(velocity: -1.0);
      }
      isClosing = true;
    } else {
      widget.animationController.forward();
    }

    // Allow the bottom sheet to animate smoothly from its current position.
    animationCurve = BottomSheetSuspendedCurve(
      widget.route.animation!.value,
      curve: animationCurve,
    );

    if (isClosing && widget.route.isCurrent) {
      Navigator.pop(context);
    }
  }
}
