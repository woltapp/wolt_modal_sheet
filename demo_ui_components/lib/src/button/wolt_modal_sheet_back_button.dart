import 'package:demo_ui_components/src/button/wolt_circular_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetBackButton extends StatelessWidget {
  const WoltModalSheetBackButton({this.onBackPressed, super.key});

  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Semantics(
        label: semanticsLabel(context),
        container: true,
        button: true,
        child: ExcludeSemantics(
          child: WoltCircularElevatedButton(
            onPressed: onBackPressed ?? WoltModalSheet.of(context).showPrevious,
            icon: Icons.arrow_back_rounded,
          ),
        ),
      ),
    );
  }

  String semanticsLabel(BuildContext context) {
    return Localizations.of<MaterialLocalizations>(
                context, MaterialLocalizations)
            ?.backButtonTooltip ??
        const DefaultMaterialLocalizations().backButtonTooltip;
  }
}
