/// Class describing the path to navigate inside modal sheet.
/// An every instance of this class means a concrete intent to show a
/// corresponding page for the [path] with passed [arguments] to it.
class WoltModalSheetPath {
  /// The name of the path (e.g., "/settings").
  final String path;

  /// The arguments should be used within the path.
  final Object? arguments;

  /// Creates an instance of [WoltModalSheetPath].
  const WoltModalSheetPath({
    required this.path,
    this.arguments,
  });
}
