import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:playground/home/pages/root_sheet_page.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithInAppNavigation {
  SheetPageWithInAppNavigation._();

  static const ModalPageName pageId = ModalPageName.inAppNavigation;

  static WoltModalSheetPage build() {
    return WoltModalSheetPage(
      id: pageId,
      leadingNavBarWidget: const WoltModalSheetBackButton(),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      hasTopBarLayer: true,
      pageTitle: const ModalSheetTitle('In-modal navigation'),
      child: Builder(builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'This page demonstrates in-modal navigation within a modal '
                'sheet. Choose a button for testing a navigation option.',
              ),
              SizedBox(height: 16),
              _ButtonForAddSinglePageToStack(),
              SizedBox(height: 16),
              _ButtonForAddMultiplePagesToStack(),
              SizedBox(height: 16),
              _ButtonForReplaceCurrentPage(),
              SizedBox(height: 16),
              _ButtonForReplacePageWithId(),
              SizedBox(height: 16),
              _ButtonForReplaceAllPages(),
              SizedBox(height: 16),
              _ButtonForPopPage(),
              SizedBox(height: 16),
              _ButtonForRemovePage(),
              SizedBox(height: 16),
              _ButtonForShowAtIndex(),
              SizedBox(height: 16),
              _ButtonForShowPageWithId(),
              SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }
}

class _SinglePage extends WoltModalSheetPage {
  _SinglePage({
    required String text,
    required bool isLastPage,
    bool isFirstPage = false,
  }) : super(
          leadingNavBarWidget: isFirstPage
              ? const SizedBox.shrink()
              : const WoltModalSheetBackButton(),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
          hasTopBarLayer: false,
          stickyActionBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Builder(
              builder: (context) {
                return WoltElevatedButton(
                  onPressed: () => isLastPage
                      ? WoltModalSheet.of(context)
                          .removeUntil(RootSheetPage.pageId)
                      : WoltModalSheet.of(context).showNext(),
                  child: Text(isLastPage ? "Remove until root page" : "Next"),
                );
              },
            ),
          ),
          child: SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(text, style: const TextStyle(fontSize: 24)),
            ),
          ),
        );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showMessage(
  BuildContext context,
  String pageActionName,
) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(pageActionName)));
}

class _PageRow extends StatelessWidget {
  const _PageRow(
      {required this.primaryActionButton, this.secondaryActionButton});

  final Widget? secondaryActionButton;
  final Widget primaryActionButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 2, child: primaryActionButton),
        if (secondaryActionButton != null) ...[
          const SizedBox(width: 8),
          Flexible(child: secondaryActionButton!),
        ],
      ],
    );
  }
}

class _ButtonForAddSinglePageToStack extends StatelessWidget {
  const _ButtonForAddSinglePageToStack();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).addPage(
            _SinglePage(text: 'New single page', isLastPage: true),
          );
          _showMessage(context, 'Pushed single page');
        },
        child: const Text('Add single page to stack'),
      ),
      secondaryActionButton: WoltElevatedButton(
        onPressed: WoltModalSheet.of(context).showNext,
        child: const Text('Show next'),
      ),
    );
  }
}

class _ButtonForAddMultiplePagesToStack extends StatelessWidget {
  const _ButtonForAddMultiplePagesToStack();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).addOrReplacePages(
            [
              _SinglePage(text: 'First pushed page', isLastPage: false),
              _SinglePage(text: 'Second pushed page', isLastPage: true),
            ],
          );
          _showMessage(context, 'Pushed 2 new pages');
        },
        child: const Text('Add multiple pages to stack'),
      ),
      secondaryActionButton: WoltElevatedButton(
        onPressed: WoltModalSheet.of(context).showNext,
        child: const Text('Show next'),
      ),
    );
  }
}

class _ButtonForReplaceCurrentPage extends StatelessWidget {
  const _ButtonForReplaceCurrentPage();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).replaceCurrentPage(
            _SinglePage(text: 'Replaced page', isLastPage: true),
          );
          _showMessage(context, 'Replaced currentPage with a new page');
        },
        child: const Text('Replace current page'),
      ),
    );
  }
}

class _ButtonForReplacePageWithId extends StatelessWidget {
  const _ButtonForReplacePageWithId();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).replacePage(
            RootSheetPage.pageId,
            _SinglePage(
                text: 'Replaced page', isLastPage: false, isFirstPage: true),
          );
          _showMessage(context,
              'Replaced the root page with a new page. Press back to see it');
        },
        child: const Text('Replace previous page using id'),
      ),
    );
  }
}

class _ButtonForReplaceAllPages extends StatelessWidget {
  const _ButtonForReplaceAllPages();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).replaceAllPages(
            [
              _SinglePage(
                  text: 'First new page', isLastPage: false, isFirstPage: true),
              _SinglePage(text: 'Second new page', isLastPage: true),
            ],
            selectedPageIndex: 1,
          );
          _showMessage(context, 'Replaced all pages with 2 new pages');
        },
        child: const Text('Replace all pages'),
      ),
    );
  }
}

class _ButtonForPopPage extends StatelessWidget {
  const _ButtonForPopPage();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).popPage();
          _showMessage(context, 'Popped the page');
        },
        child: const Text('Pop page'),
      ),
    );
  }
}

class _ButtonForRemovePage extends StatelessWidget {
  const _ButtonForRemovePage();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).removePage(RootSheetPage.pageId);
          _showMessage(context, 'Removed the previous page');
        },
        child: const Text('Remove previous page using page id'),
      ),
    );
  }
}

class _ButtonForShowAtIndex extends StatelessWidget {
  const _ButtonForShowAtIndex();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).showAtIndex(0);
          _showMessage(context, 'Moved to page with index 0');
        },
        child: const Text('Show the page at index 0'),
      ),
    );
  }
}

class _ButtonForShowPageWithId extends StatelessWidget {
  const _ButtonForShowPageWithId();

  @override
  Widget build(BuildContext context) {
    return _PageRow(
      primaryActionButton: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.of(context).showPageWithId(RootSheetPage.pageId);
          _showMessage(
              context, 'Moved to page with id: ${RootSheetPage.pageId}');
        },
        child: const Text('Show the page with id: ${RootSheetPage.pageId}'),
      ),
    );
  }
}
