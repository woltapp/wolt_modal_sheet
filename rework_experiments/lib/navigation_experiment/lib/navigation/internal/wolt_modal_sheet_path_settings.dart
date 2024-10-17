import 'package:flutter/material.dart';

/// A function returns [Page] built with arguments from the concrete intent to
/// show a page.
typedef WoltModalSheetPageBuilder = Page Function(Object? data);

/// An object describes relations between the [path] and a corresponding
/// [Page] for it.
///
/// Example:
///
/// With settings
/// WoltModalSheetPathSettings(
///     path: 'first',
///     pageBuilder: (_) => WoltModalSheetPage(
///         child: const First(),
///     ),
/// )
///
/// and the path '/first/first/second/first'
///
/// for every part of the path that matched with 'first' should be created
/// a page with WoltModalSheet transition style, that shows the 'First' widget.
class WoltModalSheetPathSettings {
  final String path;
  final WoltModalSheetPageBuilder pageBuilder;

  const WoltModalSheetPathSettings({
    required this.path,
    required this.pageBuilder,
  });
}
