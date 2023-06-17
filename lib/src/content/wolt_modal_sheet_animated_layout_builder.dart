import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/current/current_page_widgets.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_main_content.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar.dart';
import 'package:wolt_modal_sheet/src/content/components/outgoing/outgoing_page_widgets.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_layout.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetAnimatedLayoutBuilder extends StatefulWidget {
  final VoidCallback onBackButtonPressed;
  final List<WoltModalSheetPage> pages;
  final int pageIndex;
  final WoltModalType woltModalType;

  const WoltModalSheetAnimatedLayoutBuilder({
    required this.onBackButtonPressed,
    required this.pages,
    required this.pageIndex,
    required this.woltModalType,
    Key? key,
  })  : assert(pageIndex >= 0 && pageIndex < pages.length),
        super(key: key);

  @override
  State<WoltModalSheetAnimatedLayoutBuilder> createState() =>
      _WoltModalSheetAnimatedLayoutBuilderState();
}

class _WoltModalSheetAnimatedLayoutBuilderState extends State<WoltModalSheetAnimatedLayoutBuilder>
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
  late List<GlobalKey> _offstagedTitleKeys;
  late List<GlobalKey> _currentOffstagedMainContentKeys;
  late List<GlobalKey> _outgoingOffstagedMainContentKeys;

  AnimationController? _animationController;

  late List<ValueNotifier<double>> _scrollPositions;

  ValueNotifier<double> get _currentScrollPosition => _scrollPositions[_pageIndex];

  bool _isForwardMove = true;

  bool? _shouldAnimatePagination;

  @override
  void initState() {
    super.initState();
    _offstagedTitleKeys = _createGlobalKeys();
    _titleKeys = _createGlobalKeys();
    _currentOffstagedMainContentKeys = _createGlobalKeys();
    _outgoingOffstagedMainContentKeys = _createGlobalKeys();
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
  void didUpdateWidget(covariant WoltModalSheetAnimatedLayoutBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isForwardMove = oldWidget.pageIndex < widget.pageIndex;
    if (oldWidget.pageIndex != widget.pageIndex) {
      _addPage(animate: true);
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
          footer: _page.footer != null
              ? _SwitcherLayout(
                  currentPageWidgets: currentWidgets?.footerAnimatedBuilder,
                  outgoingChild: outgoingWidgets?.footerAnimatedBuilder,
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
    _shouldAnimatePagination = animate;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: defaultWoltModalTransitionAnimationDuration),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _shouldAnimatePagination = null;
            _outgoingPageWidgets = null;
            _animationController?.value = _animationController?.upperBound ?? 1.0;
            _animationController?.dispose();
            _animationController = null;
          });
        }
      });
    final currentWidgetsToBeOutgoing = _currentPageWidgets;
    if (currentWidgetsToBeOutgoing != null) {
      _outgoingPageWidgets = _createOutgoingWidgets(
        _animationController!,
        currentWidgetsToBeOutgoing,
      );
    }
    _currentPageWidgets = _createCurrentWidgets(_animationController!);
    if (animate) {
      _animationController?.forward();
    } else {
      _animationController?.value = 1.0;
    }
  }

  CurrentPageWidgets _createCurrentWidgets(AnimationController animationController) {
    return CurrentPageWidgets(
      mainContentAnimatedBuilder: CurrentMainContentAnimatedBuilder(
        mainContent: _createMainContent(_titleKeys[_pageIndex]),
        controller: animationController,
        currentOffstagedMainContentKey: _currentOffstagedMainContentKeys[_pageIndex],
        outgoingOffstagedMainContentKey: _outgoingOffstagedMainContentKeys[_pageIndex],
        forwardMove: _isForwardMove,
      ),
      offstagedMainContent: _createMainContent(_offstagedTitleKeys[_pageIndex]),
      topBarAnimatedBuilder: CurrentTopBarWidgetsAnimatedBuilder(
        controller: animationController,
        child: _page.isTopBarVisibleWhenScrolled ? _createTopBar() : const SizedBox.shrink(),
      ),
      closeButtonAnimatedBuilder: CurrentTopBarWidgetsAnimatedBuilder(
        controller: animationController,
        child: _createCloseButton(),
      ),
      backButtonButtonAnimatedBuilder: CurrentTopBarWidgetsAnimatedBuilder(
        controller: animationController,
        child: _pageIndex == 0 ? const SizedBox.shrink() : _createBackButton(),
      ),
      footerAnimatedBuilder: CurrentFooterAnimatedBuilder(
        primaryButton: _page.footer == null ? const SizedBox.shrink() : _createFooter(),
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
      ),
      offstagedMainContent: ExcludeFocus(
        child: currentWidgetsToBeOutgoing.offstagedMainContent,
      ),
      topBarAnimatedBuilder: OutgoingTopBarWidgetsAnimatedBuilder(
        controller: animationController,
        child: currentWidgetsToBeOutgoing.topBarAnimatedBuilder.child,
      ),
      closeButtonAnimatedBuilder: OutgoingTopBarWidgetsAnimatedBuilder(
        controller: animationController,
        child: currentWidgetsToBeOutgoing.closeButtonAnimatedBuilder.child,
      ),
      backButtonButtonAnimatedBuilder: OutgoingTopBarWidgetsAnimatedBuilder(
        controller: animationController,
        child: currentWidgetsToBeOutgoing.backButtonButtonAnimatedBuilder.child,
      ),
      footerAnimatedBuilder: OutgoingFooterAnimatedBuilder(
        controller: animationController,
        footer: currentWidgetsToBeOutgoing.footerAnimatedBuilder.primaryButton,
      ),
    );
  }

  WoltModalSheetMainContent _createMainContent(GlobalKey titleKey) => WoltModalSheetMainContent(
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

  Widget _createFooter() => _page.footer ?? const SizedBox.shrink();
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
