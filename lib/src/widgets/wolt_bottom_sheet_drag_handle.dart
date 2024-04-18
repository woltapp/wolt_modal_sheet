import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltBottomSheetDragHandle extends StatelessWidget {
  const WoltBottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final handleSize =
        themeData?.dragHandleSize ?? defaultThemeData.dragHandleSize;
    final handleColor =
        themeData?.dragHandleColor ?? defaultThemeData.dragHandleColor;

    return Semantics(
      label: semanticsLabel(context),
      container: true,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 8.0),
          height: handleSize.height,
          width: handleSize.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(handleSize.height / 2),
            color: handleColor,
          ),
        ),
      ),
    );
  }

  String semanticsLabel(BuildContext context) {
    return Localizations.of<MaterialLocalizations>(
                context, MaterialLocalizations)
            ?.modalBarrierDismissLabel ??
        Localizations.of<CupertinoLocalizations>(
                context, CupertinoLocalizations)
            ?.modalBarrierDismissLabel ??
        const DefaultMaterialLocalizations().modalBarrierDismissLabel;
  }
}
