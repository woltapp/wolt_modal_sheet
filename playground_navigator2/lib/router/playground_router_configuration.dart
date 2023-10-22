import 'package:playground_navigator2/modal/pages/multi_page_path_name.dart';

class PlaygroundRouterConfiguration {
  final MultiPagePathName? multiPagePathName;
  final bool isUnknown;
  final int pageIndex;

  PlaygroundRouterConfiguration._({
    this.multiPagePathName,
    this.isUnknown = false,
    this.pageIndex = 0,
  });

  factory PlaygroundRouterConfiguration.home() =>
      PlaygroundRouterConfiguration._();

  factory PlaygroundRouterConfiguration.unknown() =>
      PlaygroundRouterConfiguration._(isUnknown: true);

  factory PlaygroundRouterConfiguration.modalSheet({
    required MultiPagePathName multiPagePathName,
    required int index,
  }) =>
      PlaygroundRouterConfiguration._(
        multiPagePathName: multiPagePathName,
        pageIndex: index,
      );

  bool get isHomePage => multiPagePathName == null && !isUnknown;

  bool get isSheetPage => multiPagePathName != null && !isUnknown;
}
