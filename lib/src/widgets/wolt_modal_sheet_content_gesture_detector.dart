import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_dismiss_direction.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _closeProgressThreshold = 0.5;

class WoltModalSheetContentGestureDetector extends StatelessWidget {
  const WoltModalSheetContentGestureDetector({
    super.key,
    required this.child,
    required this.modalType,
    required this.enableDrag,
    required this.onModalDismissedWithDrag,
    required this.modalContentKey,
    required this.route,
  });

  final WoltModalType modalType;
  final Widget child;
  final bool enableDrag;
  final WoltModalSheetRoute route;
  final VoidCallback? onModalDismissedWithDrag;
  final GlobalKey modalContentKey;

  AnimationController get _animationController => route.animationController!;

  WoltModalDismissDirection? get _dismissDirection =>
      modalType.dismissDirection;

  double get _minFlingVelocity => modalType.minFlingVelocity;

  bool get canDragToDismiss =>
      enableDrag &&
      _dismissDirection != null &&
      _dismissDirection != WoltModalDismissDirection.none;

  bool get _isDismissUnderway =>
      route.animationController!.status == AnimationStatus.reverse;

  bool get _isDismissed => route.animationController!.isDismissed;

  RenderBox get _renderBox =>
      modalContentKey.currentContext!.findRenderObject()! as RenderBox;

  double get _childHeight => _renderBox.size.height;

  double get _childWidth => _renderBox.size.width;

  @override
  Widget build(BuildContext context) {
    final isVertical = _dismissDirection?.isVertical ?? false;
    final isHorizontal = _dismissDirection?.isHorizontal ?? false;

    return GestureDetector(
      excludeFromSemantics: true,
      // Handle drag gestures based on the specified dismiss direction
      onVerticalDragUpdate: (details) => canDragToDismiss && isVertical
          ? _handleVerticalDragUpdate(details)
          : null,
      onVerticalDragEnd: (details) => canDragToDismiss && isVertical
          ? _handleVerticalDragEnd(context, details)
          : null,
      onHorizontalDragUpdate: (details) => canDragToDismiss && isHorizontal
          ? _handleHorizontalDragUpdate(context, details)
          : null,
      onHorizontalDragEnd: (details) => canDragToDismiss && isHorizontal
          ? _handleHorizontalDragEnd(context, details)
          : null,
      child: child,
    );
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_isDismissUnderway) {
      return;
    }

    final deltaDiff = details.primaryDelta! / _childHeight;
    if (_dismissDirection == WoltModalDismissDirection.down) {
      _animationController.value -= deltaDiff;
    } else if (_dismissDirection == WoltModalDismissDirection.up) {
      _animationController.value += deltaDiff;
    }
  }

  void _handleVerticalDragEnd(BuildContext context, DragEndDetails details) {
    if (_isDismissUnderway) {
      return;
    }
    bool isClosing = false;
    bool isDraggingUpward = details.velocity.pixelsPerSecond.dy < 0;
    bool isDraggingDownward = details.velocity.pixelsPerSecond.dy > 0;
    final isDismissUp = _dismissDirection?.isUp ?? false;
    final isDismissDown = _dismissDirection?.isDown ?? false;
    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _childHeight;

    if (isDraggingUpward && isDismissUp) {
      if (details.velocity.pixelsPerSecond.dy.abs() > _minFlingVelocity) {
        _animationController.fling(velocity: flingVelocity);
        if (flingVelocity > 0.0) {
          isClosing = true;
        }
      }
    }

    if (isDraggingDownward && isDismissDown) {
      if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
        _animationController.fling(velocity: flingVelocity * -1.0);
        if (flingVelocity < 0.0) {
          isClosing = true;
        }
      }
    }

    if (_animationController.value < _closeProgressThreshold) {
      if (_animationController.value > 0.0) {
        _animationController.fling(velocity: -1.0);
      }
      isClosing = true;
    } else {
      _animationController.forward();
    }

    if (isClosing && route.isCurrent) {
      final onModalDismissedWithDrag = this.onModalDismissedWithDrag;
      if (onModalDismissedWithDrag != null) {
        onModalDismissedWithDrag();
      } else {
        Navigator.pop(context);
      }
    }
  }

  // Handle horizontal drag updates
  void _handleHorizontalDragUpdate(
      BuildContext context, DragUpdateDetails details) {
    if (_isDismissUnderway || _isDismissed) {
      return;
    }

    // Apply the drag update to the animation controller value
    final delta = -details.primaryDelta! / _childWidth;
    switch (_dismissDirection) {
      case WoltModalDismissDirection.startToEnd:
        if (Directionality.of(context) == TextDirection.ltr) {
          _animationController.value += delta;
        } else {
          _animationController.value -= delta;
        }
        break;
      case WoltModalDismissDirection.endToStart:
        if (Directionality.of(context) == TextDirection.ltr) {
          _animationController.value -= delta;
        } else {
          _animationController.value += delta;
        }
        break;
      default:
        _animationController.value += delta;
        break;
    }
  }

  // Handle horizontal drag end
  void _handleHorizontalDragEnd(BuildContext context, DragEndDetails details) {
    if (_isDismissed || _isDismissUnderway) {
      return;
    }

    final horizontalVelocity = details.velocity.pixelsPerSecond.dx.abs();

    if (horizontalVelocity >= _minFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / _childWidth;
      final directionality = Directionality.of(context);
      switch (directionality) {
        case TextDirection.rtl:
          if (_dismissDirection == WoltModalDismissDirection.startToEnd) {
            _animationController.fling(velocity: -visualVelocity);
          } else {
            _animationController.fling(velocity: visualVelocity);
          }
          break;
        case TextDirection.ltr:
          if (_dismissDirection == WoltModalDismissDirection.startToEnd) {
            _animationController.fling(velocity: visualVelocity);
          } else {
            _animationController.fling(velocity: -visualVelocity);
          }
          break;
      }

      switch (_dismissDirection) {
        case WoltModalDismissDirection.startToEnd:
          if (Directionality.of(context) == TextDirection.ltr) {
            _animationController.fling(velocity: visualVelocity);
          } else {
            _animationController.fling(velocity: -visualVelocity);
          }
          break;
        case WoltModalDismissDirection.endToStart:
          if (Directionality.of(context) == TextDirection.ltr) {
            _animationController.fling(velocity: -visualVelocity);
          } else {
            _animationController.fling(velocity: visualVelocity);
          }
          break;
        default:
          _animationController.fling(velocity: visualVelocity);
          break;
      }
    } else if (_animationController.value < 0.5) {
      _animationController.fling(velocity: -1.0);
    }
  }
}
