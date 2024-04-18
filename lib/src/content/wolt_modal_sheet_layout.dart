import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/paginating_widgets_group.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_bottom_sheet_drag_handle.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _minInteractiveDimension = 48.0;

/// The layout for the Wolt Modal Sheet.
class WoltModalSheetLayout extends StatelessWidget {
  const WoltModalSheetLayout({
    required this.page,
    required this.paginatingWidgetsGroup,
    required this.woltModalType,
    required this.showDragHandle,
    Key? key,
  }) : super(key: key);

  final SliverWoltModalSheetPage page;
  final PaginatingWidgetsGroup paginatingWidgetsGroup;
  final WoltModalType woltModalType;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final hasTopBarLayer = page.hasTopBarLayer ??
        themeData?.hasTopBarLayer ??
        defaultThemeData.hasTopBarLayer;
    final topBarHeight = hasTopBarLayer
        ? (page.navBarHeight ??
            themeData?.navBarHeight ??
            defaultThemeData.navBarHeight)
        : 0.0;

    return Stack(
      children: [
        paginatingWidgetsGroup.mainContentAnimatedBuilder,
        if (showDragHandle)
          Positioned(
            child: GestureDetector(
              // By setting behavior to HitTestBehavior.opaque, the GestureDetector will capture touch
              // events even if its child (the drag handle) isn't the exact size of the gesture.
              // Effectively allowing the handler to capture drag gestures.
              behavior: HitTestBehavior.opaque,
              child: const Row(
                children: [
                  SizedBox(height: _minInteractiveDimension,),
                ],
              ),
            ),
          ),
        if (hasTopBarLayer)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: topBarHeight,
            child: paginatingWidgetsGroup.topBarAnimatedBuilder,
          ),
        if (showDragHandle)
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: WoltBottomSheetDragHandle(),
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
      ],
    );
  }
}
