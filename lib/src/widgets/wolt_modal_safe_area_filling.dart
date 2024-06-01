import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';

class WoltModalSafeAreaFilling extends StatelessWidget {
  final WoltModalType modalType;
  final Color safeAreaColor;
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
      mainAxisSize: MainAxisSize.min,
      children: [
        if (modalType.isStartSafeAreaFilled)
          _StartSafeAreaFilling(safeAreaColor),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (modalType.isTopSafeAreaFilled)
                _TopSafeAreaFilling(safeAreaColor),
              child,
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
  const _TopSafeAreaFilling(this.safeAreaColor);

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: safeAreaColor,
      child: SizedBox(
        height: MediaQuery.paddingOf(context).top,
        width: double.infinity,
      ),
    );
  }
}

class _BottomSafeAreaFilling extends StatelessWidget {
  const _BottomSafeAreaFilling(this.safeAreaColor);

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: safeAreaColor,
      child: SizedBox(
        height: MediaQuery.paddingOf(context).bottom,
        width: double.infinity,
      ),
    );
  }
}

class _StartSafeAreaFilling extends StatelessWidget {
  const _StartSafeAreaFilling(this.safeAreaColor);

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
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
  const _EndSafeAreaFilling(this.safeAreaColor);

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
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
