import 'package:playground_navigator2/modal/pages/multi_page_path_name.dart';

class PlaygroundRouterConfiguration {
  final MultiPagePathName? multiPagePathName;
  final bool isUnknown;
  final int pageIndex;

  const PlaygroundRouterConfiguration._({
    this.multiPagePathName,
    this.isUnknown = false,
    this.pageIndex = 0,
  });

  factory PlaygroundRouterConfiguration.home() =>
      const PlaygroundRouterConfiguration._();

  factory PlaygroundRouterConfiguration.unknown() =>
      const PlaygroundRouterConfiguration._(isUnknown: true);

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
