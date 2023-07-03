import 'package:equatable/equatable.dart';
import 'package:playground_navigator2/modal/pages/multi_page_path_name.dart';

abstract class RouterState extends Equatable {
  const RouterState();

  @override
  List<Object?> get props => [];
}

class UnknownScreenVisibleState extends RouterState {
  const UnknownScreenVisibleState();

  @override
  List<Object?> get props => [];
}

class HomeScreenVisibleState extends RouterState {
  const HomeScreenVisibleState();

  @override
  List<Object?> get props => [];
}

class ModalSheetVisibleState extends RouterState {
  const ModalSheetVisibleState({
    required this.pageIndex,
    required this.pathName,
  });

  final int pageIndex;
  final MultiPagePathName pathName;

  @override
  List<Object?> get props => [pageIndex, pathName];
}
