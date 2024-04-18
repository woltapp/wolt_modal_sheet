import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_animated_switcher.dart';
import 'package:wolt_modal_sheet/src/multi_child_layout/wolt_modal_multi_child_layout_delegate.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/utils/bottom_sheet_suspended_curve.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _minFlingVelocity = 700.0;

const double _closeProgressThreshold = 0.5;

const int defaultWoltModalTransitionAnimationDuration = 350;

/// Signature for a function that builds a list of [SliverWoltModalSheetPage] based on the given [BuildContext].
typedef WoltModalSheetPageListBuilder = List<SliverWoltModalSheetPage> Function(
    BuildContext context);

/// Signature for a function that returns the [WoltModalType] based on the given [BuildContext].
typedef WoltModalTypeBuilder = WoltModalType Function(BuildContext context);

class WoltModalSheet<T> extends StatefulWidget {
  const WoltModalSheet({
    required this.pageListBuilder,
    required this.onModalDismissedWithBarrierTap,
    required this.onModalDismissedWithDrag,
    required this.decorator,
    required this.modalTypeBuilder,
    required this.animationController,
    required this.route,
    required this.enableDrag,
    required this.showDragHandle,
    required this.useSafeArea,
    this.minDialogWidth,
    this.maxDialogWidth,
    this.minPageHeight,
    this.maxPageHeight,
    super.key,
  });

  final WoltModalSheetPageListBuilder pageListBuilder;
  final VoidCallback? onModalDismissedWithBarrierTap;
  final VoidCallback? onModalDismissedWithDrag;
  final Widget Function(Widget)? decorator;
  final WoltModalTypeBuilder modalTypeBuilder;
  final AnimationController? animationController;
  final WoltModalSheetRoute<T> route;
  final bool? enableDrag;
  final bool? showDragHandle;
  final bool useSafeArea;
  final double? minDialogWidth;
  final double? maxDialogWidth;
  final double? minPageHeight;
  final double? maxPageHeight;

  static const ParametricCurve<double> animationCurve = decelerateEasing;

  @override
  State<WoltModalSheet> createState() => WoltModalSheetState();

  static Future<T?> show<T>({
    required BuildContext context,
    required WoltModalSheetPageListBuilder pageListBuilder,
    WoltModalTypeBuilder? modalTypeBuilder,
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
    AnimatedWidget? bottomSheetTransitionAnimation,
    AnimatedWidget? dialogTransitionAnimation,
    double? minDialogWidth,
    double? maxDialogWidth,
    double? minPageHeight,
    double? maxPageHeight,
    Color? modalBarrierColor,
  }) {
    final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    return navigator.push<T>(
      WoltModalSheetRoute<T>(
        decorator: decorator,
        pageListBuilder: pageListBuilder,
        modalTypeBuilder: modalTypeBuilder,
        routeSettings: routeSettings,
        transitionDuration: transitionDuration,
        barrierDismissible: barrierDismissible,
        enableDrag: enableDrag,
        showDragHandle: showDragHandle,
        onModalDismissedWithBarrierTap: onModalDismissedWithBarrierTap,
        onModalDismissedWithDrag: onModalDismissedWithDrag,
        transitionAnimationController: transitionAnimationController,
        useSafeArea: useSafeArea,
        bottomSheetTransitionAnimation: bottomSheetTransitionAnimation,
        dialogTransitionAnimation: dialogTransitionAnimation,
        maxDialogWidth: maxDialogWidth,
        minDialogWidth: minDialogWidth,
        maxPageHeight: maxPageHeight,
        minPageHeight: minPageHeight,
        modalBarrierColor: modalBarrierColor ?? themeData?.modalBarrierColor,
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
    WoltModalSheetState? wms;
    if (context is StatefulElement && context.state is WoltModalSheetState) {
      wms = context.state as WoltModalSheetState;
    }
    wms ??= context.findAncestorStateOfType<WoltModalSheetState>();

    assert(() {
      if (wms == null) {
        throw FlutterError(
          'Operation requested with a context that does not include a WoltModalSheet.\n'
          'The context used to navigate with WoltModalSheetPage must be that of a widget that is a '
          'descendant of a WoltModalSheet widget.',
        );
      }
      return true;
    }());
    return wms!;
  }

  /// Replaces the current page in the modal sheet stack with a new page.
  ///
  /// This method updates the navigation stack by replacing the page at the current index with
  /// a new [SliverWoltModalSheetPage]. It's particularly useful for updating the content of the
  /// current view without disrupting the overall navigation flow.
  ///
  /// Parameters:
  /// - [newPage]: The new [SliverWoltModalSheetPage] to replace the current page.
  ///
  /// Returns:
  /// None.
  void replaceCurrentPage(BuildContext context, SliverWoltModalSheetPage newPage) {
    WoltModalSheet.of(context).replaceCurrentPage(newPage);
  }


  /// Replaces the entire stack of pages with a new list of pages while attempting to retain
  /// the current page's relative position in the stack.
  ///
  /// If the new list of pages is shorter than the current position index, the display will adjust
  /// to show the last page of the new list. This ensures the user always sees a valid page.
  ///
  /// Parameters:
  /// - [newPages]: The new list of [SliverWoltModalSheetPage] to set as the new navigation stack.
  ///
  /// Returns:
  /// None.
  void replaceAllPages(BuildContext context, List<SliverWoltModalSheetPage> newPages) {
    WoltModalSheet.of(context).replaceAllPages(newPages);
  }

  /// Adds one or more new pages to the modal sheet stack without making them the current view.
  ///
  /// This method appends one or multiple [SliverWoltModalSheetPage] to the navigation stack but does
  /// not change the current page displayed. It's useful for preloading pages or managing
  /// the stack without immediately affecting the user interface.
  ///
  /// Parameters:
  /// - [pages]: The List of [SliverWoltModalSheetPage] to be added to the stack. Can also be a single page.
  void addPagesToStack(BuildContext context, List<SliverWoltModalSheetPage> pages) {
    WoltModalSheet.of(context).addPagesToStack(pages);
  }

  /// Overload of addPagesToStack for adding a single page.
  ///
  /// Parameters:
  /// - [page]: The single [SliverWoltModalSheetPage] to be added to the stack.
  void addPageToStack(BuildContext context, SliverWoltModalSheetPage page) {
    addPagesToStack(context, [page]);
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
  /// Returns:
  /// - [bool]: Returns `true` if the operation affects the stack, `false` if the stack is empty
  ///   and no operation was performed.
  bool addOrReplacePages(BuildContext context, List<SliverWoltModalSheetPage> pages) {
    return WoltModalSheet.of(context).addOrReplacePages(pages);
  }

  /// Overload of addOrReplaceLastPages for adding a single page.
  ///
  /// Parameters:
  /// - [page]: The single [SliverWoltModalSheetPage] to be added or to replace the last page.
  bool addOrReplacePage(BuildContext context, SliverWoltModalSheetPage page) {
    return addOrReplacePages(context, [page]);
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
  /// Returns:
  /// None.
  void pushPages(BuildContext context, List<SliverWoltModalSheetPage> pages) {
    return WoltModalSheet.of(context).pushPages(pages);
  }

  /// Adds a new page to the modal sheet stack and displays it.
  ///
  /// This method pushes a new [SliverWoltModalSheetPage] onto the navigation stack,
  /// making it the visible page. If the modal sheet is currently showing another page,
  /// that page will be transitioned by the new page.
  ///
  /// Parameters:
  /// - [page]: The [SliverWoltModalSheetPage] to add to the navigation stack.
  ///
  /// Returns:
  /// None.
  void pushPage(BuildContext context, SliverWoltModalSheetPage page) {
    return pushPages(context, [page]);
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
  bool popPage(BuildContext context) {
    return WoltModalSheet.of(context).popPage();
  }

  /// Replaces a specific page identified by [id] with a new page [page].
  ///
  /// Searches for a page with the given [id] and replaces it with the new [page]. If no page with
  /// the specified [id] is found, an error is thrown.
  ///
  /// Parameters:
  /// - [id]: The identifier of the page to replace.
  /// - [page]: The new [SliverWoltModalSheetPage] to insert in place of the old one.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if replacing  page was successful, `false` if no page with the
  /// specified [id] is found.
  bool replacePage(BuildContext context, Object id, SliverWoltModalSheetPage page) {
    return WoltModalSheet.of(context).replacePage(id, page);
  }

  /// Advances to the next page in the modal sheet if one exists.
  ///
  /// This method increments the index to navigate to the next page in the modal sheet's stack.
  /// If the current page is the last one in the stack, this method will do nothing to prevent
  /// out-of-bounds errors. It ensures that navigation requests are safely bounded within the
  /// limits of the existing pages.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if the navigation to the next page was successful, `false` if
  ///   already on the last page and navigation did not occur.
  bool showNext(BuildContext context) {
    return WoltModalSheet.of(context).showNext();
  }

  /// Navigates to the previous page in the modal sheet if one exists.
  ///
  /// This method decrements the index to navigate back to the previous page in the modal
  /// sheet's stack. If the current page is the first one in the stack, this method will do
  /// nothing to ensure navigation remains within valid bounds.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if the navigation to the previous page was successful, `false` if
  ///   already on the first page and navigation did not occur.
  bool showPrevious(BuildContext context) {
    return WoltModalSheet.of(context).showPrevious();
  }
}

class WoltModalSheetState extends State<WoltModalSheet> {
  late WoltModalType _modalType;
  List<SliverWoltModalSheetPage> _pages = [];

  ParametricCurve<double> animationCurve = decelerateEasing;

  Widget Function(Widget) get _decorator =>
      widget.decorator ?? (widget) => Builder(builder: (_) => widget);

  bool get _dismissUnderway => widget.animationController!.status == AnimationStatus.reverse;

  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  static const barrierLayoutId = 'barrierLayoutId';

  static const contentLayoutId = 'contentLayoutId';

  int _selectedPageIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _modalType = widget.modalTypeBuilder(context);
    if (_pages.isEmpty) {
      _pages = widget.pageListBuilder(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final String routeLabel = _modalType.routeLabel(context);
    return _decorator(
      // The order of the notifier builders matter because we want to use the same instance of
      // the page list whenever page index is updated.
      Builder(
        builder: (context) {
          final pages = _pages;
          assert(pages.isNotEmpty, 'pageListBuilder must return a non-empty list.');
          final page = pages[_selectedPageIndex];
          late ShapeBorder shape;
          switch (_modalType) {
            case WoltModalType.bottomSheet:
              shape = themeData?.bottomSheetShape ?? defaultThemeData.bottomSheetShape;
              break;
            case WoltModalType.dialog:
              shape = themeData?.dialogShape ?? defaultThemeData.dialogShape;
              break;
          }
          final enableDrag = _modalType == WoltModalType.bottomSheet &&
              (page.enableDrag ??
                  widget.enableDrag ??
                  themeData?.enableDrag ??
                  defaultThemeData.enableDrag);
          final showDragHandle = widget.showDragHandle ??
              (enableDrag && (themeData?.showDragHandle ?? defaultThemeData.showDragHandle));
          final pageBackgroundColor = page.backgroundColor ??
              themeData?.backgroundColor ??
              defaultThemeData.backgroundColor;
          final minPageHeight =
              widget.minPageHeight ?? themeData?.minPageHeight ?? defaultThemeData.minPageHeight;
          final maxPageHeight =
              widget.maxPageHeight ?? themeData?.maxPageHeight ?? defaultThemeData.maxPageHeight;
          final minDialogWidth =
              widget.minDialogWidth ?? themeData?.minDialogWidth ?? defaultThemeData.minDialogWidth;
          final maxDialogWidth =
              widget.maxDialogWidth ?? themeData?.maxDialogWidth ?? defaultThemeData.maxDialogWidth;
          final shadowColor = themeData?.shadowColor ?? defaultThemeData.shadowColor;
          final surfaceTintColor = page.surfaceTintColor ??
              themeData?.surfaceTintColor ??
              defaultThemeData.surfaceTintColor;
          final modalElevation = themeData?.modalElevation ?? defaultThemeData.modalElevation;
          final clipBehavior = themeData?.clipBehavior ?? defaultThemeData.clipBehavior;
          final resizeToAvoidBottomInset = page.resizeToAvoidBottomInset ??
              themeData?.resizeToAvoidBottomInset ??
              defaultThemeData.resizeToAvoidBottomInset;

          final multiChildLayout = CustomMultiChildLayout(
            delegate: WoltModalMultiChildLayoutDelegate(
              contentLayoutId: contentLayoutId,
              barrierLayoutId: barrierLayoutId,
              modalType: _modalType,
              minPageHeight: minPageHeight,
              maxPageHeight: maxPageHeight,
              minDialogWidth: minDialogWidth,
              maxDialogWidth: maxDialogWidth,
            ),
            children: [
              LayoutId(
                id: barrierLayoutId,
                child: GestureDetector(
                  excludeFromSemantics: true,
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (widget.route.barrierDismissible) {
                      final onModalDismissedWithBarrierTap = widget.onModalDismissedWithBarrierTap;
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
                child: KeyedSubtree(
                  key: _childKey,
                  child: Semantics(
                    label: routeLabel,
                    child: GestureDetector(
                      excludeFromSemantics: true,
                      onVerticalDragStart: enableDrag ? _handleDragStart : null,
                      onVerticalDragUpdate: enableDrag ? _handleDragUpdate : null,
                      onVerticalDragEnd: enableDrag ? _handleDragEnd : null,
                      child: Material(
                        color: pageBackgroundColor,
                        elevation: modalElevation,
                        surfaceTintColor: surfaceTintColor,
                        shadowColor: shadowColor,
                        shape: shape,
                        clipBehavior: clipBehavior,
                        child: LayoutBuilder(
                          builder: (_, constraints) {
                            return WoltModalSheetAnimatedSwitcher(
                              woltModalType: _modalType,
                              pageIndex: _selectedPageIndex,
                              pages: pages,
                              sheetWidth: constraints.maxWidth,
                              showDragHandle: showDragHandle,
                            );
                          },
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
            body: widget.useSafeArea
                ? Stack(
                    children: [
                      SafeArea(child: multiChildLayout),
                      if (_modalType == WoltModalType.bottomSheet)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ColoredBox(
                            color: pageBackgroundColor,
                            child: SizedBox(
                              height: MediaQuery.of(context).padding.bottom,
                              width: double.infinity,
                            ),
                          ),
                        ),
                    ],
                  )
                : multiChildLayout,
          );
        },
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) {
      return;
    }
    widget.animationController!.value -= details.primaryDelta! / _childHeight;
  }

  void _handleDragStart(DragStartDetails details) {
    // Allow the bottom sheet to track the user's finger accurately.
    animationCurve = Curves.linear;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) {
      return;
    }
    bool isClosing = false;
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        isClosing = true;
      }
    } else if (widget.animationController!.value < _closeProgressThreshold) {
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: -1.0);
      }
      isClosing = true;
    } else {
      widget.animationController!.forward();
    }

    // Allow the bottom sheet to animate smoothly from its current position.
    animationCurve = BottomSheetSuspendedCurve(
      widget.route.animation!.value,
      curve: animationCurve,
    );

    if (isClosing && widget.route.isCurrent) {
      final onModalDismissedWithDrag = widget.onModalDismissedWithDrag;
      if (onModalDismissedWithDrag != null) {
        onModalDismissedWithDrag();
      } else {
        Navigator.pop(context);
      }
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
  void addPagesToStack(List<SliverWoltModalSheetPage> pages) {
    setState(() {
      _pages.addAll(pages);
    });
  }

  /// Overload of addPagesToStack for adding a single page.
  ///
  /// Parameters:
  /// - [page]: The single [SliverWoltModalSheetPage] to be added to the stack.
  void addPageToStack(SliverWoltModalSheetPage page) {
    addPagesToStack([page]);
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
  /// Returns:
  /// - [bool]: Returns `true` if the operation affects the stack, `false` if the stack is empty
  ///   and no operation was performed.
  bool addOrReplacePages(List<SliverWoltModalSheetPage> pages) {
    setState(() {
      if (_selectedPageIndex == _pages.length - 1) {
        // Append new pages if the current page is the last one.
        _pages.addAll(pages);
      } else {
        // Replace all pages beyond the current one with new pages.
        _pages = List<SliverWoltModalSheetPage>.from(_pages.take(_selectedPageIndex + 1))
          ..addAll(pages);
      }
    });

    return true; // The operation always affects the stack if it's not empty.
  }

  /// Overload of addOrReplaceLastPages for adding a single page.
  ///
  /// Parameters:
  /// - [page]: The single [SliverWoltModalSheetPage] to be added or to replace the last page.
  bool addOrReplacePage(SliverWoltModalSheetPage page) {
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
  /// Returns:
  /// None.
  void pushPages(List<SliverWoltModalSheetPage> pages) {
    setState(() {
      _pages.addAll(pages);
      if (pages.isNotEmpty) {
        _selectedPageIndex =
            _pages.length - pages.length; // Set to the first of the newly added pages.
      }
    });
  }

  /// Adds a new page to the modal sheet stack and displays it.
  ///
  /// This method pushes a new [SliverWoltModalSheetPage] onto the navigation stack,
  /// making it the visible page. If the modal sheet is currently showing another page,
  /// that page will be transitioned by the new page.
  ///
  /// Parameters:
  /// - [page]: The [SliverWoltModalSheetPage] to add to the navigation stack.
  ///
  /// Returns:
  /// None.
  void pushPage(SliverWoltModalSheetPage page) {
    pushPages([page]); // Use the pushPages method to handle the single page push.
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
      setState(() {
        _pages.removeLast();
        _selectedPageIndex = _pages.length - 1;
      });
      return true;
    }
    return false;
  }

  /// Replaces a specific page identified by [id] with a new page [page].
  ///
  /// Searches for a page with the given [id] and replaces it with the new [page]. If no page with
  /// the specified [id] is found, an error is thrown.
  ///
  /// Parameters:
  /// - [id]: The identifier of the page to replace.
  /// - [page]: The new [SliverWoltModalSheetPage] to insert in place of the old one.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if replacing  page was successful, `false` if no page with the
  /// specified [id] is found.
  bool replacePage(Object id, SliverWoltModalSheetPage page) {
    bool found = false;
    final List<SliverWoltModalSheetPage> newPages = _pages.map((p) {
      if (p.id == id) {
        found = true;
        return page;
      }
      return p;
    }).toList();
    if (!found) return false;
    setState(() {
      _pages = newPages;
    });
    return true;
  }

  /// Replaces the current page in the modal sheet stack with a new page.
  ///
  /// This method updates the navigation stack by replacing the page at the current index with
  /// a new [SliverWoltModalSheetPage]. It's particularly useful for updating the content of the
  /// current view without disrupting the overall navigation flow.
  ///
  /// Parameters:
  /// - [newPage]: The new [SliverWoltModalSheetPage] to replace the current page.
  ///
  /// Returns:
  /// None.
  void replaceCurrentPage(SliverWoltModalSheetPage newPage) {
    setState(() {
      _pages[_selectedPageIndex] = newPage;  // Replace the current page
    });
  }


  /// Replaces the entire stack of pages with a new list of pages while attempting to retain
  /// the current page's relative position in the stack.
  ///
  /// If the new list of pages is shorter than the current position index, the display will adjust
  /// to show the last page of the new list. This ensures the user always sees a valid page.
  ///
  /// Parameters:
  /// - [newPages]: The new list of [SliverWoltModalSheetPage] to set as the new navigation stack.
  ///
  /// Returns:
  /// None.
  void replaceAllPages(List<SliverWoltModalSheetPage> newPages) {
    setState(() {
      int newIndex = _selectedPageIndex;

      // Check if the current index exceeds the number of new pages
      if (newIndex >= newPages.length) {
        newIndex = newPages.length - 1;  // Adjust to the last page in the new list
      }

      _pages = List<SliverWoltModalSheetPage>.from(newPages);
      _selectedPageIndex = newIndex;  // Maintain the index if within the new list's range
    });
  }

  /// Advances to the next page in the modal sheet if one exists.
  ///
  /// This method increments the index to navigate to the next page in the modal sheet's stack.
  /// If the current page is the last one in the stack, this method will do nothing to prevent
  /// out-of-bounds errors. It ensures that navigation requests are safely bounded within the
  /// limits of the existing pages.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if the navigation to the next page was successful, `false` if
  ///   already on the last page and navigation did not occur.
  bool showNext() {
    if (_selectedPageIndex < _pages.length - 1) {
      setState(() {
        _selectedPageIndex++;
      });
      return true;
    }
    return false; // No navigation occurred, already at the last page.
  }

  /// Navigates to the previous page in the modal sheet if one exists.
  ///
  /// This method decrements the index to navigate back to the previous page in the modal
  /// sheet's stack. If the current page is the first one in the stack, this method will do
  /// nothing to ensure navigation remains within valid bounds.
  ///
  /// Returns:
  /// - [bool]: Returns `true` if the navigation to the previous page was successful, `false` if
  ///   already on the first page and navigation did not occur.
  bool showPrevious() {
    if (_selectedPageIndex > 0) {
      setState(() {
        _selectedPageIndex--;
      });
      return true;
    }
    return false; // No navigation occurred, already at the first page.
  }
}
