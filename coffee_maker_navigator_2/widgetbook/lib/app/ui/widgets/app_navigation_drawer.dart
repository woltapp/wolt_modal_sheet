import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:coffee_maker_navigator_2/app/ui/widgets/app_navigation_drawer.dart';

@widgetbook.UseCase(name: 'Default', type: AppNavigationDrawer)
Widget buildCoolButtonUseCase(BuildContext context) {
  return AppNavigationDrawer(selectedIndex: context.knobs.int.input(label: 'selectedIndex'));
}
