import 'package:equatable/equatable.dart';
import 'package:playground_navigator2/modal/pages/multi_page_path_name.dart';

abstract class PlaygroundState extends Equatable {
  const PlaygroundState();

  @override
  List<Object?> get props => [];
}

class PlaygroundUnknownScreenState extends PlaygroundState {
  const PlaygroundUnknownScreenState();

  @override
  List<Object?> get props => [];
}

class PlaygroundHomeScreenState extends PlaygroundState {
  const PlaygroundHomeScreenState();

  @override
  List<Object?> get props => [];
}

class PlaygroundSheetVisibleState extends PlaygroundState {
  const PlaygroundSheetVisibleState({
    required this.pageIndex,
    required this.pathName,
  });

  final int pageIndex;
  final MultiPagePathName pathName;

  @override
  List<Object?> get props => [pageIndex, pathName];
}
