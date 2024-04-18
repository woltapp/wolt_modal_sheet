import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A utility class for building a modal sheet page with a custom top bar.
class SheetPageWithCustomTopBar {
  // Prevent instantiation.
  SheetPageWithCustomTopBar._();

  static const double _placeholderHeight = 2000.0;

  /// Builds and returns a [WoltModalSheetPage] with custom top bar.
  static WoltModalSheetPage build({
    required VoidCallback onSabPressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    bool isLastPage = true,
  }) {
    return WoltModalSheetPage(
      backgroundColor: WoltColors.blue8,
      forceMaxHeight: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WoltElevatedButton(
          onPressed: onSabPressed,
          colorName: WoltColorName.blue,
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: onClosed),
      topBar: _CustomTopBar(onClosed: onClosed, onBackPressed: onBackPressed),
      pageTitle: const ModalSheetTitle('Page with custom top bar'),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                'Scroll to see the custom top bar with a search field in it.'),
          ),
          Placeholder(
              fallbackHeight: _placeholderHeight, color: WoltColors.blue),
        ],
      ),
    );
  }
}

/// A custom top bar with a gradient background and a search bar.
class _CustomTopBar extends StatelessWidget {
  const _CustomTopBar({required this.onClosed, required this.onBackPressed});

  static const _searchBarPadding =
      EdgeInsetsDirectional.only(start: 64, top: 16, bottom: 16, end: 0);

  final VoidCallback onClosed;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: ModalSheetTitle('Feeling lucky?')),
          const Spacer(),
          Padding(
            padding: _searchBarPadding,
            child: IconButton(
              onPressed: () {
                WoltModalSheet.show(
                  context: context,
                  modalTypeBuilder: (context) => WoltModalType.dialog,
                  pageListBuilder: (sheetContext) => [
                    WoltModalSheetPage(
                      child: const SizedBox(),
                      topBarTitle: const ModalSheetTitle(
                        'Custom tab bar action!',
                        textAlign: TextAlign.center,
                      ),
                      isTopBarLayerAlwaysVisible: true,
                    )
                  ],
                );
              },
              tooltip: 'Custom Action',
              icon: const Icon(Icons.accessibility, color: Colors.white,),
            ),
          ),
          const SizedBox(width: 70,),
        ],
      ),
    );
  }
}
