import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_main_content.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar_flow.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar_title.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar_title_flow.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/paginating_widgets_group.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/wolt_modal_sheet_page_transition_state.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_layout.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_navigation_toolbar.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_sticky_action_bar_wrapper.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetAnimatedSwitcher extends StatefulWidget {
  final List<WoltModalSheetPage> pages;
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
  })  : assert(pageIndex >= 0 && pageIndex < pages.length),
        super(key: key);

  @override
  State<WoltModalSheetAnimatedSwitcher> createState() =>
      _WoltModalSheetAnimatedSwitcherState();
}

class _WoltModalSheetAnimatedSwitcherState
    extends State<WoltModalSheetAnimatedSwitcher>
    with TickerProviderStateMixin {
  PaginatingWidgetsGroup? _incomingPageWidgets;
  PaginatingWidgetsGroup? _outgoingPageWidgets;

  int get _pagesCount => widget.pages.length;

  int get _pageIndex => widget.pageIndex;

  WoltModalSheetPage get _page => widget.pages[_pageIndex];

  bool get _hasTopBarLayer {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    return _page.hasTopBarLayer ??
        themeData?.hasTopBarLayer ??
        defaultThemeData.hasTopBarLayer;
  }

  double get _topBarTranslationY => _hasTopBarLayer ? 4 : 0;

  late List<GlobalKey> _titleKeys;
  late List<GlobalKey> _mainContentKeys;
  late List<GlobalKey> _offstagedTitleKeys;
  late List<GlobalKey> _incomingOffstagedMainContentKeys;
  late List<GlobalKey> _outgoingOffstagedMainContentKeys;

  AnimationController? _animationController;

  List<ValueNotifier<double>> _scrollPositions = [];

  ValueNotifier<double> get _scrollPosition => _scrollPositions[_pageIndex];

  bool _isForwardMove = true;

  bool? _shouldAnimatePagination;

  GlobalKey get _pageTitleKey => _titleKeys[_pageIndex];

  @override
  void initState() {
    super.initState();
    _resetGlobalKeys();
    _resetScrollPositions();
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
    _scrollPositions = [
      for (int i = 0; i < _pagesCount; i++) ValueNotifier(0.0)
    ];
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
    _isForwardMove = oldWidget.pageIndex < widget.pageIndex;
    if (oldWidget.pageIndex != widget.pageIndex) {
      _addPage(animate: true);
    }
    if (oldWidget.pages != widget.pages &&
        oldWidget.pageIndex == widget.pageIndex) {
      _resetScrollPositions();
      _resetGlobalKeys();
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
            topBarTranslationY: _topBarTranslationY,
            showDragHandle: widget.showDragHandle,
          ),
        if (incomingWidgets != null)
          WoltModalSheetLayout(
            paginatingWidgetsGroup: incomingWidgets,
            page: _page,
            woltModalType: widget.woltModalType,
            topBarTranslationY: _topBarTranslationY,
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
    super.dispose();
  }

  List<GlobalKey<State<StatefulWidget>>> _createGlobalKeys() =>
      [for (int i = 0; i < widget.pages.length; i++) GlobalKey()];

  void _addPage({required bool animate}) {
    // We set the _shouldAnimatePagination to animate, which dictates whether the new page transition will be animated.
    _shouldAnimatePagination = animate;

    // An AnimationController is created and attached to this State object (with 'this' as the vsync).
    _animationController = AnimationController(
      duration: const Duration(
          milliseconds: defaultWoltModalTransitionAnimationDuration),
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
            _animationController?.value =
                _animationController?.upperBound ?? 1.0;
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

  PaginatingWidgetsGroup _createIncomingWidgets(
      AnimationController animationController) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final hasTopBarLayer = _hasTopBarLayer;
    final isTopBarLayerAlwaysVisible = _page.isTopBarLayerAlwaysVisible ??
        themeData?.isTopBarLayerAlwaysVisible ??
        defaultThemeData.isTopBarLayerAlwaysVisible;
    final topBarTitle =
        WoltModalSheetTopBarTitle(page: _page, pageTitleKey: _pageTitleKey);
    final navBarHeight = _page.navBarHeight ??
        themeData?.navBarHeight ??
        defaultThemeData.navBarHeight;
    const animatedBuilderKey =
        ValueKey(WoltModalSheetPageTransitionState.incoming);
    // If the page uses the default top bar, we should show the top bar title to be represented in
    // the middle of the navigation toolbar.
    final shouldShowTopBarTitle = hasTopBarLayer && _page.topBar == null;
    Widget? navigationToolbarMiddle;
    if (shouldShowTopBarTitle) {
      navigationToolbarMiddle = isTopBarLayerAlwaysVisible
          ? Center(child: topBarTitle)
          : WoltModalSheetTopBarTitleFlow(
              page: _page,
              currentScrollPositionListenable: _scrollPosition,
              titleKey: _pageTitleKey,
              topBarTitle: topBarTitle,
            );
    }
    return PaginatingWidgetsGroup(
      mainContentAnimatedBuilder: MainContentAnimatedBuilder(
        key: animatedBuilderKey,
        pageTransitionState: WoltModalSheetPageTransitionState.incoming,
        controller: animationController,
        incomingOffstagedMainContentKey:
            _incomingOffstagedMainContentKeys[_pageIndex],
        outgoingOffstagedMainContentKey:
            _outgoingOffstagedMainContentKeys[_pageIndex],
        forwardMove: _isForwardMove,
        sheetWidth: widget.sheetWidth,
        child: _createMainContent(
          mainContentKey: _mainContentKeys[_pageIndex],
          titleKey: _pageTitleKey,
        ),
      ),
      offstagedMainContent:
          _createMainContent(titleKey: _offstagedTitleKeys[_pageIndex]),
      topBarAnimatedBuilder: TopBarAnimatedBuilder(
        key: animatedBuilderKey,
        pageTransitionState: WoltModalSheetPageTransitionState.incoming,
        controller: animationController,
        child: hasTopBarLayer
            ? (isTopBarLayerAlwaysVisible
                ? WoltModalSheetTopBar(page: _page)
                : WoltModalSheetTopBarFlow(
                    page: _page,
                    currentScrollPositionListenable: _scrollPosition,
                    topBarTranslationYAmountInPx: _topBarTranslationY,
                    titleKey: _pageTitleKey,
                  ))
            : const SizedBox.shrink(),
      ),
      navigationToolbarAnimatedBuilder: NavigationToolbarAnimatedBuilder(
        key: animatedBuilderKey,
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
        pageTransitionState: WoltModalSheetPageTransitionState.incoming,
        controller: animationController,
        child: WoltStickyActionBarWrapper(page: _page),
      ),
    );
  }

  PaginatingWidgetsGroup _createOutgoingWidgets(
    AnimationController animationController,
    PaginatingWidgetsGroup currentWidgetsToBeOutgoing,
  ) {
    const animatedBuilderKey =
        ValueKey(WoltModalSheetPageTransitionState.outgoing);
    return PaginatingWidgetsGroup(
      mainContentAnimatedBuilder: MainContentAnimatedBuilder(
        key: animatedBuilderKey,
        pageTransitionState: WoltModalSheetPageTransitionState.outgoing,
        controller: animationController,
        incomingOffstagedMainContentKey:
            _incomingOffstagedMainContentKeys[_pageIndex],
        outgoingOffstagedMainContentKey:
            _outgoingOffstagedMainContentKeys[_pageIndex],
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
        pageTransitionState: WoltModalSheetPageTransitionState.outgoing,
        controller: animationController,
        child: currentWidgetsToBeOutgoing.topBarAnimatedBuilder.child,
      ),
      navigationToolbarAnimatedBuilder: NavigationToolbarAnimatedBuilder(
        key: animatedBuilderKey,
        pageTransitionState: WoltModalSheetPageTransitionState.outgoing,
        controller: animationController,
        child:
            currentWidgetsToBeOutgoing.navigationToolbarAnimatedBuilder.child,
      ),
      sabAnimatedBuilder: SabAnimatedBuilder(
        key: animatedBuilderKey,
        pageTransitionState: WoltModalSheetPageTransitionState.outgoing,
        controller: animationController,
        child: currentWidgetsToBeOutgoing.sabAnimatedBuilder.child,
      ),
    );
  }

  WoltModalSheetMainContent _createMainContent({
    required GlobalKey titleKey,
    GlobalKey? mainContentKey,
  }) {
    return WoltModalSheetMainContent(
      key: mainContentKey,
      pageTitleKey: titleKey,
      currentScrollPosition: _scrollPosition,
      page: _page,
      woltModalType: widget.woltModalType,
    );
  }
}
