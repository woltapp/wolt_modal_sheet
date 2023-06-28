import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPage extends Page<void> {

  const SheetPage({
    required this.pageIndexNotifier,
    required this.pageListBuilderNotifier,
    required this.modalTypeBuilder,
  }) : super(key: const ValueKey('SheetPage'));

  final ValueNotifier<int> pageIndexNotifier;
  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;
  final WoltModalType Function(BuildContext context) modalTypeBuilder;

  static const String routeName = 'Modal Sheet';

  @override
  Route<void> createRoute(BuildContext context) {
    return WoltModalSheetRoute<void>(
      pageIndexNotifier: pageIndexNotifier,
      modalTypeBuilder: modalTypeBuilder,
      pageListBuilderNotifier: pageListBuilderNotifier,
      routeSettings: this,
      useSafeArea: false,
    );
  }

  @override
  String get name => routeName;
}
