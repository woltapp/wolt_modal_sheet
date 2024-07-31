import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A [NonScrollingWoltModalSheetPage] is a specialized page for the [WoltModalSheet]
/// that is designed to display content which is flexible in height but unlikely
/// to require scrolling.
///
/// This class is designed for content that needs to adapt to the available
/// vertical space within the modal sheet's maximum height, but is unlikely
/// to exceed that height and require scrolling. It is ideal for content that
/// is flexible in height but has fixed (or intrinsic) dimensions and is laid
/// out using the [Flex] layout model of a [Column].
///
/// Warning:
/// - If there is a risk that the content's height might exceed the modal
///   sheet's maximum height, leading to overflow, it is recommended to use
///   [SliverWoltModalSheetPage] or [WoltModalSheetPage] instead. These classes
///   provide scrolling capabilities to handle larger content effectively using slivers.
class NonScrollingWoltModalSheetPage extends SliverWoltModalSheetPage {
  /// A [Widget] that represents the main content displayed in the page.
  /// This is a shortcut for providing a list of Sliver widgets with only one Sliver widget which
  /// is [SliverFillViewport].
  final Widget child;

  /// Creates a page to be built within [WoltScrollableModalSheet].
  NonScrollingWoltModalSheetPage({
    required this.child,
    super.id,
    super.backgroundColor,
    super.enableDrag,
    super.leadingNavBarWidget,
    super.trailingNavBarWidget,
    super.hasTopBarLayer = false,
    super.resizeToAvoidBottomInset,
    super.topBar,
    super.topBarTitle,
    super.navBarHeight,
    super.useSafeArea,
    super.contentDraggable,
  }) : super(
          isTopBarLayerAlwaysVisible: hasTopBarLayer,
          mainContentSliversBuilder: (_) => [
            SliverFillViewport(delegate: SliverChildListDelegate([child])),
          ],
        );
}
