import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';

/// A widget that fills the safe areas around a modal with a specified color based on the modal's type.
///
/// This widget is designed to be used in scenarios where the modal needs to adapt to different
/// safe area constraints, such as on different devices or orientations. It takes into consideration
/// the modal's type to decide which safe areas (top, bottom, start, end) need to be filled.
/// ```
class WoltModalSafeAreaFilling extends StatelessWidget {
  /// Defines the type of modal, which affects how safe areas are filled.
  final WoltModalType modalType;

  /// The color used to fill the safe areas.
  final Color safeAreaColor;

  /// The main content of the modal.
  final Widget child;

  const WoltModalSafeAreaFilling({
    super.key,
    required this.modalType,
    required this.safeAreaColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (modalType.isStartSafeAreaFilled)
          _StartSafeAreaFilling(safeAreaColor),
        Expanded(
          child: Column(
            children: [
              if (modalType.isTopSafeAreaFilled)
                _TopSafeAreaFilling(safeAreaColor),
              Expanded(child: child),
              if (modalType.isBottomSafeAreaFilled)
                _BottomSafeAreaFilling(safeAreaColor),
            ],
          ),
        ),
        if (modalType.isEndSafeAreaFilled) _EndSafeAreaFilling(safeAreaColor),
      ],
    );
  }
}

class _TopSafeAreaFilling extends StatelessWidget {
  final Color safeAreaColor;

  const _TopSafeAreaFilling(this.safeAreaColor);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: safeAreaColor,
      child: SizedBox(
        height: MediaQuery.of(context).padding.top,
        width: double.infinity,
      ),
    );
  }
}

class _BottomSafeAreaFilling extends StatelessWidget {
  final Color safeAreaColor;

  const _BottomSafeAreaFilling(this.safeAreaColor);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: safeAreaColor,
      child: SizedBox(
        height: MediaQuery.of(context).padding.bottom,
        width: double.infinity,
      ),
    );
  }
}

class _StartSafeAreaFilling extends StatelessWidget {
  final Color safeAreaColor;

  const _StartSafeAreaFilling(this.safeAreaColor);

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.of(context).padding;
    switch (textDirection) {
      case TextDirection.ltr:
        return ColoredBox(
          color: safeAreaColor,
          child: SizedBox(
            height: double.infinity,
            width: padding.left,
          ),
        );
      case TextDirection.rtl:
        return ColoredBox(
          color: safeAreaColor,
          child: SizedBox(
            height: double.infinity,
            width: padding.right,
          ),
        );
    }
  }
}

class _EndSafeAreaFilling extends StatelessWidget {
  final Color safeAreaColor;

  const _EndSafeAreaFilling(this.safeAreaColor);

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.of(context).padding;
    switch (textDirection) {
      case TextDirection.ltr:
        return ColoredBox(
          color: safeAreaColor,
          child: SizedBox(
            height: double.infinity,
            width: padding.right,
          ),
        );
      case TextDirection.rtl:
        return ColoredBox(
          color: safeAreaColor,
          child: SizedBox(
            height: double.infinity,
            width: padding.left,
          ),
        );
    }
  }
}
