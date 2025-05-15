import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/utils/soft_keyboard_closed_event.dart';

/// Mixin [WoltKeyboardClosureListenerMixin] adds functionality to track the soft keyboard's
/// visibility within the application lifecycle. It leverages the [WidgetsBindingObserver]
/// to monitor changes in the UI metrics, particularly to detect when the keyboard is shown
/// or hidden.
///
/// When the keyboard transitions from visible to hidden, the mixin updates a [ValueNotifier]
/// with a new [SoftKeyboardClosedEvent], incrementing an event ID to signal that the keyboard
/// has closed. This can be used to trigger updates or actions when the keyboard hides,
/// such as resizing layouts or adjusting UI elements.
///
/// To use this mixin, include it in any [State] class of a [StatefulWidget] and ensure
/// to call `super.initState()` and `super.dispose()` to correctly manage the mixin's lifecycle.
mixin WoltKeyboardClosureListenerMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  bool _keyboardWasVisible = false;
  late ValueNotifier<SoftKeyboardClosedEvent> _keyboardClosedNotifier;

  /// Initializes the state, setting up the observer and initializing the notifier.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _keyboardClosedNotifier = ValueNotifier(const SoftKeyboardClosedEvent(
      eventId: 0,
    )); // Provide an appropriate initial event ID.
  }

  /// Cleans up by removing the observer to avoid memory leaks.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Reacts to changes in system metrics, particularly those affecting the bottom
  /// view inset, which typically represents the soft keyboard. If the keyboard
  /// was previously visible and is now hidden, it increments the event ID and updates
  /// the notifier.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    bool keyboardVisible = viewInsets > 0;

    if (_keyboardWasVisible && !keyboardVisible) {
      final int lastEventId = _keyboardClosedNotifier.value.eventId;
      final newEventId = lastEventId + 1;
      _keyboardClosedNotifier.value =
          SoftKeyboardClosedEvent(eventId: newEventId);
    }

    _keyboardWasVisible = keyboardVisible;
  }

  /// Returns a `ValueNotifier<SoftKeyboardClosedEvent>` to provide access to the notifier
  /// from the widget tree, allowing other widgets to listen and react to keyboard closure events.
  ValueListenable<SoftKeyboardClosedEvent> get softKeyboardClosureListenable =>
      _keyboardClosedNotifier;
}
