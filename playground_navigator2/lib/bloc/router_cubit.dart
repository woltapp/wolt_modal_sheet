import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/router_state.dart';
import 'package:playground_navigator2/modal/pages/multi_page_path_name.dart';

class RouterCubit extends Cubit<RouterState> {
  RouterCubit() : super(const HomeScreenVisibleState());

  void goToPage(int pageIndex) {
    final currentState = state;
    if (currentState is ModalSheetVisibleState) {
      emit(
        ModalSheetVisibleState(
            pageIndex: pageIndex, pathName: currentState.pathName),
      );
    }
  }

  void closeSheet() {
    final currentState = state;
    if (currentState is ModalSheetVisibleState) {
      emit(const HomeScreenVisibleState());
    }
  }

  void onPathUpdated(MultiPagePathName pathName) {
    final currentState = state;
    if (currentState is ModalSheetVisibleState) {
      emit(ModalSheetVisibleState(
          pageIndex: currentState.pageIndex, pathName: pathName));
    }
  }

  void onPathAndPageIndexUpdated(MultiPagePathName pathName, int pageIndex) {
    emit(ModalSheetVisibleState(pageIndex: pageIndex, pathName: pathName));
  }

  void onShowModalSheetButtonPressed() {
    final currentState = state;
    if (currentState is HomeScreenVisibleState) {
      emit(
        const ModalSheetVisibleState(
            pageIndex: 0, pathName: MultiPagePathName.defaultPath),
      );
    }
  }

  void showOnUnknownScreen() => emit(const UnknownScreenVisibleState());
}
