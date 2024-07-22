import 'package:flutter/material.dart';

/// Builder for a navigation place.
typedef WoltModalSheetRouteBuilder = Page Function(Object? data);

/// Route for pages.
class WoltModalSheetRoute {
  final String name;
  final WoltModalSheetRouteBuilder pageBuilder;

  const WoltModalSheetRoute({
    required this.name,
    required this.pageBuilder,
  });
}
