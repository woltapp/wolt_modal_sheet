import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/components/paginating_group/paginating_widgets_group.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_bottom_sheet_drag_handle.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// The layout for the Wolt Modal Sheet.
class WoltModalSheetLayout extends StatelessWidget {
  const WoltModalSheetLayout({
    required this.page,
    required this.paginatingWidgetsGroup,
    required this.woltModalType,
    required this.topBarTranslationY,
    required this.showDragHandle,
    Key? key,
  }) : super(key: key);

  final WoltModalSheetPage page;
  final PaginatingWidgetsGroup paginatingWidgetsGroup;
  final WoltModalType woltModalType;
  final double topBarTranslationY;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final hasTopBarLayer =
        page.hasTopBarLayer ?? themeData?.hasTopBarLayer ?? defaultThemeData.hasTopBarLayer;
    final topBarHeight = hasTopBarLayer
        ? (page.navBarHeight ?? themeData?.navBarHeight ?? defaultThemeData.navBarHeight)
        : 0.0;
    return Stack(
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
