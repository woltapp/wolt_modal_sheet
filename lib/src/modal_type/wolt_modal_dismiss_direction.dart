import 'package:wolt_modal_sheet/src/wolt_modal_sheet.dart';

/// The direction in which a [WoltModalSheet] can be dismissed when drag to dismiss is enabled.
enum WoltModalDismissDirection {
  /// The [WoltModalSheet] can be dismissed by dragging in the reverse of the
  /// reading direction (e.g., from right to left in left-to-right languages).
  endToStart,

  /// The [WoltModalSheet] can be dismissed by dragging in the reading direction
  /// (e.g., from left to right in left-to-right languages).
  startToEnd,

  /// The [WoltModalSheet] can be dismissed by dragging up only.
  up,

  /// The [WoltModalSheet] can be dismissed by dragging down only.
  down,

  /// The [WoltModalSheet] cannot be dismissed by dragging.
  none;

  bool get isUp => this == WoltModalDismissDirection.up;

  bool get isDown => this == WoltModalDismissDirection.down;

  bool get isVertical => isUp || isDown;

  bool get isStartToEnd => this == WoltModalDismissDirection.startToEnd;

  bool get isEndToStart => this == WoltModalDismissDirection.endToStart;

  bool get isHorizontal => isStartToEnd || isEndToStart;
}
