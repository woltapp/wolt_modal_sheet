import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/wolt_modal_builder.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const int defaultWoltModalTransitionAnimationDuration = 350;

/// Signature for a function that builds a list of [WoltModalSheetPage] based on the given [BuildContext].
typedef WoltModalSheetPageListBuilder = List<WoltModalSheetPage> Function(BuildContext context);

/// Signature for a function that returns the [WoltModalType] based on the given [BuildContext].
typedef WoltModalTypeBuilder = WoltModalType Function(BuildContext context);

/// A utility class for displaying a Wolt modal sheet.
class WoltModalSheet {
  WoltModalSheet._();

  static const woltScrollableModalRouteName = 'woltScrollableModalRouteName';

  /// Displays a Wolt modal sheet and returns the value from the modal.
  ///
  /// The [context] specifies the build context.
  ///
  /// The [pageListBuilderNotifier] is a [ValueNotifier] that holds a [WoltModalSheetPageListBuilder] function.
  /// It provides the pages to be displayed in the modal.
  ///
  /// The [modalTypeBuilder] is a [WoltModalTypeBuilder] function that determines the type of the modal.
  ///
  /// The [pageIndexNotifier] is an optional [ValueNotifier] that holds the initial page index to be displayed.
  /// If the modal has multiple pages, the [pageIndexNotifier] can be used to control the page index.
  /// If the modal has only one page, the [pageIndexNotifier] can be omitted.
  ///
  /// The [decorator] is an optional function that decorates the content widget of the modal.
  /// This is useful to decorate the modal content with provider ancestor for state management.
  ///
  /// The [useRootNavigator] specifies whether to use the root navigator.
  ///
  /// The [onDismissed] is a callback that will be invoked when the modal is closed. If the modal
  /// has [pageIndexNotifier], the [onDismissed] will be invoked when the index is smaller than 0.
  static Future<T?> show<T>({
    required BuildContext context,
    required ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier,
    required WoltModalTypeBuilder modalTypeBuilder,
    ValueNotifier<int>? pageIndexNotifier,
    Widget Function(Widget)? decorator,
    bool useRootNavigator = false,
    VoidCallback? onDismissed,
  }) {
    // TODO: This is a temporary solution to prevent the bottom sheet from being dragged
    // on large screens. This should be removed when the bottom sheet is redesigned to handle its
    // own drag gestures. The current behavior causes incorrect behavior when the screen size changes due to orientation change.
    final enabledDrag = modalTypeBuilder(context) == WoltModalType.bottomSheet;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: true,
      enableDrag: enabledDrag,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return WoltModalBuilder(
          decorator: decorator,
          onModalDismissedWithBarrierTap: onDismissed,
          pageIndexNotifier: pageIndexNotifier ?? ValueNotifier(0),
          pageListBuilderNotifier: pageListBuilderNotifier,
          modalTypeBuilder: modalTypeBuilder,
        );
      },
      routeSettings: const RouteSettings(name: woltScrollableModalRouteName),
      useRootNavigator: useRootNavigator,
      useSafeArea: true,
    );
  }
}
