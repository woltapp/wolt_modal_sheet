import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/playground_state.dart';
import 'package:playground_navigator2/modal/pages/multi_page_path_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

class PlaygroundCubit extends Cubit<PlaygroundState> {
  PlaygroundCubit() : super(const PlaygroundHomeScreenState());

  final ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier =
  ValueNotifier(MultiPagePathName.defaultPath.pageListBuilder);

  WoltModalType modalTypeBuilder(BuildContext context) {
    switch (context.screenSize) {
      case WoltScreenSize.small:
        return WoltModalType.bottomSheet;
      case WoltScreenSize.large:
        return WoltModalType.dialog;
    }
  }

  void goToNextPage() {
    final currentState = state;
    if (currentState is PlaygroundSheetVisibleState) {
      pageIndexNotifier.value = pageIndexNotifier.value + 1;
      emit(
        PlaygroundSheetVisibleState(
          pageIndex: pageIndexNotifier.value,
          pathName: currentState.pathName,
        ),
      );
    }
  }

  void goToPreviousPage() {
    final currentState = state;
    if (currentState is PlaygroundSheetVisibleState) {
      if (pageIndexNotifier.value > 0) {
        pageIndexNotifier.value = pageIndexNotifier.value - 1;
        emit(
          PlaygroundSheetVisibleState(
            pageIndex: pageIndexNotifier.value,
            pathName: currentState.pathName,
          ),
        );
      }
    }
  }

  void closeSheet() {
    final currentState = state;
    if (currentState is PlaygroundSheetVisibleState) {
      pageIndexNotifier.value = 0;
      emit(const PlaygroundHomeScreenState());
    }
  }

  void onPathUpdated(MultiPagePathName pathName) {
    final currentState = state;
    if (currentState is PlaygroundSheetVisibleState) {
      pageListBuilderNotifier.value = pathName.pageListBuilder;
      pageIndexNotifier.value = 0;
      emit(
        PlaygroundSheetVisibleState(
          pageIndex: pageIndexNotifier.value,
          pathName: pathName,
        ),
      );
    }
  }

  void onButtonPressed() {
    final currentState = state;
    if (currentState is PlaygroundHomeScreenState) {
      emit(
        PlaygroundSheetVisibleState(
          pageIndex: pageIndexNotifier.value,
          pathName: MultiPagePathName.defaultPath,
        ),
      );
    }
  }
}
