import 'package:demo_ui_components/src/colors/wolt_colors.dart';
import 'package:flutter/material.dart';

import 'wolt_selection_list_type.dart';

class WoltSelectionListTileTrailing extends StatelessWidget {
  const WoltSelectionListTileTrailing({
    required this.groupType,
    required this.isSelected,
    super.key,
  });

  final WoltSelectionListType groupType;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    switch (groupType) {
      case WoltSelectionListType.multiSelect:
        return CheckboxTrailing(isSelected: isSelected);
      case WoltSelectionListType.singleSelect:
        return RadioTrailing(isSelected: isSelected);
    }
  }
}

class CheckboxTrailing extends StatelessWidget {
  const CheckboxTrailing({required this.isSelected, super.key});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return _TrailingDecoration(
      trailingSize: 32,
      fillColor: (isSelected ? WoltColors.blue : WoltColors.white),
      child: isSelected
          ? const Icon(Icons.check, size: 24, color: WoltColors.white)
          : const SizedBox.expand(),
    );
  }
}

class RadioTrailing extends StatelessWidget {
  const RadioTrailing({required this.isSelected, super.key});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return _TrailingDecoration(
      trailingSize: 20,
      fillColor: WoltColors.white,
      child: isSelected
          ? const Padding(
              padding: EdgeInsets.all(4),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                    color: WoltColors.blue, shape: CircleBorder()),
              ),
            )
          : const SizedBox.expand(),
    );
  }
}

class _TrailingDecoration extends StatelessWidget {
  const _TrailingDecoration({
    required this.child,
    required this.fillColor,
    required this.trailingSize,
  });

  final Widget child;
  final Color fillColor;
  final double trailingSize;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        border: const Border.fromBorderSide(
            BorderSide(color: WoltColors.blue, width: 2)),
        shape: BoxShape.circle,
      ),
      child: SizedBox.fromSize(size: Size.square(trailingSize), child: child),
    );
  }
}
