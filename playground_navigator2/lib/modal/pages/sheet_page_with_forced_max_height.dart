import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/router_cubit.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithForcedMaxHeight {
  SheetPageWithForcedMaxHeight._();

  static WoltModalSheetPage build(
    BuildContext context, {
    required int currentPage,
    bool isLastPage = true,
  }) {
    final cubit = context.read<RouterCubit>();
    return WoltModalSheetPage.withSingleChild(
      backgroundColor: WoltColors.green8,
      forceMaxHeight: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltElevatedButton(
          onPressed: isLastPage ? cubit.closeSheet : () => cubit.goToPage(currentPage + 1),
          colorName: WoltColorName.green,
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      hasTopBarLayer: false,
      pageTitle: const ModalSheetTitle('Page with forced max height and background color'),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
This page height is forced to be the max height according to the provided max height ratio regardless of the intrinsic height of the child widget. This page also doesn't have a top bar nor navigation bar controls. 
''',
        ),
      ),
    );
  }
}
