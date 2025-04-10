import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetDragToDismissDetector extends StatelessWidget {
  const WoltModalSheetDragToDismissDetector({
    super.key,
    required this.child,
    required this.modalType,
    required this.onModalDismissedWithDrag,
    required this.modalContentKey,
    required this.route,
  });

  final WoltModalType modalType;
  final Widget child;
  final WoltModalSheetRoute route;
  final VoidCallback? onModalDismissedWithDrag;
  final GlobalKey modalContentKey;

  AnimationController get _animationController => route.animationController!;

  WoltModalDismissDirection? get _dismissDirection =>
      modalType.dismissDirection;

  double get _minFlingVelocity => modalType.minFlingVelocity;

  bool get _isDismissUnderway =>
      _animationController.status == AnimationStatus.reverse;

  bool get _isDismissed => _animationController.isDismissed;

  RenderBox get _renderBox =>
      modalContentKey.currentContext!.findRenderObject()! as RenderBox;

  double get _childHeight => _renderBox.size.height;

  double get _childWidth => _renderBox.size.width;

  @override
  Widget build(BuildContext context) {
    final isVerticalDismissAllowed = _dismissDirection?.isVertical ?? false;
    final isHorizontalDismissAllowed = _dismissDirection?.isHorizontal ?? false;

    return NotificationListener(
      onNotification: (notification) {
        if (notification is OverscrollNotification &&
            notification.dragDetails != null) {
          if (isVerticalDismissAllowed) {
            _handleVerticalDragUpdate(notification.dragDetails!);
          } else if (isHorizontalDismissAllowed) {
            _handleHorizontalDragUpdate(context, notification.dragDetails!);
          }
        }
        if (notification is ScrollEndNotification &&
            notification.dragDetails != null) {
          if (isVerticalDismissAllowed) {
            _handleVerticalDragEnd(context, notification.dragDetails!);
          } else if (isHorizontalDismissAllowed) {
            _handleHorizontalDragEnd(context, notification.dragDetails!);
          }
        }
        return true;
      },
      child: GestureDetector(
        excludeFromSemantics: true,
        onVerticalDragUpdate: isVerticalDismissAllowed
            ? (details) => _handleVerticalDragUpdate(details)
            : null,
        onVerticalDragEnd: isVerticalDismissAllowed
            ? (details) => _handleVerticalDragEnd(context, details)
            : null,
        onHorizontalDragUpdate: isHorizontalDismissAllowed
            ? (details) => _handleHorizontalDragUpdate(context, details)
            : null,
        onHorizontalDragEnd: isHorizontalDismissAllowed
            ? (details) => _handleHorizontalDragEnd(context, details)
            : null,
        child: child,
      ),
    );
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_isDismissUnderway || _isDismissed) {
      return;
    }

    final deltaDiff = details.primaryDelta! / _childHeight;
    final newValue = switch (_dismissDirection) {
      WoltModalDismissDirection.down => _animationController.value - deltaDiff,
      WoltModalDismissDirection.up => _animationController.value + deltaDiff,
      _ => _animationController.value,
    };

    if (newValue >= 0.01) {
      _animationController.value = newValue;
    }
  }

  void _handleVerticalDragEnd(BuildContext context, DragEndDetails details) {
    if (_isDismissUnderway || _isDismissed) {
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

    if (_animationController.value < modalType.closeProgressThreshold) {
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

  void _handleHorizontalDragUpdate(
    BuildContext context,
    DragUpdateDetails details,
  ) {
    if (_isDismissUnderway || _isDismissed) {
      return;
    }

    final delta = -details.primaryDelta! / _childWidth;
    double newValue = _animationController.value;

    switch (_dismissDirection) {
      case WoltModalDismissDirection.startToEnd:
        if (Directionality.of(context) == TextDirection.ltr) {
          newValue -= delta;
        } else {
          newValue += delta;
        }
        break;
      case WoltModalDismissDirection.endToStart:
        if (Directionality.of(context) == TextDirection.ltr) {
          newValue += delta;
        } else {
          newValue -= delta;
        }
        break;
      default:
        break;
    }

    if (newValue >= 0.01) {
      _animationController.value = newValue;
    }
  }

  void _handleHorizontalDragEnd(BuildContext context, DragEndDetails details) {
    if (_isDismissed || _isDismissUnderway) {
      return;
    }

    bool isClosing = false;
    bool isDraggingToEnd = details.velocity.pixelsPerSecond.dx > 0;
    bool isDraggingToStart = details.velocity.pixelsPerSecond.dx < 0;
    final isDismissToStart =
        _dismissDirection == WoltModalDismissDirection.endToStart;
    final isDismissToEnd =
        _dismissDirection == WoltModalDismissDirection.startToEnd;
    final double flingVelocity =
        details.velocity.pixelsPerSecond.dx / _childWidth;

    if (details.velocity.pixelsPerSecond.dx.abs() >= _minFlingVelocity) {
      final directionality = Directionality.of(context);

      if (directionality == TextDirection.rtl) {
        if (isDraggingToEnd && isDismissToEnd) {
          _animationController.fling(velocity: -flingVelocity);
          if (flingVelocity < 0.0) {
            isClosing = true;
          }
        } else if (isDraggingToStart && isDismissToStart) {
          _animationController.fling(velocity: flingVelocity);
          if (flingVelocity > 0.0) {
            isClosing = true;
          }
        }
      } else {
        if (isDraggingToEnd && isDismissToEnd) {
          _animationController.fling(velocity: flingVelocity);
          if (flingVelocity > 0.0) {
            isClosing = true;
          }
        } else if (isDraggingToStart && isDismissToStart) {
          _animationController.fling(velocity: -flingVelocity);
          if (flingVelocity < 0.0) {
            isClosing = true;
          }
        }
      }
    } else if (_animationController.value < modalType.closeProgressThreshold) {
      _animationController.fling(velocity: -1.0);
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
}
