import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:playground/home/pages/multi_page_path_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSlowAnimation = false;

  final pageIndexNotifier = ValueNotifier(0);

  late ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;

  void goToNextPage() => pageIndexNotifier.value = pageIndexNotifier.value + 1;

  void goToPreviousPage() => pageIndexNotifier.value = pageIndexNotifier.value - 1;

  void close(BuildContext context) {
    Navigator.of(context).pop();
    pageIndexNotifier.value = 0;
  }

  void onPathSelected(MultiPagePathName path) {
    pageListBuilderNotifier.value = path.pageListBuilder(
      goToNextPage: goToNextPage,
      goToPreviousPage: goToPreviousPage,
      close: close,
      onMultiPagePathSelected: onPathSelected,
    );
  }

  @override
  void initState() {
    super.initState();
    pageListBuilderNotifier = ValueNotifier<WoltModalSheetPageListBuilder>(
      MultiPagePathName.defaultPath.pageListBuilder(
        goToNextPage: goToNextPage,
        goToPreviousPage: goToPreviousPage,
        close: close,
        onMultiPagePathSelected: (newFlowName) => onPathSelected(newFlowName),
      ),
    )..addListener(() {
      // Reset page index when page list changes.
      pageIndexNotifier.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wolt Modal Sheet Playground'),
        actions: [
          WoltCircularElevatedButton(
            onPressed: () {
              setState(() {
                timeDilation = isSlowAnimation ? 1.0 : 8.0;
                isSlowAnimation = !isSlowAnimation;
              });
            },
            icon: Icons.speed_outlined,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Builder(builder: (context) {
        return Center(
          child: SizedBox(
            width: 200,
            child: WoltElevatedButton(
              onPressed: () {
                WoltModalSheet.show(
                  pageIndexNotifier: pageIndexNotifier,
                  context: context,
                  pageListBuilderNotifier: pageListBuilderNotifier,
                  modalTypeBuilder: _modalTypeBuilder,
                  onModalDismissedWithBarrierTap: () => pageIndexNotifier.value = 0,
                  useSafeArea: true
                );
              },
              child: const Text('Show Modal Sheet'),
            ),
          ),
        );
      }),
    );
  }

  WoltModalType _modalTypeBuilder(BuildContext context) {
    switch (context.screenSize) {
      case WoltScreenSize.small:
        return WoltModalType.bottomSheet;
      case WoltScreenSize.large:
        return WoltModalType.dialog;
    }
  }
}
