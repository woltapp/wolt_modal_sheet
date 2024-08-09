import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalTypeUtils {
  /// Determines the modal type based on the the presence of the modal type builder provided by
  /// the [WoltModalSheet] widget, existence of the [WoltModalSheetThemeData.modalTypeBuilder].
  /// If none of these are available, the default modalTypeBuilder from the
  /// [WoltModalSheetDefaultThemeData] is used.
  static WoltModalType currentModalType(
    WoltModalTypeBuilder? modalTypeBuilder,
    BuildContext context,
  ) {
    final builder = modalTypeBuilder ??
        Theme.of(context)
            .extension<WoltModalSheetThemeData>()
            ?.modalTypeBuilder ??
        WoltModalSheetDefaultThemeData(context).modalTypeBuilder;
    return builder(context);
  }
}
