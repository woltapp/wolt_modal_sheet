import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_page_widgets.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_top_bar_controls_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_main_content.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_page_widgets.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_top_bar_controls_animated_builder.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_layout.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetAnimatedSwitcher extends StatefulWidget {
  final List<WoltModalSheetPage> pages;
  final int pageIndex;
  final WoltModalType woltModalType;
  final double sheetWidth;

  const WoltModalSheetAnimatedSwitcher({
    required this.pages,
    required this.pageIndex,
    required this.woltModalType,
    required this.sheetWidth,
    Key? key,
  })  : assert(pageIndex >= 0 && pageIndex < pages.length),
        super(key: key);

  @override
  State<WoltModalSheetAnimatedSwitcher> createState() =>
      _WoltModalSheetAnimatedSwitcherState();
}

class _WoltModalSheetAnimatedSwitcherState extends State<WoltModalSheetAnimatedSwitcher>
    with TickerProviderStateMixin {
  CurrentPageWidgets? _currentPageWidgets;
  OutgoingPageWidgets? _outgoingPageWidgets;

  int get _pagesCount => widget.pages.length;

  int get _pageIndex => widget.pageIndex;

  WoltModalSheetPage get _page => widget.pages[_pageIndex];

  // TODO: Get this information from the ThemeData extension
  double get _topBarHeight => _page.isTopBarVisibleWhenScrolled ? 72 : 0;

  double get _topBarTranslationY => _page.isTopBarVisibleWhenScrolled ? 4 : 0;

  late List<GlobalKey> _titleKeys;
  late List<GlobalKey> _mainContentKeys;
  late List<GlobalKey> _offstagedTitleKeys;
  late List<GlobalKey> _currentOffstagedMainContentKeys;
  late List<GlobalKey> _outgoingOffstagedMainContentKeys;

  AnimationController? _animationController;

  List<ValueNotifier<double>> _scrollPositions = [];

  ValueNotifier<double> get _currentScrollPosition => _scrollPositions[_pageIndex];

  bool _isForwardMove = true;

  bool? _shouldAnimatePagination;

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
    _currentOffstagedMainContentKeys = _createGlobalKeys();
    _outgoingOffstagedMainContentKeys = _createGlobalKeys();
  }

  void _resetScrollPositions() {
    _scrollPositions.clear();
    _scrollPositions = [for (int i = 0; i < _pagesCount; i++) ValueNotifier(0.0)];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentPageWidgets == null) {
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
    if (oldWidget.pages != widget.pages && oldWidget.pageIndex == widget.pageIndex) {
      _resetScrollPositions();
      _resetGlobalKeys();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidgets = _currentPageWidgets;
    final outgoingWidgets = _outgoingPageWidgets;
    final animationController = _animationController;
    final animatePagination = _shouldAnimatePagination;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        WoltModalSheetLayout(
          key: ValueKey('_Skeleton$_pageIndex'),
          page: _page,
          woltModalType: widget.woltModalType,
          topBarTranslationY: _topBarTranslationY,
          mainContent: _SwitcherLayout(
            currentPageWidgets: currentWidgets?.mainContentAnimatedBuilder,
            outgoingChild: outgoingWidgets?.mainContentAnimatedBuilder,
          ),
          topBar: _SwitcherLayout(
            currentPageWidgets: currentWidgets?.topBarAnimatedBuilder,
            outgoingChild: outgoingWidgets?.topBarAnimatedBuilder,
          ),
          closeButton: _SwitcherLayout(
            currentPageWidgets: currentWidgets?.closeButtonAnimatedBuilder,
            outgoingChild: outgoingWidgets?.closeButtonAnimatedBuilder,
          ),
          backButton: _SwitcherLayout(
            currentPageWidgets: currentWidgets?.backButtonButtonAnimatedBuilder,
            outgoingChild: outgoingWidgets?.backButtonButtonAnimatedBuilder,
          ),
          stickyActionBar: _page.stickyActionBar != null
              ? _SwitcherLayout(
                  currentPageWidgets: currentWidgets?.sabAnimatedBuilder,
                  outgoingChild: outgoingWidgets?.sabAnimatedBuilder,
                )
              : const SizedBox.shrink(),
          topBarHeight: _topBarHeight,
        ),
        if (currentWidgets != null &&
            animationController != null &&
            animatePagination != null &&
            animatePagination &&
            animationController.value != 1.0)
          Offstage(
            key: ValueKey('CurrentOffstage$_pageIndex'),
            child: KeyedSubtree(
              key: _currentOffstagedMainContentKeys[_pageIndex],
              child: currentWidgets.offstagedMainContent,
            ),
          ),
        if (outgoingWidgets != null &&
            animationController != null &&
            animatePagination != null &&
            animatePagination &&
            animationController.value != 1.0)
          Offstage(
            key: ValueKey('_OutgoingOffstage$_pageIndex'),
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
    final currentWidgetsToBeOutgoing = _currentPageWidgets;

    // If there were any current widgets, we create a new set of outgoing widgets from them.
    if (currentWidgetsToBeOutgoing != null) {
      _outgoingPageWidgets = _createOutgoingWidgets(
        _animationController!,
        currentWidgetsToBeOutgoing,
      );
    }

    // We then create the new set of current widgets with the new page
    _currentPageWidgets = _createCurrentWidgets(_animationController!);

    // If we're supposed to animate the transition, we start the animation with forward().
    // Otherwise, we just set the animation controller's value to 1.0, effectively skipping the animation.
    if (animate) {
      _animationController?.forward();
    } else {
      _animationController?.value = 1.0;
    }
  }

  CurrentPageWidgets _createCurrentWidgets(AnimationController animationController) {
    return CurrentPageWidgets(
      mainContentAnimatedBuilder: CurrentMainContentAnimatedBuilder(
        mainContent: _createMainContent(
          mainContentKey: _mainContentKeys[_pageIndex],
          titleKey: _titleKeys[_pageIndex],
        ),
        controller: animationController,
        currentOffstagedMainContentKey: _currentOffstagedMainContentKeys[_pageIndex],
        outgoingOffstagedMainContentKey: _outgoingOffstagedMainContentKeys[_pageIndex],
        forwardMove: _isForwardMove,
        sheetWidth: widget.sheetWidth,
      ),
      offstagedMainContent: _createMainContent(titleKey: _offstagedTitleKeys[_pageIndex]),
      topBarAnimatedBuilder: CurrentTopBarAnimatedBuilder(
        controller: animationController,
        child: _page.isTopBarVisibleWhenScrolled ? _createTopBar() : const SizedBox.shrink(),
      ),
      closeButtonAnimatedBuilder: CurrentTopBarControlsAnimatedBuilder(
        controller: animationController,
        child: _createCloseButton(),
      ),
      backButtonButtonAnimatedBuilder: CurrentTopBarControlsAnimatedBuilder(
        controller: animationController,
        child: _pageIndex == 0 ? const SizedBox.shrink() : _createBackButton(),
      ),
      sabAnimatedBuilder: CurrentSabAnimatedBuilder(
        stickyActionBar: _page.stickyActionBar == null ? const SizedBox.shrink() : _createSab(),
        controller: animationController,
      ),
    );
  }

  OutgoingPageWidgets _createOutgoingWidgets(
    AnimationController animationController,
    CurrentPageWidgets currentWidgetsToBeOutgoing,
  ) {
    return OutgoingPageWidgets(
      mainContentAnimatedBuilder: OutgoingMainContentAnimatedBuilder(
        controller: animationController,
        mainContent: ExcludeFocus(
          child: currentWidgetsToBeOutgoing.mainContentAnimatedBuilder.mainContent,
        ),
        currentOffstagedMainContentKey: _currentOffstagedMainContentKeys[_pageIndex],
        outgoingOffstagedMainContentKey: _outgoingOffstagedMainContentKeys[_pageIndex],
        forwardMove: _isForwardMove,
        sheetWidth: widget.sheetWidth,
      ),
      offstagedMainContent: ExcludeFocus(
        child: currentWidgetsToBeOutgoing.offstagedMainContent,
      ),
      topBarAnimatedBuilder: OutgoingTopBarAnimatedBuilder(
        controller: animationController,
        child: currentWidgetsToBeOutgoing.topBarAnimatedBuilder.child,
      ),
      closeButtonAnimatedBuilder: OutgoingTopBarControlsAnimatedBuilder(
        controller: animationController,
        child: currentWidgetsToBeOutgoing.closeButtonAnimatedBuilder.child,
      ),
      backButtonButtonAnimatedBuilder: OutgoingTopBarControlsAnimatedBuilder(
        controller: animationController,
        child: currentWidgetsToBeOutgoing.backButtonButtonAnimatedBuilder.child,
      ),
      sabAnimatedBuilder: OutgoingSabAnimatedBuilder(
        controller: animationController,
        sab: currentWidgetsToBeOutgoing.sabAnimatedBuilder.stickyActionBar,
      ),
    );
  }

  WoltModalSheetMainContent _createMainContent({
    required GlobalKey titleKey,
    GlobalKey? mainContentKey,
  }) =>
      WoltModalSheetMainContent(
        key: mainContentKey,
        pageTitleKey: titleKey,
        currentScrollPosition: _currentScrollPosition,
        page: _page,
        topBarHeight: _topBarHeight,
        woltModalType: widget.woltModalType,
      );

  WoltModalSheetTopBar _createTopBar() => WoltModalSheetTopBar(
        page: _page,
        currentScrollPositionListenable: _currentScrollPosition,
        topBarTranslationYAmountInPx: _topBarTranslationY,
        topBarHeight: _topBarHeight,
        titleKey: _titleKeys[_pageIndex],
      );

  Widget _createCloseButton() => _page.closeButton ?? const SizedBox.shrink();

  Widget _createBackButton() => _page.backButton ?? const SizedBox.shrink();

  Widget _createSab() => _page.stickyActionBar ?? const SizedBox.shrink();
}

class _SwitcherLayout extends StatelessWidget {
  final Widget? currentPageWidgets;
  final Widget? outgoingChild;

  const _SwitcherLayout({
    required this.currentPageWidgets,
    required this.outgoingChild,
  });

  @override
  Widget build(BuildContext context) {
    final currentChild = currentPageWidgets;
    final outgoingChild = this.outgoingChild;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (outgoingChild != null) outgoingChild,
        if (currentChild != null) currentChild,
      ],
    );
  }
}
