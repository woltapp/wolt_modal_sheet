import 'package:flutter/material.dart';
import 'package:playground_navigator2/modal/pages/multi_page_path_name.dart';
import 'package:playground_navigator2/router/playground_router_configuration.dart';

class PlaygroundRouteInformationParser
    extends RouteInformationParser<PlaygroundRouterConfiguration> {
  const PlaygroundRouteInformationParser();

  static const sheetPageSegment = 'sheet';
  static const pathQueryParam = 'path';
  static const pageIndexQueryParam = 'pageIndex';

  @override
  Future<PlaygroundRouterConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) {
      return PlaygroundRouterConfiguration.home();
    } else if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == sheetPageSegment) {
        final queryParams = uri.queryParameters;
        if (queryParams.isEmpty) {
          return PlaygroundRouterConfiguration.modalSheet(
            multiPagePathName: MultiPagePathName.defaultPath,
            index: 0,
          );
        } else {
          final path = queryParams[pathQueryParam];
          final pageIndexText = queryParams[pageIndexQueryParam];
          final pageIndex =
              pageIndexText != null && int.tryParse(pageIndexText) != null
                  ? int.parse(pageIndexText)
                  : null;
          if (pageIndex != null &&
              path != null &&
              MultiPagePathName.isValidQueryParam(path, pageIndex)) {
            return PlaygroundRouterConfiguration.modalSheet(
              multiPagePathName: MultiPagePathName.defaultPath,
              index: pageIndex,
            );
          } else {
            return PlaygroundRouterConfiguration.modalSheet(
              multiPagePathName: MultiPagePathName.defaultPath,
              index: 0,
            );
          }
        }
      }
    }
    return PlaygroundRouterConfiguration.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(
      PlaygroundRouterConfiguration configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: '/unknown');
    } else if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    } else if (configuration.isSheetPage) {
      final path = configuration.multiPagePathName?.queryParamName;
      final pageIndex = configuration.pageIndex;
      return RouteInformation(
        location:
            '/$sheetPageSegment?$pathQueryParam=$path&$pageIndexQueryParam=$pageIndex',
      );
    } else {
      return null;
    }
  }
}
