import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum AdjustTimeGridItemColors {
  normal(
    foregroundColor: WoltColors.blue,
    backgroundColor: WoltColors.blue8,
  ),
  warning(
    foregroundColor: WoltColors.yellow,
    backgroundColor: WoltColors.yellow8,
  ),
  alert(
    foregroundColor: WoltColors.red,
    backgroundColor: WoltColors.red8,
  );

  const AdjustTimeGridItemColors({
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final Color foregroundColor;
  final Color backgroundColor;
}

class AdjustTimeNotificationPage extends WoltModalSheetPage {
  AdjustTimeNotificationPage()
      : super(
          topBarTitle: const ModalSheetTopBarTitle('Adjust time'),
          isTopBarLayerAlwaysVisible: true,
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
          leadingNavBarWidget: const WoltModalSheetBackButton(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              key: const Key('confirmTaskBottomSheep-suggestedTimeGrid'),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 72,
              ),
              itemBuilder: (context, index) => _items[index],
              itemCount: _items.length,
            ),
          ),
        );

  static const pageId = 'adjust_time_notification_page';

  /// 9 items with different priority levels
  static const List<Widget> _items = [
    _GridItem(timeInMinutes: 26, colors: AdjustTimeGridItemColors.normal),
    _GridItem(timeInMinutes: 30, colors: AdjustTimeGridItemColors.normal),
    _GridItem(timeInMinutes: 34, colors: AdjustTimeGridItemColors.normal),
    _GridItem(timeInMinutes: 38, colors: AdjustTimeGridItemColors.normal),
    _GridItem(timeInMinutes: 42, colors: AdjustTimeGridItemColors.normal),
    _GridItem(timeInMinutes: 46, colors: AdjustTimeGridItemColors.warning),
    _GridItem(timeInMinutes: 50, colors: AdjustTimeGridItemColors.warning),
    _GridItem(timeInMinutes: 54, colors: AdjustTimeGridItemColors.alert),
    _GridItem(timeInMinutes: 58, colors: AdjustTimeGridItemColors.alert),
  ];
}

class _GridItem extends StatelessWidget {
  const _GridItem({
    required this.colors,
    required this.timeInMinutes,
  });

  final AdjustTimeGridItemColors colors;
  final int timeInMinutes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: colors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: Navigator.of(context).pop,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timeInMinutes.toString(),
              style: textTheme.headlineSmall!.copyWith(
                color: colors.foregroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'minutes',
              style: textTheme.labelMedium!
                  .copyWith(color: colors.foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
