import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _minInteractiveDimension = 48.0;

class WoltBottomSheetDragHandle extends StatelessWidget {
  const WoltBottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final handleSize = themeData?.dragHandleSize ?? defaultThemeData.dragHandleSize;
    final handleColor = themeData?.dragHandleColor ?? defaultThemeData.dragHandleColor;

    // Ensure that handle size does not exceed the minimum interactive dimension.
    final adjustedHandleWidth = handleSize.width.clamp(0.0, _minInteractiveDimension);
    final adjustedHandleHeight = handleSize.height.clamp(0.0, _minInteractiveDimension);

    // Calculate padding to center the handle.
    final horizontalPadding = (_minInteractiveDimension - adjustedHandleWidth) / 2;
    const topPadding = 8.0;
    final bottomPadding = _minInteractiveDimension - topPadding - adjustedHandleHeight;

    return Semantics(
      label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      container: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: _minInteractiveDimension,
            minHeight: _minInteractiveDimension,
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(
              horizontalPadding,
              topPadding,
              horizontalPadding,
              bottomPadding.clamp(0.0, _minInteractiveDimension),
            ),
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(adjustedHandleHeight / 2),
            ),
            width: adjustedHandleWidth,
            height: adjustedHandleHeight,
          ),
        ),
      ),
    );
  }
}
