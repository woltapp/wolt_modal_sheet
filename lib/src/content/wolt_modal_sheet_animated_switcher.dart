import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_main_content.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar_flow.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar_title.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar_title_flow.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/paginating_widgets_group.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/wolt_modal_sheet_page_transition_state.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_layout.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/utils/soft_keyboard_closed_event.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_navigation_toolbar.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_sticky_action_bar_wrapper.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetAnimatedSwitcher extends StatefulWidget {
  final List<SliverWoltModalSheetPage> pages;
  final int pageIndex;
  final WoltModalType woltModalType;
  final double sheetWidth;
  final bool showDragHandle;

  const WoltModalSheetAnimatedSwitcher({
    required this.pages,
    required this.pageIndex,
    required this.woltModalType,
    required this.sheetWidth,
    required this.showDragHandle,
    Key? key,
  })
      : assert(pageIndex >= 0 && pageIndex < pages.length),
        super(key: key);

  @override
  State<WoltModalSheetAnimatedSwitcher> createState() => _WoltModalSheetAnimatedSwitcherState();
}

class _WoltModalSheetAnimatedSwitcherState extends State<WoltModalSheetAnimatedSwitcher>
    with TickerProviderStateMixin {
  PaginatingWidgetsGroup? _incomingPageWidgets;
  PaginatingWidgetsGroup? _outgoingPageWidgets;

  static const int _maxKeyboardAnimationDuration = 250;

  int get _pagesCount => widget.pages.length;

  int get _pageIndex => widget.pageIndex;

  SliverWoltModalSheetPage get _page => widget.pages[_pageIndex];

  bool get _hasTopBarLayer {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    return _page.hasTopBarLayer ?? themeData?.hasTopBarLayer ?? defaultThemeData.hasTopBarLayer;
  }

  late List<GlobalKey> _titleKeys;
  late List<GlobalKey> _mainContentKeys;
  late List<GlobalKey> _offstagedTitleKeys;
  late List<GlobalKey> _incomingOffstagedMainContentKeys;
  late List<GlobalKey> _outgoingOffstagedMainContentKeys;

  AnimationController? _animationController;

  /// List of [ScrollController] objects, one for each [WoltModalSheetPage] main content.
  List<ScrollController> _scrollControllers = [];

  /// The [ScrollController] of the current [WoltModalSheetPage] main content.
  ScrollController get _currentPageScrollController => _scrollControllers[_pageIndex];

  /// List of [ValueNotifier] objects, each one for the listening of the scroll position updates
  /// in each [WoltModalSheetPage] main content.
  List<ValueNotifier<double>> _scrollPositions = [];

  /// The current scroll position of the current [WoltModalSheetPage] main content. This is
  /// needed to create a [ScrollController] with initial scroll offset when changing pages.
  ValueNotifier<double> get _currentPageScrollPosition => _scrollPositions[_pageIndex];

  /// Subscription for discovering the state of the soft-keyboard visibility
  late StreamSubscription<bool> _softKeyboardVisibilitySubscription;

  /// Value notifier for discovering when the soft-keyboard is dismissed. These events are
  /// consumed by [WoltModalSheetTopBarFlow] and [WoltModalSheetTopBarTitleFlow] to trigger a
  /// re-paint when keyboard is closing. This is needed to avoid the top bar from being stuck
  /// when keyboard is closing.
  ///
  /// By default, the top bar visibility is synced with the scroll controller position. The
  /// [WoltModalSheetTopBarFlow] and [WoltModalSheetTopBarTitleFlow] paints the top bar according
  /// to the scroll position changes.
  ///
  /// When the keyboard appears the scroll controller receives scroll update events, which are
  /// sent by the Flutter SDK. However, the keyboard closing events do not cause a change in the
  /// scroll controller. Therefore, we need to manually trigger a re-paint when the keyboard is
  /// closing.
  final ValueNotifier<SoftKeyboardClosedEvent> _softKeyboardClosedNotifier =
      ValueNotifier(const SoftKeyboardClosedEvent(eventId: 0));

  bool _isForwardMove = true;

  bool? _shouldAnimatePagination;

  GlobalKey get _pageTitleKey => _titleKeys[_pageIndex];

  @override
  void initState() {
    super.initState();
    _resetGlobalKeys();
    _resetScrollPositions();
    _resetScrollControllers();
    _subscribeToCurrentPageScrollPositionChanges();
    _subscribeToSoftKeyboardClosedEvent();
  }

  void _resetGlobalKeys() {
    _offstagedTitleKeys = _createGlobalKeys();
    _titleKeys = _createGlobalKeys();
    _mainContentKeys = _createGlobalKeys();
    _incomingOffstagedMainContentKeys = _createGlobalKeys();
    _outgoingOffstagedMainContentKeys = _createGlobalKeys();
  }

  void _resetScrollPositions() {
    _scrollPositions.clear();
    _scrollPositions = [for (int i = 0; i < _pagesCount; i++) ValueNotifier(0.0)];
  }

  void _resetScrollControllers() {
    _scrollControllers.clear();
    _scrollControllers = [
      for (int i = 0; i < _pagesCount; i++)
        (_page.scrollController ?? ScrollController(initialScrollOffset: _scrollPositions[i].value))
    ];
  }

  void _subscribeToCurrentPageScrollPositionChanges() {
    for (final scrollController in _scrollControllers) {
      scrollController.addListener(() {
        if (_currentPageScrollController.hasClients) {
          _currentPageScrollPosition.value = _currentPageScrollController.position.pixels;
        }
      });
    }
  }

  void _subscribeToSoftKeyboardClosedEvent() {
    _softKeyboardVisibilitySubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) async {
          if (!visible) {
            /// Wait for closing soft keyboard animation to finish before emitting new value.
            await Future.delayed(
              const Duration(milliseconds: _maxKeyboardAnimationDuration),
            );
            final int lastEventId = _softKeyboardClosedNotifier.value.eventId;
            final newEventId = lastEventId + 1;
            _softKeyboardClosedNotifier.value = SoftKeyboardClosedEvent(eventId: newEventId);
          }
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_incomingPageWidgets == null) {
      _addPage(animate: false);
    }
  }

  @override
  void didUpdateWidget(covariant WoltModalSheetAnimatedSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldPageIndex = oldWidget.pageIndex;
    final newPageIndex = widget.pageIndex;
    _isForwardMove = oldPageIndex < newPageIndex;

    final isSamePageList = oldWidget.pages == widget.pages;
    if (!isSamePageList) {
      _resetScrollPositions();
      _resetScrollControllers();
      _subscribeToCurrentPageScrollPositionChanges();
      _resetGlobalKeys();
    }

    final oldVisiblePage = oldWidget.pages[oldPageIndex];
    final newVisiblePage = widget.pages[newPageIndex];
    final isCurrentVisiblePageSame = oldVisiblePage == newVisiblePage;

    if (!isCurrentVisiblePageSame) {
      _addPage(animate: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final incomingWidgets = _incomingPageWidgets;
    final outgoingWidgets = _outgoingPageWidgets;
    final animationController = _animationController;
    final animatePagination = _shouldAnimatePagination;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (outgoingWidgets != null)
          WoltModalSheetLayout(
            paginatingWidgetsGroup: outgoingWidgets,
            page: _page,
            woltModalType: widget.woltModalType,
            showDragHandle: widget.showDragHandle,
          ),
        if (incomingWidgets != null)
          WoltModalSheetLayout(
            paginatingWidgetsGroup: incomingWidgets,
            page: _page,
            woltModalType: widget.woltModalType,
            showDragHandle: widget.showDragHandle,
          ),
        if (incomingWidgets != null &&
            animationController != null &&
            animatePagination != null &&
            animatePagination &&
            animationController.value != 1.0)
          Offstage(
            child: KeyedSubtree(
              key: _incomingOffstagedMainContentKeys[_pageIndex],
              child: incomingWidgets.offstagedMainContent,
            ),
          ),
        if (outgoingWidgets != null &&
            animationController != null &&
            animatePagination != null &&
            animatePagination &&
            animationController.value != 1.0)
          Offstage(
            child: KeyedSubtree(
              key: _outgoingOffstagedMainContentKeys[_pageIndex],
              child: outgoingWidgets.offstagedMainContent,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _softKeyboardVisibilitySubscription.cancel();
    for (final element in _scrollControllers) {
      element.dispose();
    }
    for (final element in _scrollPositions) {
      element.dispose();
    }
    super.dispose();
  }

  List<GlobalKey<State<StatefulWidget>>> _createGlobalKeys() =>
      [for (int i = 0; i < widget.pages.length; i++) GlobalKey()];

  void _addPage({required bool animate}) {
    // We set the _shouldAnimatePagination to animate, which dictates whether the new page transition will be animated.
    _shouldAnimatePagination = animate;

    // An AnimationController is created and attached to this State object (with 'this' as the vsync).
    _animationController = AnimationController(
      duration: const Duration(milliseconds: defaultWoltModalTransitionAnimationDuration),
      vsync: this,
    )
    // We also attach a status listener to the animation controller. When the animation is completed, it will trigger a state change.
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _shouldAnimatePagination = null;
            // We clear the _outgoingPageWidgets, which was storing the "outgoing" page (the page we're transitioning from)
            _outgoingPageWidgets = null;
            // We ensure that the animation controller's value is set to its upper bound (which should be 1.0)
            _animationController?.value = _animationController?.upperBound ?? 1.0;
            // We dispose of the animation controller to free up resources as we're done with this animation
            _animationController?.dispose();
            // We also set the animation controller reference to null as it's no longer needed.
            _animationController = null;
          });
        }
      });

    // We store the current widgets in currentWidgetsToBeOutgoing, as we're about to replace them.
    final currentWidgetsToBeOutgoing = _incomingPageWidgets;

    // If there were any current widgets, we create a new set of outgoing widgets from them.
    if (currentWidgetsToBeOutgoing != null) {
      _outgoingPageWidgets = _createOutgoingWidgets(
        _animationController!,
        currentWidgetsToBeOutgoing,
      );
    }

    // We then create the new set of incoming widgets with the new page
    _incomingPageWidgets = _createIncomingWidgets(_animationController!);

    // If we're supposed to animate the transition, we start the animation with forward().
    // Otherwise, we just set the animation controller's value to 1.0, effectively skipping the animation.
    if (animate) {
      _animationController?.forward();
    } else {
      _animationController?.value = 1.0;
    }
  }

  PaginatingWidgetsGroup _createIncomingWidgets(AnimationController animationController) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final hasTopBarLayer = _hasTopBarLayer;
    final isTopBarLayerAlwaysVisible = _page.isTopBarLayerAlwaysVisible ??
        themeData?.isTopBarLayerAlwaysVisible ??
        defaultThemeData.isTopBarLayerAlwaysVisible;
    final topBarTitle = WoltModalSheetTopBarTitle(page: _page, pageTitleKey: _pageTitleKey);
    final navBarHeight =
        _page.navBarHeight ?? themeData?.navBarHeight ?? defaultThemeData.navBarHeight;
    final WoltModalSheetAnimationStyle animationStyle =
        themeData?.animationStyle ?? defaultThemeData.animationStyle;
    const animatedBuilderKey = ValueKey(WoltModalSheetPageTransitionState.incoming);
    // If the page uses the default top bar, we should show the top bar title to be represented in
    // the middle of the navigation toolbar.
    final shouldShowTopBarTitle = hasTopBarLayer && _page.topBar == null;
    Widget? navigationToolbarMiddle;
    if (shouldShowTopBarTitle) {
      navigationToolbarMiddle =
      isTopBarLayerAlwaysVisible || _page is NonScrollingWoltModalSheetPage
          ? Center(child: topBarTitle)
          : WoltModalSheetTopBarTitleFlow(
        scrollAnimationStyle: animationStyle.scrollAnimationStyle,
        page: _page,
        scrollController: _currentPageScrollController,
        titleKey: _pageTitleKey,
        topBarTitle: topBarTitle,
        softKeyboardClosedListenable: _softKeyboardClosedNotifier,
      );
    }
    return PaginatingWidgetsGroup(
      mainContentAnimatedBuilder: MainContentAnimatedBuilder(
        key: animatedBuilderKey,
        paginationAnimationStyle: animationStyle.paginationAnimationStyle,
        pageTransitionState: WoltModalSheetPageTransitionState.incoming,
        controller: animationController,
        incomingOffstagedMainContentKey: _incomingOffstagedMainContentKeys[_pageIndex],
        outgoingOffstagedMainContentKey: _outgoingOffstagedMainContentKeys[_pageIndex],
        forwardMove: _isForwardMove,
        sheetWidth: widget.sheetWidth,
        child: _createMainContent(
          mainContentKey: _mainContentKeys[_pageIndex],
          titleKey: _pageTitleKey,
          scrollController: _currentPageScrollController,
          scrollAnimationStyle: animationStyle.scrollAnimationStyle,
        ),
      ),
      offstagedMainContent: _createMainContent(
        titleKey: _offstagedTitleKeys[_pageIndex],
        scrollAnimationStyle: animationStyle.scrollAnimationStyle,
      ),
      topBarAnimatedBuilder: TopBarAnimatedBuilder(
        key: animatedBuilderKey,
        paginationAnimationStyle: animationStyle.paginationAnimationStyle,
        pageTransitionState: WoltModalSheetPageTransitionState.incoming,
        controller: animationController,
        child: hasTopBarLayer
            ? (isTopBarLayerAlwaysVisible || _page is NonScrollingWoltModalSheetPage
            ? WoltModalSheetTopBar(page: _page)
            : WoltModalSheetTopBarFlow(
          scrollAnimationStyle: animationStyle.scrollAnimationStyle,
          page: _page,
          scrollController: _currentPageScrollController,
          titleKey: _pageTitleKey,
          softKeyboardClosedListenable: _softKeyboardClosedNotifier,
        ))
            : const SizedBox.shrink(),
      ),
      navigationToolbarAnimatedBuilder: NavigationToolbarAnimatedBuilder(
        key: animatedBuilderKey,
        paginationAnimationStyle: animationStyle.paginationAnimationStyle,
        pageTransitionState: WoltModalSheetPageTransitionState.incoming,
        controller: animationController,
        child: SizedBox(
          height: navBarHeight,
          child: WoltNavigationToolbar(
            middleSpacing: 16.0,
            leading: _page.leadingNavBarWidget,
            middle: navigationToolbarMiddle,
            trailing: _page.trailingNavBarWidget,
          ),
        ),
      ),
      sabAnimatedBuilder: SabAnimatedBuilder(
        key: animatedBuilderKey,
        paginationAnimationStyle: animationStyle.paginationAnimationStyle,
        pageTransitionState: WoltModalSheetPageTransitionState.incoming,
        controller: animationController,
        child: WoltStickyActionBarWrapper(page: _page),
      ),
    );
  }

  PaginatingWidgetsGroup _createOutgoingWidgets(AnimationController animationController,
      PaginatingWidgetsGroup currentWidgetsToBeOutgoing,) {
    const animatedBuilderKey = ValueKey(WoltModalSheetPageTransitionState.outgoing);
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final WoltModalSheetAnimationStyle animationStyle =
        themeData?.animationStyle ?? defaultThemeData.animationStyle;
    return PaginatingWidgetsGroup(
      mainContentAnimatedBuilder: MainContentAnimatedBuilder(
        key: animatedBuilderKey,
        paginationAnimationStyle: animationStyle.paginationAnimationStyle,
        pageTransitionState: WoltModalSheetPageTransitionState.outgoing,
        controller: animationController,
        incomingOffstagedMainContentKey: _incomingOffstagedMainContentKeys[_pageIndex],
        outgoingOffstagedMainContentKey: _outgoingOffstagedMainContentKeys[_pageIndex],
        forwardMove: _isForwardMove,
        sheetWidth: widget.sheetWidth,
        child: ExcludeFocus(
          child: currentWidgetsToBeOutgoing.mainContentAnimatedBuilder.child,
        ),
      ),
      offstagedMainContent: ExcludeFocus(
        child: currentWidgetsToBeOutgoing.offstagedMainContent,
      ),
      topBarAnimatedBuilder: TopBarAnimatedBuilder(
        key: animatedBuilderKey,
        paginationAnimationStyle: animationStyle.paginationAnimationStyle,
        pageTransitionState: WoltModalSheetPageTransitionState.outgoing,
        controller: animationController,
        child: currentWidgetsToBeOutgoing.topBarAnimatedBuilder.child,
      ),
      navigationToolbarAnimatedBuilder: NavigationToolbarAnimatedBuilder(
        key: animatedBuilderKey,
        paginationAnimationStyle: animationStyle.paginationAnimationStyle,
        pageTransitionState: WoltModalSheetPageTransitionState.outgoing,
        controller: animationController,
        child: currentWidgetsToBeOutgoing.navigationToolbarAnimatedBuilder.child,
      ),
      sabAnimatedBuilder: SabAnimatedBuilder(
        key: animatedBuilderKey,
        paginationAnimationStyle: animationStyle.paginationAnimationStyle,
        pageTransitionState: WoltModalSheetPageTransitionState.outgoing,
        controller: animationController,
        child: currentWidgetsToBeOutgoing.sabAnimatedBuilder.child,
      ),
    );
  }

  WoltModalSheetMainContent _createMainContent({
    required GlobalKey titleKey,
    required WoltModalSheetScrollAnimationStyle scrollAnimationStyle,
    GlobalKey? mainContentKey,
    ScrollController? scrollController,
  }) {
    return WoltModalSheetMainContent(
      key: mainContentKey,
      scrollAnimationStyle: scrollAnimationStyle,
      pageTitleKey: titleKey,
      scrollController: scrollController,
      page: _page,
      woltModalType: widget.woltModalType,
    );
  }
}
