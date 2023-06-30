import 'package:flutter/material.dart';

/// A description for a page to be built within [WoltScrollableModalSheet].
class WoltModalSheetPage {
  /// Represents the widget that stands for the page title.
  final Widget? pageTitle;

  /// distance between image and page title or top bar and main title (in case of no image)
  final double pageTitlePaddingTop;

  /// A [Widget] that represents the main content displayed in the page.
  final Widget? sliverList;

  /// A [Widget] that represents the main content displayed in the page.
  /// This is a shortcut for providing a [SliverList] with one item.
  final Widget? singleChildContent;

  /// A [Widget] representing the title displayed in the top bar.
  final Widget? topBarTitle;

  /// A [Widget] representing the hero image displayed on top of the main content.
  final Widget? heroImage;

  /// The height of the [heroImage].
  final double? heroImageHeight;

  /// The background color of the page.
  final Color backgroundColor;

  /// Indicates whether the top bar should be visible or hidden when the page is scrolled.
  final bool isTopBarVisibleWhenScrolled;

  /// Indicates whether the page height should be at maximum even if the content size is smaller.
  final bool forceMaxHeight;

  /// The maximum height of the page relative to the device height. The value should be in range [0, 1].
  final double maxPageHeight;

  /// The minimum height of the page relative to the device height. The value should be in range [0, 1].
  final double minPageHeight;

  /// A [ScrollController] that controls the scrolling behavior of the page.
  final ScrollController? scrollController;

  /// A widget representing the action widgets located at the bottom of the page.
  final Widget? stickyActionBar;

  /// The padding applied to the main content of the page.
  final EdgeInsetsDirectional? mainContentPadding;

  /// A widget representing the back button.
  final Widget? backButton;

  /// A widget representing the close button.
  final Widget? closeButton;

  static const _defualtMaxPageHeight = 0.9;
  static const _defualtMinPageHeight = 0.0;
  static const _defaultPageTitlePaddingTop = 16.0;

  /// Creates a page to be built within [WoltScrollableModalSheet].
  ///
  /// [pageTitle] represents the widget that stands for the page title.
  ///
  /// [sliverList] represents the main content displayed in the page as a [SliverList].
  ///
  /// [singleChildContent] represents the main content displayed in the page as a single child widget.
  /// This is a shortcut for providing a [SliverList] with one item.
  ///
  /// [topBarTitle] represents the widget displayed in the top bar as the title.
  ///
  /// [heroImage] represents the hero image displayed on top of the main content.
  ///
  /// [heroImageHeight] represents the height of the [heroImage].
  ///
  /// [backgroundColor] represents the background color of the page.
  ///
  /// [isTopBarVisibleWhenScrolled] determines whether the top bar should be visible or hidden when the page is scrolled.
  ///
  /// [forceMaxHeight] indicates whether the page height should be at maximum even if the content size is smaller.
  ///
  /// [maxPageHeight] represents the maximum height percentage of the page relative to the device height in the range of [0, 1].
  ///
  /// [minPageHeight] represents the minimum height percentage of the page relative to the device height in the range of [0, 1].
  ///
  /// [scrollController] is a [ScrollController] that controls the scrolling behavior of the page.
  ///
  /// [stickyActionBar] represents the action widget located in the bottom of the modal sheet
  ///
  /// [mainContentPadding] represents the padding applied to the page content.
  ///
  /// [backButton] represents the widget representing the back button.
  ///
  /// [closeButton] represents the widget representing the close button.
  const WoltModalSheetPage({
    this.pageTitle,
    this.pageTitlePaddingTop = _defaultPageTitlePaddingTop,
    this.sliverList,
    this.singleChildContent,
    this.topBarTitle,
    this.heroImage,
    this.heroImageHeight,
    this.backgroundColor = Colors.white,
    this.isTopBarVisibleWhenScrolled = true,
    this.forceMaxHeight = false,
    this.maxPageHeight = _defualtMaxPageHeight,
    this.minPageHeight = _defualtMinPageHeight,
    this.scrollController,
    this.stickyActionBar,
    this.mainContentPadding,
    this.backButton,
    this.closeButton,
  })  : assert((heroImageHeight == null) == (heroImage == null)),
        assert((singleChildContent != null) == (sliverList == null));

  /// Creates a [WoltModalSheetPage] with a single child main content.
  factory WoltModalSheetPage.withSingleChild({
    required Widget child,
    Widget? pageTitle,
    double? pageTitlePaddingTop,
    Widget? topBarTitle,
    Widget? heroImage,
    double? heroImageHeight,
    double? maxPageHeight,
    double? minPageHeight,
    Color backgroundColor = Colors.white,
    bool isTopBarVisibleWhenScrolled = true,
    bool forceMaxHeight = false,
    ScrollController? scrollController,
    Widget? stickyActionBar,
    EdgeInsetsDirectional? mainContentPadding,
    Widget? backButton,
    Widget? closeButton,
  }) {
    return WoltModalSheetPage(
      singleChildContent: child,
      pageTitle: pageTitle,
      topBarTitle: topBarTitle,
      heroImage: heroImage,
      heroImageHeight: heroImageHeight,
      backgroundColor: backgroundColor,
      isTopBarVisibleWhenScrolled: isTopBarVisibleWhenScrolled,
      forceMaxHeight: forceMaxHeight,
      scrollController: scrollController,
      stickyActionBar: stickyActionBar,
      mainContentPadding: mainContentPadding,
      backButton: backButton,
      closeButton: closeButton,
      maxPageHeight: maxPageHeight ?? _defualtMaxPageHeight,
      minPageHeight: minPageHeight ?? _defualtMinPageHeight,
      pageTitlePaddingTop: pageTitlePaddingTop ?? _defaultPageTitlePaddingTop,
    );
  }

  /// Creates a [WoltModalSheetPage] with a custom [SliverList] main content.
  factory WoltModalSheetPage.withCustomSliverList({
    required Widget sliverList,
    Widget? pageTitle,
    double? pageTitlePaddingTop,
    Widget? topBarTitle,
    Widget? heroImage,
    double? heroImageHeight,
    Color backgroundColor = Colors.white,
    bool isTopBarVisibleWhenScrolled = true,
    bool forceMaxHeight = false,
    ScrollController? scrollController,
    Widget? stickyActionBar,
    EdgeInsetsDirectional? mainContentPadding,
    Widget? backButton,
    Widget? closeButton,
    double? maxPageHeight,
    double? minPageHeight,
  }) {
    return WoltModalSheetPage(
      sliverList: sliverList,
      pageTitle: pageTitle,
      pageTitlePaddingTop: pageTitlePaddingTop ?? _defaultPageTitlePaddingTop,
      topBarTitle: topBarTitle,
      heroImage: heroImage,
      heroImageHeight: heroImageHeight,
      backgroundColor: backgroundColor,
      isTopBarVisibleWhenScrolled: isTopBarVisibleWhenScrolled,
      forceMaxHeight: forceMaxHeight,
      scrollController: scrollController,
      stickyActionBar: stickyActionBar,
      mainContentPadding: mainContentPadding,
      backButton: backButton,
      closeButton: closeButton,
      maxPageHeight: maxPageHeight ?? _defualtMaxPageHeight,
      minPageHeight: minPageHeight ?? _defualtMinPageHeight,
    );
  }
}
