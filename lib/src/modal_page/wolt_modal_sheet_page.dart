import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';

/// The `WoltModalSheetPage` class is responsible for creating a modal sheet page within
/// the context of the [WoltScrollableModalSheet]. It's designed to represent a visually
/// layered structure with clear navigation and content display.
///
/// The structure is organized across layers on the z-axis:
/// 1. **Main Content Layer**: The fundamental content of the page, including the page title,
///    hero image, and the main content, which may be scrollable.
/// 2. **Sticky Action Bar Layer**: Positioned above the main content, this layer guides the
///    user towards the next step, remaining visible to hint that there is more content below.
/// 3. **Top Bar Layer**: Further above the main content layer, this layer includes the top bar
///    title and may become hidden or sticky based on scroll position and specific properties.
/// 4. **Navigation Bar Layer**: Sits at the top of the z-axis, containing navigational
///    widgets for the interface, such as back or close buttons.
///
/// By organizing these components across distinct layers, the class facilitates a clear and
/// intuitive user experience, with flexible customization options for various use cases.
class WoltModalSheetPage {
  /// Represents the widget that stands for the page title. A page title above the main content
  /// provides users with a quick understanding of what to expect from the page. As the user
  /// scrolls, this title becomes hidden, at which point the top bar title continues to serve
  /// this context-providing purpose.
  ///
  /// In many cases the text content for the [topBarTitle] is the same as the text content in
  /// [pageTitle]. Hence, when [topBarTitle] is not provided, the data of the first "Text" direct
  /// child of the of this widget will be used as the source for the [topBarTitle].
  ///
  /// A deeply nested text in the [pageTitle] widget can cause performance issues during the title
  /// retrieval process. Hence, it's recommended to keep the title text structure as simple as
  /// possible or explicitly provide the [topBarTitle] widget.
  final Widget? pageTitle;

  /// A [Widget] representing the title displayed in the top bar.
  ///
  /// When not provided, the data of the first "Text" direct child of the [pageTitle] widget will
  /// be used as the data for topBarTitle Text widget. If you want to avoid using the [pageTitle]
  /// text data, you should explicitly provide topBarTitle widget or set it as SizedBox.shrink().
  final Widget? topBarTitle;

  /// On z axis, the Top Bar layer resides above the main content layer and below the transparent
  /// navigation bar layer.
  ///
  /// Top bar aids users in grasping the context by displaying an optional title. The height of
  /// the top bar is equal to the height of [navigationBarHeight]. In other saying, when visible,
  /// the top bar fills the transparent background of the navigation bar.
  ///
  /// In scenarios where sheets are filled with content requiring scrolling, by default the top
  /// bar becomes visible as the  user scrolls, causing the page title replaced by the top bar.
  /// At this point, the top bar adopts a 'sticky' position at the top, guaranteeing consistent
  /// visibility. When [isTopBarLayerAlwaysVisible] is set to true, the top bar will be permanently
  /// sticky at the top of the sheet.
  ///
  /// The Top Bar design is flexible, when [hasTopBarLayer] is set to false, the top bar and the
  /// [topBarTitle] will be hidden.
  final bool hasTopBarLayer;

  /// Indicates whether the top bar should always remain visible, regardless of the page scroll
  /// position. When set to true, the top bar will be permanently displayed; when false, it may
  /// be hidden or revealed  based on the page's scrolling behavior.
  final bool isTopBarLayerAlwaysVisible;

  /// The distance between hero image and page title or top bar and main title in case hero image
  /// is not provided.
  final double pageTitlePaddingTop;

  /// A [Widget] that represents the main content displayed in the page.
  final Widget? sliverList;

  /// A [Widget] that represents the main content displayed in the page.
  /// This is a shortcut for providing a [SliverList] with one item.
  final Widget? singleChildContent;

  /// A [Widget] representing the hero image displayed on top of the main content. A Hero Image
  /// is positioned at the top of the main content. This widget immediately grabs the user's
  /// attention, effectively conveying the primary theme or message of the content.
  final Widget? heroImage;

  /// The height of the [heroImage].
  final double? heroImageHeight;

  /// The background color of the page.
  final Color backgroundColor;

  /// Height of the navigation bar. This value will also be the height of the top bar.
  ///
  /// The navigation bar layer has a transparent background, and sits directly above the top bar
  /// on the z-axis.
  ///
  /// It includes two specific widgets:
  /// the [leadingNavBarWidget] and the [trailingNavBarWidget]. The leading widget usually
  /// functions as the back button, enabling users to navigate to the previous page. The trailing
  /// widget often serves as the close button, utilized to close the modal sheet. Together, these
  /// widgets provide clear and intuitive navigational control, differentiating themselves from
  /// the top bar by focusing specifically on directional navigation within the interface.
  final double navigationBarHeight;

  /// Indicates whether the page height should be at maximum even if the content size is smaller.
  final bool forceMaxHeight;

  /// A [ScrollController] that controls the scrolling behavior of the page.
  final ScrollController? scrollController;

  /// A widget representing the action widgets located at the bottom of the page.
  ///
  /// The Sticky Action Bar (SAB) guides the user towards the next step. Anchored to the bottom
  /// of the view, the SAB elevates above the content with a gentle gradient. This position
  /// guarantees that the action remains visible, subtly hinting to the user that there is more
  /// content to be explored below the fold.
  final Widget? stickyActionBar;

  /// Indicates whether a gentle gradient overlay should be rendered above the
  /// [stickyActionBar]. The purpose of this gradient is to visually suggest
  /// to the user that additional content might be present below the action bar.
  ///
  /// If set to `true`, a gradient from the page's background color to transparent
  /// is rendered right above the [stickyActionBar]. If `false`, no gradient is rendered.
  /// By default, it's set to `true`.
  final bool hasSabGradient;

  /// The padding applied to the main content of the page. If not provided, the default padding
  /// will be used depending on the [WoltModalType] (16 for [WoltModalType.bottomSheet] and 32
  /// for [WoltModalType.dialog]).
  final EdgeInsetsDirectional? mainContentPadding;

  /// A widget representing leading widget in the navigation toolbar. This widget is usually
  /// a the back button.
  final Widget? leadingNavBarWidget;

  /// A widget representing trailing widget in the navigation toolbar. This widget is usually
  /// a the close button.
  final Widget? trailingNavBarWidget;

  static const _defaultPageTitlePaddingTop = 16.0;

  static const _defaultNavBarHeight = 72.0;

  /// Creates a page to be built within [WoltScrollableModalSheet].
  const WoltModalSheetPage({
    this.pageTitle,
    this.pageTitlePaddingTop = _defaultPageTitlePaddingTop,
    this.navigationBarHeight = _defaultNavBarHeight,
    this.sliverList,
    this.singleChildContent,
    this.topBarTitle,
    this.heroImage,
    this.heroImageHeight,
    this.backgroundColor = Colors.white,
    this.hasSabGradient = true,
    this.forceMaxHeight = false,
    this.scrollController,
    this.stickyActionBar,
    this.mainContentPadding,
    this.leadingNavBarWidget,
    this.trailingNavBarWidget,
    this.hasTopBarLayer = true,
    this.isTopBarLayerAlwaysVisible = false,
  })  : assert((heroImageHeight == null) == (heroImage == null)),
        assert((singleChildContent != null) == (sliverList == null));

  /// Creates a [WoltModalSheetPage] with a single child main content.
  factory WoltModalSheetPage.withSingleChild({
    required Widget child,
    Widget? pageTitle,
    double? pageTitlePaddingTop,
    double? navBarHeight,
    Widget? topBarTitle,
    Widget? heroImage,
    double? heroImageHeight,
    Color backgroundColor = Colors.white,
    bool hasSabGradient = true,
    bool forceMaxHeight = false,
    bool isTopBarLayerAlwaysVisible = false,
    bool hasTopBarLayer = true,
    ScrollController? scrollController,
    Widget? stickyActionBar,
    EdgeInsetsDirectional? mainContentPadding,
    Widget? leadingNavBarWidget,
    Widget? trailingNavBarWidget,
  }) {
    return WoltModalSheetPage(
      singleChildContent: child,
      pageTitle: pageTitle,
      topBarTitle: topBarTitle,
      isTopBarLayerAlwaysVisible: isTopBarLayerAlwaysVisible,
      hasTopBarLayer: hasTopBarLayer,
      heroImage: heroImage,
      heroImageHeight: heroImageHeight,
      backgroundColor: backgroundColor,
      hasSabGradient: hasSabGradient,
      forceMaxHeight: forceMaxHeight,
      scrollController: scrollController,
      stickyActionBar: stickyActionBar,
      mainContentPadding: mainContentPadding,
      leadingNavBarWidget: leadingNavBarWidget,
      trailingNavBarWidget: trailingNavBarWidget,
      navigationBarHeight: navBarHeight ?? _defaultNavBarHeight,
      pageTitlePaddingTop: pageTitlePaddingTop ?? _defaultPageTitlePaddingTop,
    );
  }

  /// Creates a [WoltModalSheetPage] with a custom [SliverList] main content.
  factory WoltModalSheetPage.withCustomSliverList({
    required Widget sliverList,
    Widget? pageTitle,
    double? pageTitlePaddingTop,
    double? topBarHeight,
    double? navBarHeight,
    Widget? topBarTitle,
    Widget? heroImage,
    double? heroImageHeight,
    Color backgroundColor = Colors.white,
    bool hasSabGradient = true,
    bool forceMaxHeight = false,
    bool isTopBarLayerAlwaysVisible = false,
    bool hasTopBarLayer = true,
    ScrollController? scrollController,
    Widget? stickyActionBar,
    EdgeInsetsDirectional? mainContentPadding,
    Widget? leadingNavBarWidget,
    Widget? trailingNavBarWidget,
  }) {
    return WoltModalSheetPage(
      sliverList: sliverList,
      pageTitle: pageTitle,
      pageTitlePaddingTop: pageTitlePaddingTop ?? _defaultPageTitlePaddingTop,
      navigationBarHeight: navBarHeight ?? _defaultNavBarHeight,
      topBarTitle: topBarTitle,
      heroImage: heroImage,
      heroImageHeight: heroImageHeight,
      backgroundColor: backgroundColor,
      forceMaxHeight: forceMaxHeight,
      scrollController: scrollController,
      stickyActionBar: stickyActionBar,
      mainContentPadding: mainContentPadding,
      leadingNavBarWidget: leadingNavBarWidget,
      trailingNavBarWidget: trailingNavBarWidget,
      hasTopBarLayer: hasTopBarLayer,
      isTopBarLayerAlwaysVisible: isTopBarLayerAlwaysVisible,
    );
  }
}
