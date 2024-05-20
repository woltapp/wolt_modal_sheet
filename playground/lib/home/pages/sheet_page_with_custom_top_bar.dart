import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A utility class for building a modal sheet page with a custom top bar.
class SheetPageWithCustomTopBar {
  // Prevent instantiation.
  SheetPageWithCustomTopBar._();

  static const double _placeholderHeight = 2000.0;

  static const ModalPageName pageId = ModalPageName.customTopBar;

  /// Builds and returns a [WoltModalSheetPage] with custom top bar.
  static WoltModalSheetPage build({bool isLastPage = true}) {
    return WoltModalSheetPage(
      id: pageId,
      backgroundColor: WoltColors.blue8,
      forceMaxHeight: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(builder: (context) {
          return WoltElevatedButton(
            onPressed: isLastPage
                ? Navigator.of(context).pop
                : WoltModalSheet.of(context).showNext,
            colorName: WoltColorName.blue,
            child: Text(isLastPage ? "Close" : "Next"),
          );
        }),
      ),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      isTopBarLayerAlwaysVisible: false,
      topBar: Builder(builder: (context) {
        return _CustomTopBar(
          onClosed: Navigator.of(context).pop,
          onBackPressed: WoltModalSheet.of(context).showPrevious,
        );
      }),
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
          Expanded(
            child: Padding(
              padding: _searchBarPadding,
              child: IconButton(
                onPressed: () {},
                tooltip: 'Search',
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
