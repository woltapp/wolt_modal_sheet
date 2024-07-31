import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_hero_image.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// The main content widget within the scrollable modal sheet.
///
/// This widget is responsible for displaying the main content of the scrollable modal sheet.
/// It handles the scroll behavior, page layout, and interactions within the modal sheet.
class WoltModalSheetMainContent extends StatelessWidget {
  final ScrollController? scrollController;
  final GlobalKey pageTitleKey;
  final SliverWoltModalSheetPage page;
  final WoltModalType woltModalType;
  final WoltModalSheetScrollAnimationStyle scrollAnimationStyle;
  final WoltModalSheetRoute route;
  final VoidCallback? onModalDismissedWithDrag;
  final GlobalKey modalContentKey;

  const WoltModalSheetMainContent({
    required this.scrollController,
    required this.pageTitleKey,
    required this.page,
    required this.woltModalType,
    required this.scrollAnimationStyle,
    required this.route,
    this.onModalDismissedWithDrag,
    required this.modalContentKey,
    Key? key,
  }) : super(key: key);
  RenderBox get _renderBox =>
      modalContentKey.currentContext!.findRenderObject()! as RenderBox;

  double get _childHeight => _renderBox.size.height;
  bool get _shouldDragContent =>
      (page.contentDraggable ?? false) && woltModalType is WoltBottomSheetType;

  AnimationController get _animationController => route.animationController!;

  double get _minFlingVelocity => woltModalType.minFlingVelocity;

  bool get _isDismissUnderway =>
      _animationController.status == AnimationStatus.reverse;

  bool get _isDismissed => _animationController.isDismissed;

  WoltModalDismissDirection? get _dismissDirection =>
      woltModalType.dismissDirection;

  void _handleVerticalDragUpdate(
      DragUpdateDetails details, BuildContext context) {
    if (_isDismissUnderway || _isDismissed) {
      return;
    }

    final deltaDiff = details.primaryDelta! / _childHeight;
    _animationController.value -= deltaDiff;

    if (_dismissDirection == WoltModalDismissDirection.down) {
      _animationController.value -= deltaDiff;
    } else if (_dismissDirection == WoltModalDismissDirection.up) {
      _animationController.value += deltaDiff;
    }
  }

  void _handleVerticalDragEnd(BuildContext context, DragEndDetails details) {
    if (_isDismissUnderway || _isDismissed) {
      return;
    }
    bool isClosing = false;
    bool isDraggingUpward = details.velocity.pixelsPerSecond.dy < 0;
    bool isDraggingDownward = details.velocity.pixelsPerSecond.dy > 0;
    final isDismissUp = _dismissDirection?.isUp ?? false;
    final isDismissDown = _dismissDirection?.isDown ?? false;
    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _childHeight;

    if (isDraggingUpward && isDismissUp) {
      if (details.velocity.pixelsPerSecond.dy.abs() > _minFlingVelocity) {
        _animationController.fling(velocity: flingVelocity);
        if (flingVelocity > 0.0) {
          isClosing = true;
        }
      }
    }

    if (isDraggingDownward && isDismissDown) {
      if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
        _animationController.fling(velocity: flingVelocity * -1.0);
        if (flingVelocity < 0.0) {
          isClosing = true;
        }
      }
    }

    if (_animationController.value < woltModalType.closeProgressThreshold) {
      if (_animationController.value > 0.0) {
        _animationController.fling(velocity: -1.0);
      }
      isClosing = true;
    } else {
      _animationController.forward();
    }

    if (isClosing && route.isCurrent) {
      final onModalDismissedWithDrag = this.onModalDismissedWithDrag;
      if (onModalDismissedWithDrag != null) {
        onModalDismissedWithDrag();
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final heroImageHeight = page.heroImage == null
        ? 0.0
        : (page.heroImageHeight ??
            themeData?.heroImageHeight ??
            defaultThemeData.heroImageHeight);
    final pageHasTopBarLayer = page.hasTopBarLayer ??
        themeData?.hasTopBarLayer ??
        defaultThemeData.hasTopBarLayer;
    final isTopBarLayerAlwaysVisible =
        pageHasTopBarLayer && page.isTopBarLayerAlwaysVisible == true;
    final navBarHeight = page.navBarHeight ??
        themeData?.navBarHeight ??
        defaultThemeData.navBarHeight;
    final topBarHeight = pageHasTopBarLayer ||
            page.leadingNavBarWidget != null ||
            page.trailingNavBarWidget != null
        ? navBarHeight
        : 0.0;
    final isNonScrollingPage = page is NonScrollingWoltModalSheetPage;
    final shouldFillRemaining = woltModalType.forceMaxHeight ||
        (page.forceMaxHeight && !isNonScrollingPage);

    final scrollView = NotificationListener(
      onNotification: _shouldDragContent
          ? (ScrollNotification notification) {
              if (notification is OverscrollNotification) {
                if (notification.dragDetails != null) {
                  _handleVerticalDragUpdate(notification.dragDetails!, context);
                }
              }
              if (notification is ScrollEndNotification) {
                if (notification.dragDetails != null) {
                  _handleVerticalDragEnd(context, notification.dragDetails!);
                }
              }
              if (notification is ScrollStartNotification) {
                print('start');
              }

              return true;
            }
          : null,
      child: CustomScrollView(
        shrinkWrap: true,
        physics: _shouldDragContent
            ? const ClampingScrollPhysics()
            : (themeData?.mainContentScrollPhysics ??
                defaultThemeData.mainContentScrollPhysics),
        controller: scrollController,
        slivers: [
          if (!isNonScrollingPage)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    final heroImage = page.heroImage;
                    return heroImage != null
                        ? WoltModalSheetHeroImage(
                            topBarHeight: topBarHeight,
                            heroImage: heroImage,
                            heroImageHeight: heroImageHeight,
                            scrollAnimationStyle: scrollAnimationStyle,
                          )
                        // If top bar layer is always visible, the padding is explicitly added to the
                        // scroll view since top bar will not be integrated to scroll view at all.
                        // Otherwise, we implicitly create a spacing as a part of the scroll view.
                        : SizedBox(
                            height:
                                isTopBarLayerAlwaysVisible ? 0 : topBarHeight);
                  } else {
                    final pageTitle = page.pageTitle;
                    return KeyedSubtree(
                      key: pageTitleKey,
                      child: pageTitle ?? const SizedBox.shrink(),
                    );
                  }
                },
                childCount: 2,
              ),
            ),
          if (page.mainContentSliversBuilder == null)
            // ignore: deprecated_member_use_from_same_package
            ...page.mainContentSlivers!
          else
            ...page.mainContentSliversBuilder!(context),
          if (shouldFillRemaining)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox.shrink(),
            ),
        ],
      ),
    );
    return Padding(
      // The scroll view should be padded by the height of the top bar layer if it's always
      // visible. Otherwise, over scroll effect will not be visible due to the top bar layer.
      padding:
          EdgeInsets.only(top: isTopBarLayerAlwaysVisible ? topBarHeight : 0),
      child: scrollView,
    );
  }
}
