import 'package:flutter/widgets.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Wraps the child with a [SafeArea] widget if the modal type is [WoltSideSheetModal].
class ModalComponentSafeAreaWrapper extends StatelessWidget {
  const ModalComponentSafeAreaWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    MediaQuery.paddingOf(context);
    if (WoltModalSheet.of(context).modalType?.isSideSheet ?? false) {
      return SafeArea(child: child);
    }
    return child;
  }
}
