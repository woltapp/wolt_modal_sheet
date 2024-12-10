import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

/// The `GridLayoutButton` widget displays a button indicating the visibility of the grid layout.
/// It is a toggle button that allows the user to switch the grid layout visibility states.
class GridLayoutButton extends StatelessWidget {
  const GridLayoutButton({
    required ValueNotifier<bool> isGridOverlayVisible,
    super.key,
  }) : _isGridOverlayVisible = isGridOverlayVisible;

  final ValueNotifier<bool> _isGridOverlayVisible;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isGridOverlayVisible,
      builder: (_, isVisible, __) {
        return OutlinedButton(
          style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                side: const MaterialStatePropertyAll(
                  BorderSide(
                    width: 2,
                    color: WoltColors.gray,
                  ),
                ),
              ),
          onPressed: () {
            _isGridOverlayVisible.value = !_isGridOverlayVisible.value;
          },
          child: Icon(
              _isGridOverlayVisible.value ? Icons.grid_off : Icons.grid_on,
              size: 16),
        );
      },
    );
  }
}
