import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/wolt_bottom_sheet_drag_handle.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';
import 'package:wolt_modal_sheet/src/utils/drag_scroll_behavior.dart';

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
  /// [closeButton] represents the close button widget of the modal sheet.
  ///
  /// [backButton] represents the back button widget of the modal sheet.
  ///
  /// [stickyActionBar] represents the action widget located in the bottom of the modal sheet.
  ///
  /// [woltModalType] represents the type of the modal sheet.
  const WoltModalSheetLayout({
    required this.page,
    required this.mainContent,
    required this.topBar,
    required this.closeButton,
    required this.backButton,
    required this.stickyActionBar,
    required this.woltModalType,
    required this.topBarHeight,
    required this.topBarTranslationY,
    Key? key,
  }) : super(key: key);

  final WoltModalSheetPage page;
  final Widget mainContent;
  final Widget topBar;
  final Widget closeButton;
  final Widget backButton;
  final Widget stickyActionBar;
  final WoltModalType woltModalType;
  final double topBarHeight;
  final double topBarTranslationY;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const DragScrollBehavior(),
      child: Stack(
        children: [
          mainContent,
          Positioned(
            left: 0,
            right: 0,
            top: -1 * topBarTranslationY,
            height: topBarHeight + topBarTranslationY,
            child: topBar,
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            child: closeButton,
          ),
          PositionedDirectional(
            top: 0,
            start: 0,
            child: backButton,
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: stickyActionBar,
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
