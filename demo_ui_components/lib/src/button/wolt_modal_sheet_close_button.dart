import 'package:demo_ui_components/src/button/wolt_circular_elevated_button.dart';
import 'package:demo_ui_components/src/utils/modal_component_safe_area_wrapper.dart';
import 'package:flutter/material.dart';

class WoltModalSheetCloseButton extends StatelessWidget {
  const WoltModalSheetCloseButton({this.onClosed, super.key});

  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    return ModalComponentSafeAreaWrapper(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 16),
        child: Semantics(
          label: semanticsLabel(context),
          container: true,
          button: true,
          child: ExcludeSemantics(
            child: WoltCircularElevatedButton(
              onPressed: onClosed ?? Navigator.of(context).pop,
              icon: Icons.close,
            ),
          ),
        ),
      ),
    );
  }

  String semanticsLabel(BuildContext context) {
    return Localizations.of<MaterialLocalizations>(
                context, MaterialLocalizations)
            ?.closeButtonLabel ??
        const DefaultMaterialLocalizations().closeButtonLabel;
  }
}
