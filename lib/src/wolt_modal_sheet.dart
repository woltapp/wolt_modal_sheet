import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_animated_switcher.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_modal_type_utils.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_modal_sheet_content_gesture_detector.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const int defaultWoltModalTransitionAnimationDuration = 350;

/// Signature for a function that builds a list of [SliverWoltModalSheetPage] based on the given [BuildContext].
typedef WoltModalSheetPageListBuilder = List<SliverWoltModalSheetPage> Function(
  BuildContext context,
);

/// Signature for a function that returns the [WoltModalType] based on the given [BuildContext].
typedef WoltModalTypeBuilder = WoltModalType Function(BuildContext context);

class WoltModalSheet<T> extends StatefulWidget {
  const WoltModalSheet({
    required this.pageListBuilderNotifier,
    required this.pageIndexNotifier,
    required this.onModalDismissedWithBarrierTap,
    required this.onModalDismissedWithDrag,
    required this.decorator,
    required this.modalTypeBuilder,
    required this.transitionAnimationController,
    required this.route,
    required this.enableDrag,
    required this.showDragHandle,
    required this.useSafeArea,
    super.key,
  });

  /// A ValueNotifier that holds a function to dynamically build the list of modal pages. It
  /// allows the page list to be updated in response to state changes.
  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;

  /// A ValueNotifier that holds the current index of the visible page
  /// within the modal. It enables index based dynamic navigation within the modal. If you want
  /// to handle in-modal navigation without considering page index, you can ignore providing this
  /// notifier and use in-modal navigation methods.
  final ValueNotifier<int> pageIndexNotifier;

  /// A callback that is triggered when the modal is dismissed by tapping the modal barrier.
  /// This is useful to sync the app state with the modal state when declarative navigation is
  /// used (a.k.a Navigator 2.0).
  final VoidCallback? onModalDismissedWithBarrierTap;

  /// A callback that is triggered when the modal is dismissed by a drag gesture. This is useful
  /// to sync the app state with the modal state when declarative navigation is used (a.k.a
  /// Navigator 2.0).
  final VoidCallback? onModalDismissedWithDrag;

  /// A function that takes a widget and returns a decorated version of that widget. This can be
  /// used to handle the state management of the modal from top level in the modal route.
  final Widget Function(Widget)? decorator;

  /// A builder function that determines the [WoltModalType] based on the provided BuildContext.
  /// This allows responsive design to switch between modal types as the screen size changes. For
  /// example, in large screens, the modal can be displayed as a dialog, while on smaller
  /// screens, it can be displayed as a bottom sheet.
  final WoltModalTypeBuilder? modalTypeBuilder;

  /// An optional AnimationController that can be used to control modal animations externally,
  /// providing fine-grained control over the modal's enter and exit animations.
  final AnimationController? transitionAnimationController;

  /// The modal sheet route associated with this modal.
  final WoltModalSheetRoute<T> route;

  /// A boolean that determines whether the modal can be dismissed by dragging. This provides a
  /// user-friendly way to dismiss the modal and is commonly used in bottom sheet modals.
  final bool? enableDrag;

  /// A boolean that indicates whether a drag handle should be shown at the top of the modal.
  /// This is often used as a visual cue for modals that can be dismissed by dragging.
  final bool? showDragHandle;

  /// A boolean that determines whether the modal should avoid system UI intrusions such as the
  /// notch and system gesture areas.
  final bool? useSafeArea;
  static const ParametricCurve<double> animationCurve = decelerateEasing;

  @override
  State<WoltModalSheet> createState() => WoltModalSheetState();

  /// Displays a Wolt Modal Sheet with a predefined list of pages.
  ///
  /// This method sets up and displays the modal sheet using the provided page list builder. It can
  /// be customized with various parameters such as modal type, animations, and behaviors like
  /// draggability and dismissibility.
  ///
  /// Parameters:
  ///   - `context`: [BuildContext] for locating the Navigator.
  ///   - `pageListBuilder`: Function that builds the list of pages to display. After providing
  ///   the initial list, the modal can be updated imperatively using the in-modal navigation
  ///   methods such as [pushPages], [addPages], [popPage], [removePage] etc.
  ///   - `modalTypeBuilder`: Optional builder for setting the [WoltModalType] based on context.
  ///   Useful for responsive design to switch between modal types as the screen size changes.
  ///   - `pageIndexNotifier`: Notifier for tracking and updating the index of the currently
  ///   visible page. If not provided, a new [ValueNotifier] will be created with the 0th index.
  ///   If you want to handle in-modal navigation without considering page index, you can ignore
  ///   providing this notifier.
  ///   - `decorator`: Optional widget function to decorate the modal content.
  ///   - `useRootNavigator`: Whether to use the root navigator for navigation.
  ///   - `useSafeArea`: Whether the modal should respect the safe area.
  ///   - `barrierDismissible`: Whether the modal can be dismissed by tapping the barrier.
  ///   - `enableDrag`: Whether the modal can be dismissed by dragging.
  ///   - `showDragHandle`: Whether to show a handle to indicate the modal can be dragged.
  ///   - `routeSettings`: Additional settings for the modal route.
  ///   - `transitionDuration`: Duration of the transition animations.
  ///   - `onModalDismissedWithBarrierTap`: Callback for when the modal is dismissed by tapping the barrier.
  ///   - `onModalDismissedWithDrag`: Callback for when the modal is dismissed by dragging.
  ///   - `transitionAnimationController`: Controller for custom transition animations.
  ///   - `modalBarrierColor`: Color of the modal barrier.
  ///
  /// Returns:
  ///   - A `Future` that resolves to the value returned when the modal is dismissed.
  static Future<T?> show<T>({
    required BuildContext context,
    required WoltModalSheetPageListBuilder pageListBuilder,
    WoltModalTypeBuilder? modalTypeBuilder,
    ValueNotifier<int>? pageIndexNotifier,
    Widget Function(Widget)? decorator,
    bool useRootNavigator = false,
    bool? useSafeArea,
    bool? barrierDismissible,
    bool? enableDrag,
    bool? showDragHandle,
    RouteSettings? routeSettings,
    Duration? transitionDuration,
    VoidCallback? onModalDismissedWithBarrierTap,
    VoidCallback? onModalDismissedWithDrag,
    AnimationController? transitionAnimationController,
    Color? modalBarrierColor,
  }) {
    return WoltModalSheet.showWithDynamicPath(
      context: context,
      pageListBuilderNotifier: ValueNotifier(pageListBuilder),
      modalTypeBuilder: modalTypeBuilder,
      pageIndexNotifier: pageIndexNotifier,
      decorator: decorator,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      barrierDismissible: barrierDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      routeSettings: routeSettings,
      transitionDuration: transitionDuration,
      onModalDismissedWithBarrierTap: onModalDismissedWithBarrierTap,
      onModalDismissedWithDrag: onModalDismissedWithDrag,
      transitionAnimationController: transitionAnimationController,
      modalBarrierColor: modalBarrierColor,
    );
  }

  /// Displays a Wolt Modal Sheet with dynamically adjustable paths or page lists.
  ///
  /// This advanced method allows for dynamic modification of the page list during the lifetime
  /// of the modal, supporting complex interactions and state-dependent page transitions.
  /// Although by using this method, you can update the page list in a declarative navigation
  /// pattern, the same can be achieved imperatively by calling the in-modal imperative
  /// navigation methods such as [addPages], [replacePage], [pushPages], [popPage], [showNext], etc.
  ///
  /// Parameters:
  ///   - `context`: BuildContext for locating the Navigator.
  ///   - `pageListBuilderNotifier`: Notifier for dynamically updating the list of pages.
  ///   - `modalTypeBuilder`: Optional builder for setting the modal type based on context.
  ///   - `pageIndexNotifier`: Notifier for tracking and updating the index of the currently visible page.
  ///   - `decorator`: Optional widget function to decorate the modal content.
  ///   - `useRootNavigator`: Whether to use the root navigator for navigation.
  ///   - `useSafeArea`: Whether the modal should respect the safe area.
  ///   - `barrierDismissible`: Whether the modal can be dismissed by tapping the barrier.
  ///   - `enableDrag`: Whether the modal can be dismissed by dragging.
  ///   - `showDragHandle`: Whether to show a handle to indicate the modal can be dragged.
  ///   - `routeSettings`: Additional settings for the modal route.
  ///   - `transitionDuration`: Duration of the transition animations.
  ///   - `onModalDismissedWithBarrierTap`: Callback for when the modal is dismissed by tapping the barrier.
  ///   - `onModalDismissedWithDrag`: Callback for when the modal is dismissed by dragging.
  ///   - `transitionAnimationController`: Controller for custom transition animations.
  ///   - `modalBarrierColor`: Color of the modal barrier.
  ///
  /// Returns:
  ///   - A `Future` that resolves to the value returned
  static Future<T?> showWithDynamicPath<T>({
    required BuildContext context,
    required ValueNotifier<WoltModalSheetPageListBuilder>
        pageListBuilderNotifier,
    WoltModalTypeBuilder? modalTypeBuilder,
    ValueNotifier<int>? pageIndexNotifier,
    Widget Function(Widget)? decorator,
    bool useRootNavigator = false,
    bool? useSafeArea,
    bool? barrierDismissible,
    bool? enableDrag,
    bool? showDragHandle,
    RouteSettings? routeSettings,
    Duration? transitionDuration,
    VoidCallback? onModalDismissedWithBarrierTap,
    VoidCallback? onModalDismissedWithDrag,
    AnimationController? transitionAnimationController,
    Color? modalBarrierColor,
  }) {
    final NavigatorState navigator =
        Navigator.of(context, rootNavigator: useRootNavigator);
    return navigator.push<T>(
      WoltModalSheetRoute<T>(
        decorator: decorator,
        pageIndexNotifier: pageIndexNotifier ?? ValueNotifier(0),
        pageListBuilderNotifier: pageListBuilderNotifier,
        modalTypeBuilder: modalTypeBuilder,
        routeSettings: routeSettings,
        barrierDismissible: barrierDismissible,
        enableDrag: enableDrag,
        showDragHandle: showDragHandle,
        onModalDismissedWithBarrierTap: onModalDismissedWithBarrierTap,
        onModalDismissedWithDrag: onModalDismissedWithDrag,
        transitionAnimationController: transitionAnimationController,
        useSafeArea: useSafeArea,
        modalBarrierColor: modalBarrierColor,
      ),
    );
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// WoltModalSheet.of(context).popPage()
  /// ```
  ///
  /// If there is no [WoltModalSheet] in the give `context`, this function will throw
  /// a [FlutterError] in debug mode, and an exception in release mode.
  ///
  /// This method can be expensive (it walks the element tree).
  static WoltModalSheetState of(BuildContext context) {
    // Handles the case where the input context is a navigator element.
    WoltModalSheetState? woltModalSheetState;
    if (context is StatefulElement && context.state is WoltModalSheetState) {
      woltModalSheetState = context.state as WoltModalSheetState;
    }
    woltModalSheetState ??=
        context.findAncestorStateOfType<WoltModalSheetState>();

    assert(() {
      if (woltModalSheetState == null) {
        throw FlutterError(
          'Operation requested with a context that does not include a WoltModalSheet.\n'
          'The context used to navigate with WoltModalSheetPage must be that of a widget that is a '
          'descendant of a WoltModalSheet widget.',
        );
      }
      return true;
    }());
    return woltModalSheetState!;
  }
}

class WoltModalSheetState extends State<WoltModalSheet> {
  List<SliverWoltModalSheetPage> _pages = [];

  Widget Function(Widget) get _decorator =>
      widget.decorator ?? (widget) => Builder(builder: (_) => widget);

  final GlobalKey _childKey = GlobalKey(debugLabel: 'Modal sheet child');

  static const barrierLayoutId = 'barrierLayoutId';

  static const contentLayoutId = 'contentLayoutId';

  int get _currentPageIndex => widget.pageIndexNotifier.value;

  set _currentPageIndex(int value) {
    widget.pageIndexNotifier.value = value;
  }

  @override
  void initState() {
    super.initState();
    widget.pageListBuilderNotifier
        .addListener(_onPageListBuilderNotifierValueUpdated);
  }

  @override
  void dispose() {
    widget.pageListBuilderNotifier
        .removeListener(_onPageListBuilderNotifierValueUpdated);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pages.isEmpty) {
      // Get the initial page list from the initially provided pageListBuilder.
      final initialPages = widget.pageListBuilderNotifier.value(context);
      assert(initialPages.isNotEmpty,
          'pageListBuilder must return a non-empty list.');
      _pages = initialPages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final modalType =
        WoltModalTypeUtils.currentModalType(widget.modalTypeBuilder, context);

    return ValueListenableBuilder(
      valueListenable: widget.pageIndexNotifier,
      builder: (context, currentPageIndex, __) {
        final pages = _pages;
        final page = pages[currentPageIndex];
        final enableDrag = page.enableDrag ??
            widget.enableDrag ??
            modalType.isDragToDismissEnabled ??
            themeData?.enableDrag ??
            defaultThemeData.enableDrag;
        final showDragHandle = widget.showDragHandle ??
            modalType.showDragHandle ??
            (enableDrag &&
                (themeData?.showDragHandle ?? defaultThemeData.showDragHandle));
        final shadowColor =
            themeData?.shadowColor ?? defaultThemeData.shadowColor;
        final pageBackgroundColor = page.backgroundColor ??
            themeData?.backgroundColor ??
            defaultThemeData.backgroundColor;
        final surfaceTintColor = page.surfaceTintColor ??
            themeData?.surfaceTintColor ??
            defaultThemeData.surfaceTintColor;
        final modalElevation =
            themeData?.modalElevation ?? defaultThemeData.modalElevation;
        final clipBehavior =
            themeData?.clipBehavior ?? defaultThemeData.clipBehavior;
        final resizeToAvoidBottomInset = page.resizeToAvoidBottomInset ??
            themeData?.resizeToAvoidBottomInset ??
            defaultThemeData.resizeToAvoidBottomInset;
        final useSafeArea = page.useSafeArea ??
            widget.useSafeArea ??
            themeData?.useSafeArea ??
            defaultThemeData.useSafeArea;

        final multiChildLayout = CustomMultiChildLayout(
          delegate: _WoltModalMultiChildLayoutDelegate(
            contentLayoutId: contentLayoutId,
            barrierLayoutId: barrierLayoutId,
            modalType: modalType,
            textDirection: Directionality.of(context),
          ),
          children: [
            LayoutId(
              id: barrierLayoutId,
              child: GestureDetector(
                excludeFromSemantics: true,
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.route.barrierDismissible) {
                    final onModalDismissedWithBarrierTap =
                        widget.onModalDismissedWithBarrierTap;
                    if (onModalDismissedWithBarrierTap != null) {
                      onModalDismissedWithBarrierTap();
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const SizedBox.expand(),
              ),
            ),
            LayoutId(
              id: contentLayoutId,
              child: _decorator(
                KeyedSubtree(
                  key: _childKey,
                  child: Semantics(
                    label: modalType.routeLabel(context),
                    child: WoltModalSheetContentGestureDetector(
                      route: widget.route,
                      enableDrag: enableDrag,
                      modalContentKey: _childKey,
                      onModalDismissedWithDrag: widget.onModalDismissedWithDrag,
                      modalType: modalType,
                      child: Material(
                        color: pageBackgroundColor,
                        elevation: modalElevation,
                        surfaceTintColor: surfaceTintColor,
                        shadowColor: shadowColor,
                        shape: modalType.shapeBorder,
                        clipBehavior: clipBehavior,
                        child: LayoutBuilder(
                          builder: (_, constraints) {
                            return modalType.decoratePageContent(
                              context,
                              WoltModalSheetAnimatedSwitcher(
                                woltModalType: modalType,
                                pageIndex: currentPageIndex,
                                pages: pages,
                                sheetWidth: constraints.maxWidth,
                                showDragHandle: showDragHandle,
                              ),
                              useSafeArea,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
        return Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: Colors.transparent,
          body: modalType.decorateModal(
            context,
            multiChildLayout,
            useSafeArea,
          ),
        );
      },
    );
  }

  void _onPageListBuilderNotifierValueUpdated() {
    if (context.mounted) {
      setState(() {
        final pages = widget.pageListBuilderNotifier.value(context);
        assert(
            pages.isNotEmpty, 'pageListBuilder must return a non-empty list.');
        _pages
          ..clear()
          ..addAll(pages);
      });
    }
  }

  /// Adds one or more new pages to the modal sheet stack without making them the current view.
  ///
  /// This method appends one or multiple [SliverWoltModalSheetPage] to the navigation stack but does
  /// not change the current page displayed. It's useful for preloading pages or managing
  /// the stack without immediately affecting the user interface.
  ///
  /// Parameters:
  /// - [pages]: The List of [SliverWoltModalSheetPage] to be added to the stack. Can also be a single page.
  void addPages(List<SliverWoltModalSheetPage> pages) {
    _pages = List<SliverWoltModalSheetPage>.from(_pages)..addAll(pages);
  }

  /// Overload of [addPages] for adding a single page.
  ///
  /// Parameters:
  /// - [page]: The single [SliverWoltModalSheetPage] to be added to the stack.
  void addPage(SliverWoltModalSheetPage page) {
    addPages([page]);
  }

  /// Dynamically updates the navigation stack by adding new pages or replacing subsequent pages
  /// depending on the current page's position in the stack.
  ///
  /// If the current page is the last in the stack, this method appends the new pages. If the current
  /// page is not the last, it replaces all pages after the current one with the provided list of new pages.
  /// This approach is particularly useful in scenarios where the user's navigation path needs dynamic
  /// updates based on interactions on the last page or when revising choices made in previous steps.
  ///
  /// Parameters:
  /// - [pages]: The list of [SliverWoltModalSheetPage] to be appended or to replace existing pages.
  ///   This can be a single page or multiple pages.
  ///
  /// Throws:
  ///   - [ArgumentError]: If `pages` is empty.
  ///
  /// Returns:
  /// None.
  void addOrReplacePages(List<SliverWoltModalSheetPage> pages) {
    if (_currentPageIndex == _pages.length - 1) {
      // Append new pages if the current page is the last one.
      _pages = List<SliverWoltModalSheetPage>.from(_pages)..addAll(pages);
    } else {
      // Replace all pages beyond the current one with new pages.
      _pages = List<SliverWoltModalSheetPage>.from(
          _pages.take(_currentPageIndex + 1))
        ..addAll(pages);
    }
  }

  /// Overload of [addOrReplaceLastPages] for adding a single page.
  ///
  /// Parameters:
  /// - [page]: The single [SliverWoltModalSheetPage] to be added or to replace the last page.
  ///
  /// Returns:
  /// None.
  void addOrReplacePage(SliverWoltModalSheetPage page) {
    return addOrReplacePages([page]);
  }

  /// Adds one or more new pages to the modal sheet stack and displays the first of the added
  /// page list.
  ///
  /// This method pushes a list of [SliverWoltModalSheetPage] onto the navigation stack,
  /// adding them to the end. It then updates the displayed page to be the first page in the newly added list,
  /// allowing for a sequence of pages to be added and immediately interacted with.
  ///
  /// Parameters:
  /// - [pages]: The list of [SliverWoltModalSheetPage] to add to the navigation stack.
  ///
  /// Throws:
  ///   - [ArgumentError]: If `pages` is empty.
  ///
  /// Returns:
  /// None.
  void pushPages(List<SliverWoltModalSheetPage> pages) {
    if (pages.isEmpty) {
      throw ArgumentError('pages must not be empty.');
    }

    _pages = List<SliverWoltModalSheetPage>.from(_pages)..addAll(pages);
    // Set the page index to the first of the newly added pages.
    _currentPageIndex = _pages.length - pages.length;
  }

  /// Adds a new page to the modal sheet stack and displays it.
  ///
  /// This method pushes a new [SliverWoltModalSheetPage] onto the navigation stack,
  /// making it the visible page.
  ///
  /// Parameters:
  /// - [page]: The [SliverWoltModalSheetPage] to add to the navigation stack.
  ///
  /// Returns:
  /// None.
  void pushPage(SliverWoltModalSheetPage page) {
    pushPages([page]);
  }

  /// Removes the top page from the modal sheet stack.
  ///
  /// This method pops the top [SliverWoltModalSheetPage] from the navigation stack.
  /// If there's only one page left in the stack, this operation will not remove it,
  /// ensuring that there's always at least one page displayed.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if a page was successfully removed; `false` if the stack
  ///   had only one page left.
  bool popPage() {
    if (_pages.length > 1) {
      _pages = List<SliverWoltModalSheetPage>.from(_pages)..removeLast();
      // Adjust the current page index if the removed page is the current page.
      if (_currentPageIndex == _pages.length) {
        _currentPageIndex--;
      }
      return true;
    }
    return false;
  }

  /// Removes a specified page from the modal navigation stack based on its identifier.
  ///
  /// This method searches for a page with a given ID and removes it from the stack.
  /// If the page to be removed is the current page, the method adjusts the displayed page:
  /// if it's the first page, it transitions to the next page; otherwise, it transitions to the previous page.
  /// If the removed page is not the current one, it is simply removed from the stack without affecting the
  /// currently displayed page. If removing the page affects the order, the selected page index is adjusted
  /// to maintain a valid state.
  ///
  /// Parameters:
  ///   - id: The identifier of the page to remove. [SliverWoltModalSheetPage.id]
  ///
  /// Returns:
  ///   - `bool`: True if the page was successfully removed; otherwise, false. This method also
  ///     returns false if there's only one page left in the stack, as at least one page must
  ///     always be present.
  ///
  /// Usage Example:
  /// ```dart
  /// bool result = modalSheetController.removePage(pageId);
  /// if (result) {
  ///   print("Page removed successfully.");
  /// } else {
  ///   print("Failed to remove page or page not found.");
  /// }
  /// ```
  ///
  /// This method ensures that the navigation stack's integrity is preserved by adjusting
  /// indices appropriately and managing the visibility of pages dynamically. It updates the
  /// state of the application to reflect these changes if necessary.
  bool removePage(Object id) {
    // Check if there are more than one page in the stack
    if (_pages.length > 1) {
      final currentPages = List<SliverWoltModalSheetPage>.from(_pages);
      final index = currentPages.indexWhere((p) => p.id == id);
      final wasCurrentPage = index == _currentPageIndex;

      // Check if the page was not found
      if (index == -1) {
        return false;
      }

      if (wasCurrentPage) {
        if (index == 0) {
          // If the page to remove is the current page and it's the first page, first show the
          // next page, then remove the page from the stack.
          showNext();
          currentPages.removeAt(index);
          _pages = currentPages;
          _currentPageIndex = 0;
        } else {
          // If the page to remove is the current page first show the previous page, then remove the
          // page from the stack.
          showPrevious();
          currentPages.removeAt(index);
          _pages = currentPages;
        }
        return true;
      } else {
        // If the page to remove is not the current page
        currentPages.removeAt(index);
        _pages = currentPages;

        // Adjust the current page index if the removed page is before the current page
        if (index < _currentPageIndex) {
          _currentPageIndex--;
        }

        // No need to call setState since the current page remains visible
        return true;
      }
    }

    // Return false if there's only one page left or other conditions are not met
    return false;
  }

  /// Removes all pages following the page identified by the specified [id].
  ///
  /// This method truncates the navigation stack by removing all pages after the page with the given [id].
  /// If the page with the [id] is not found or is currently visible, no changes are made to the stack.
  ///
  /// Parameters:
  ///   - [id]: Identifier of the page up to which (exclusive) pages should be retained.
  ///
  /// Returns:
  ///  - `bool`: True if the pages were successfully removed; otherwise, false. This method also
  ///  returns false if the page with the specified [id] is not found or is currently visible.
  bool removeUntil(Object id) {
    final indexToStopRemoving = _pages.indexWhere((p) => p.id == id);
    if (indexToStopRemoving == -1 || indexToStopRemoving == _currentPageIndex) {
      return false;
    }
    final sublist = List<SliverWoltModalSheetPage>.from(_pages)
        .sublist(0, indexToStopRemoving + 1);
    _pages = sublist;
    // Update the indexToStopRemoving if the removed page is before the current page.
    if (indexToStopRemoving < _currentPageIndex) {
      // The page will be re-built due to index change. Hence, not calling setState.
      _currentPageIndex = indexToStopRemoving;
    } else {
      // The page will not be re-built because the index is the same so we need to trigger the
      // rebuild.
      setState(() {});
    }
    return true;
  }

  /// Replaces a specific page identified by the [id] of the [SliverWoltModalSheetPage] with a
  /// new page [page]. If no page with the specified [id] is found, nothing happens.
  ///
  /// Parameters:
  /// - [id]: The [id] of the [SliverWoltModalSheetPage] in the stack to replace.
  /// - [page]: The new [SliverWoltModalSheetPage] to insert in place of the old one.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if replacing  page was successful, `false` if no page with the
  /// specified [id] is found.
  bool replacePage(Object id, SliverWoltModalSheetPage page) {
    final index = _pages.indexWhere((p) => p.id == id);
    if (index == -1) {
      return false;
    } else if (index == _currentPageIndex) {
      replaceCurrentPage(page);
      return true;
    } else {
      // Replace the page in the list.
      final currentPages = List<SliverWoltModalSheetPage>.from(_pages);
      currentPages[index] = page;
      _pages = currentPages;
      return true;
    }
  }

  /// Replaces the current page with a new one, using a pagination animation.
  ///
  /// Use this method when the current page needs to be removed from the page list and replaced
  /// by a new page, with a pagination animation at the same position in the list.
  ///
  /// Parameters:
  /// - [newPage]: The [SliverWoltModalSheetPage] that will replace the current page.
  ///
  /// Usage Note:
  /// For a non-animated update of the current page's properties, use [updateCurrentPage].
  ///
  /// Returns:
  /// None.
  void replaceCurrentPage(SliverWoltModalSheetPage newPage) {
    setState(() {
      _pages = List<SliverWoltModalSheetPage>.from(_pages);
      _pages[_currentPageIndex] = newPage; // Replace the current page
    });
  }

  /// Updates the properties of the current page immediately, without pagination animation.
  ///
  /// Use this method when the context of the current page remains the same but needs modifications
  /// to specific attributes. This is achieved through a function that takes the current page and
  /// returns a modified version of it.
  ///
  /// Parameters:
  /// - [updateFunction]: A function that takes the current [SliverWoltModalSheetPage] and returns
  ///   a new instance with updated properties.
  ///
  /// Usage Note:
  /// For replacing the current page with a new one including pagination animation, use
  /// [replaceCurrentPage].
  ///
  /// Example:
  /// ```dart
  /// WoltModalSheet.of(context).updateCurrentPage((currentPage) {
  ///   return currentPage.copyWith(
  ///     enableDrag: true,
  ///     hasTopBarLayer: false,
  ///     // Other updated properties...
  ///   );
  /// });
  /// ```
  ///
  /// Use [SliverWoltModalSheetPage.copyWithChild] method to update the page if the page type is
  /// extended from [SliverWoltModalSheetPage] such as [WoltModalSheetPage] or
  /// [NonScrollingWoltModalSheetPage] and you want to replace the main content of the page with
  /// a single [child] Widget.
  ///
  /// Example:
  /// ```dart
  /// WoltModalSheet.of(context).updateCurrentPage((currentPage) {
  ///   return currentPage.copyWithChild(
  ///     child: UpdatedChildWidget(),
  ///     hasTopBarLayer: false,
  ///     // Other updated properties...
  ///   );
  /// });
  /// ```
  ///
  /// Returns:
  /// None.
  void updateCurrentPage(
      SliverWoltModalSheetPage Function(SliverWoltModalSheetPage)
          updateFunction) {
    setState(() {
      _pages[_currentPageIndex] = updateFunction(_pages[_currentPageIndex]);
    });
  }

  /// Replaces the existing navigation stack with a new list of pages.
  ///
  /// This method updates the navigation stack to the provided list of pages. It adjusts the
  /// selected page index to retain the current page's relative position within the stack
  /// as much as possible. If the `selectedPageIndex` specifies a position that exceeds the bounds of the
  /// new list, the selected page will default to the last page in the new list. This adjustment ensures
  /// that the navigation stack always points to a valid page.
  ///
  /// An error is thrown if the new list of pages (`newPages`) is empty, as the navigation stack cannot be empty.
  ///
  /// Parameters:
  ///   - `newPages`: The new list of [SliverWoltModalSheetPage] to be set as the navigation stack.
  ///   - `selectedPageIndex`: The index of the page that should be selected after the update. If
  ///   not provided, the current selected page index will be used. If the provided index exceeds
  ///   the bounds of the new list, the selected page will default to the last page in the new list.
  ///
  /// Throws:
  ///   - [ArgumentError]: If `newPages` is empty.
  ///
  /// Returns:
  ///   This method does not return a value.
  void replaceAllPages(List<SliverWoltModalSheetPage> newPages,
      {int? selectedPageIndex}) {
    if (newPages.isEmpty) {
      throw ArgumentError('newPages must not be empty.');
    }

    // Make sure selectedPageIndex is within the bounds of the new list.
    if (selectedPageIndex != null &&
        (selectedPageIndex >= newPages.length || selectedPageIndex < 0)) {
      throw ArgumentError(
          'selectedPageIndex must be within the bounds of the newPages list.');
    }

    setState(() {
      _pages = List<SliverWoltModalSheetPage>.from(newPages);
      final newPageIndex = selectedPageIndex ?? _currentPageIndex;
      // Ensure the selected page index is within the bounds of the new list.
      _currentPageIndex = min(newPageIndex, _pages.length - 1);
    });
  }

  /// Advances to the next page in the modal sheet if one exists.
  ///
  /// This method navigates to the next page in the modal sheet's stack. If the current page is
  /// the last one in the stack, this method will do nothing to prevent out-of-bounds errors. It
  /// ensures that navigation requests are safely bounded within the limits of the existing pages.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if the navigation to the next page was successful, `false` if
  ///   already on the last page and navigation did not occur.
  bool showNext() {
    if (_currentPageIndex < _pages.length - 1) {
      _currentPageIndex = _currentPageIndex + 1;
      return true;
    }
    return false; // No navigation occurred, already at the last page.
  }

  /// Navigates to the previous page in the modal sheet if one exists.
  ///
  /// This method navigates back to the previous page in the modal sheet's stack. If the current
  /// page is the first one in the stack, this method will do nothing to ensure navigation
  /// remains within valid bounds.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if the navigation to the previous page was successful, `false` if
  ///   already on the first page and navigation did not occur.
  bool showPrevious() {
    if (_currentPageIndex > 0) {
      _currentPageIndex = _currentPageIndex - 1;
      return true;
    }
    return false; // No navigation occurred, already at the first page.
  }

  /// Navigates to a page at a specific index in the modal sheet's stack.
  ///
  /// This method allows for direct navigation to any page by specifying its index in the stack.
  /// If the specified index is out of bounds, no navigation will occur.
  ///
  /// Parameters:
  ///   - [index]: The index of the page to navigate to.
  ///
  /// Returns:
  ///   - [bool]: Returns `true` if the navigation to the specified index was successful, `false` if
  ///     the index is out of the navigation stack's bounds.
  bool showAtIndex(int index) {
    if (index < _pages.length && index >= 0) {
      _currentPageIndex = index;
      return true;
    }
    return false; // No navigation occurred, already at the last page.
  }

  /// Navigates to a page identified by its unique identifier within the modal sheet's stack.
  ///
  /// This method facilitates navigation to a page based on its [SliverWoltModalSheetPage.id]. If
  /// no page with the specified ID is found, no navigation will occur.
  ///
  /// Parameters:
  ///   - [pageId]: The unique identifier of the page to navigate to.
  ///
  /// Returns:
  ///   - [bool]: Returns `true` if navigation to the page was successful, `false` if no page
  ///   with the specified ID is found in the stack.
  bool showPageWithId(Object pageId) {
    final index = _pages.indexWhere((p) => p.id == pageId);
    if (index != -1) {
      _currentPageIndex = index;
      return true;
    }
    return false;
  }

  /// The index of the currently displayed page in the in-modal navigation stack.
  int get currentPageIndex => _currentPageIndex;
}

class _WoltModalMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  final String contentLayoutId;
  final String barrierLayoutId;
  final WoltModalType modalType;
  final TextDirection textDirection;

  _WoltModalMultiChildLayoutDelegate({
    required this.contentLayoutId,
    required this.barrierLayoutId,
    required this.modalType,
    required this.textDirection,
  });

  @override
  void performLayout(Size size) {
    layoutChild(
      barrierLayoutId,
      BoxConstraints(maxWidth: size.width, maxHeight: size.height),
    );
    final modalContentSize = layoutChild(
      contentLayoutId,
      modalType.layoutModal(size),
    );
    positionChild(barrierLayoutId, Offset.zero);
    positionChild(
      contentLayoutId,
      modalType.positionModal(size, modalContentSize, textDirection),
    );
  }

  @override
  bool shouldRelayout(
      covariant _WoltModalMultiChildLayoutDelegate oldDelegate) {
    return oldDelegate.modalType != modalType;
  }
}
