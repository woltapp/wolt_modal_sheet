import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/paginating_widgets_group.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';
import 'package:wolt_modal_sheet/src/utils/drag_scroll_behavior.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_bottom_sheet_drag_handle.dart';

/// The layout for the Wolt Modal Sheet.
class WoltModalSheetLayout extends StatelessWidget {
  /// Creates a [WoltModalSheetLayout].
  ///
  /// [page] represents the page configuration for the modal sheet.
  ///
  /// [mainContent] represents the main content widget of the modal sheet.
  ///
  /// [topBar] represents the top bar widget of the modal sheet.
  ///
  /// [trailingNavBarWidget] represents the close button widget of the modal sheet.
  ///
  /// [leadingNavBarWidget] represents the back button widget of the modal sheet.
  ///
  /// [stickyActionBar] represents the action widget located in the bottom of the modal sheet.
  ///
  /// [woltModalType] represents the type of the modal sheet.
  const WoltModalSheetLayout({
    required this.page,
    required this.paginatingWidgetsGroup,
    required this.woltModalType,
    required this.topBarHeight,
    required this.topBarTranslationY,
    Key? key,
  }) : super(key: key);

  final WoltModalSheetPage page;
  final PaginatingWidgetsGroup paginatingWidgetsGroup;
  final WoltModalType woltModalType;
  final double topBarHeight;
  final double topBarTranslationY;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const DragScrollBehavior(),
      child: Stack(
        children: [
          paginatingWidgetsGroup.mainContentAnimatedBuilder,
          Positioned(
            left: 0,
            right: 0,
            top: -1 * topBarTranslationY,
            height: topBarHeight + topBarTranslationY,
            child: paginatingWidgetsGroup.topBarAnimatedBuilder,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: paginatingWidgetsGroup.navigationToolbarAnimatedBuilder,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: paginatingWidgetsGroup.sabAnimatedBuilder,
          ),
          if (woltModalType == WoltModalType.bottomSheet)
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: WoltBottomSheetDragHandle(),
            ),
        ],
      ),
    );
  }
}
