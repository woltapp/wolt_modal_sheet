import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_base_page.dart';

class WoltModalSheetSliverPage extends WoltModalSheetBasePage {
  /// The slivers to place inside the main content.
  final List<Widget> slivers;

  /// Creates a [WoltModalSheetSliverPage] with a single child main content.
  WoltModalSheetSliverPage({
    required this.slivers,
    Widget? pageTitle,
    double? navBarHeight,
    Widget? topBarTitle,
    Widget? heroImage,
    double? heroImageHeight,
    Color? backgroundColor,
    bool? hasSabGradient,
    Color? sabGradientColor,
    bool? enableDrag,
    bool forceMaxHeight = false,
    bool? isTopBarLayerAlwaysVisible,
    bool? hasTopBarLayer,
    ScrollController? scrollController,
    Widget? stickyActionBar,
    Widget? leadingNavBarWidget,
    Widget? trailingNavBarWidget,
    Widget? topBar,
  }) : super(
          mainContent: slivers,
          pageTitle: pageTitle,
          navBarHeight: navBarHeight,
          topBarTitle: topBarTitle,
          heroImage: heroImage,
          heroImageHeight: heroImageHeight,
          backgroundColor: backgroundColor,
          hasSabGradient: hasSabGradient,
          enableDrag: enableDrag,
          sabGradientColor: sabGradientColor,
          forceMaxHeight: forceMaxHeight,
          isTopBarLayerAlwaysVisible: isTopBarLayerAlwaysVisible,
          hasTopBarLayer: hasTopBarLayer,
          scrollController: scrollController,
          stickyActionBar: stickyActionBar,
          leadingNavBarWidget: leadingNavBarWidget,
          trailingNavBarWidget: trailingNavBarWidget,
          topBar: topBar,
        );

  WoltModalSheetSliverPage copyWith({
    Widget? pageTitle,
    double? navBarHeight,
    Widget? sliverList,
    List<Widget>? slivers,
    Widget? topBarTitle,
    Widget? heroImage,
    double? heroImageHeight,
    Color? backgroundColor,
    bool? hasSabGradient,
    Color? sabGradientColor,
    bool? enableDrag,
    bool? forceMaxHeight,
    bool? isTopBarLayerAlwaysVisible,
    bool? hasTopBarLayer,
    ScrollController? scrollController,
    Widget? stickyActionBar,
    Widget? leadingNavBarWidget,
    Widget? trailingNavBarWidget,
    Widget? topBar,
  }) {
    return WoltModalSheetSliverPage(
      pageTitle: pageTitle ?? this.pageTitle,
      navBarHeight: navBarHeight ?? this.navBarHeight,
      slivers: slivers ?? this.slivers,
      topBarTitle: topBarTitle ?? this.topBarTitle,
      heroImage: heroImage ?? this.heroImage,
      heroImageHeight: heroImageHeight ?? this.heroImageHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hasSabGradient: hasSabGradient ?? this.hasSabGradient,
      sabGradientColor: sabGradientColor ?? this.sabGradientColor,
      enableDrag: enableDrag ?? this.enableDrag,
      forceMaxHeight: forceMaxHeight ?? this.forceMaxHeight,
      isTopBarLayerAlwaysVisible: isTopBarLayerAlwaysVisible ?? this.isTopBarLayerAlwaysVisible,
      hasTopBarLayer: hasTopBarLayer ?? this.hasTopBarLayer,
      scrollController: scrollController ?? this.scrollController,
      stickyActionBar: stickyActionBar ?? this.stickyActionBar,
      leadingNavBarWidget: leadingNavBarWidget ?? this.leadingNavBarWidget,
      trailingNavBarWidget: trailingNavBarWidget ?? this.trailingNavBarWidget,
      topBar: topBar ?? this.topBar,
    );
  }
}
