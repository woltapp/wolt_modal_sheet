import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/paginating_widgets_group.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';
import 'package:wolt_modal_sheet/src/utils/drag_scroll_behavior.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_bottom_sheet_drag_handle.dart';

/// The layout for the Wolt Modal Sheet.
class WoltModalSheetLayout extends StatelessWidget {
  const WoltModalSheetLayout({
    required this.page,
    required this.paginatingWidgetsGroup,
    required this.woltModalType,
    required this.topBarTranslationY,
    Key? key,
  }) : super(key: key);

  final WoltModalSheetPage page;
  final PaginatingWidgetsGroup paginatingWidgetsGroup;
  final WoltModalType woltModalType;
  final double topBarTranslationY;

  @override
  Widget build(BuildContext context) {
    final hasTopBarLayer = page.hasTopBarLayer;
    final topBarHeight = hasTopBarLayer ? page.navigationBarHeight : 0.0;
    final shouldShowDragHandle = woltModalType == WoltModalType.bottomSheet;
    return ScrollConfiguration(
      behavior: const DragScrollBehavior(),
      child: Stack(
        children: [
          paginatingWidgetsGroup.mainContentAnimatedBuilder,
          if (hasTopBarLayer)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: topBarHeight,
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
          if (shouldShowDragHandle)
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
