import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/playground_cubit.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithForcedMaxHeight {
  SheetPageWithForcedMaxHeight._();

  static WoltModalSheetPage build(BuildContext context, {bool isLastPage = true}) {
    final cubit = context.read<PlaygroundCubit>();
    return WoltModalSheetPage.withSingleChild(
      backgroundColor: WoltColors.green8,
      mainContentPadding: const EdgeInsetsDirectional.all(16),
      forceMaxHeight: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WoltElevatedButton(
          onPressed: isLastPage ? cubit.close : cubit.goToNextPage,
          colorName: WoltColorName.green,
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      pageTitle: const ModalSheetTitle('Page with forced max height and background color'),
      backButton: WoltModalSheetBackButton(onBackPressed: cubit.goToPreviousPage),
      closeButton: WoltModalSheetCloseButton(onClosed: cubit.close),
      child: const Text('''
This page height is forced to be the max height according to the provided max height ratio regardless of the intrinsic height of the child widget. 
'''),
    );
  }
}
