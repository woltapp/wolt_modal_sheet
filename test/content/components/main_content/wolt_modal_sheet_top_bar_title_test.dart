import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_modal_sheet/src/content/components/main_content/wolt_modal_sheet_top_bar_title.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  group('WoltModalSheetTopBarTitle tests', () {
    // Global key to be used for pageTitle widget
    final GlobalKey pageTitleKey = GlobalKey();

    testWidgets('should display top bar title when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WoltModalSheetTopBarTitle(
              page: WoltModalSheetPage.withSingleChild(
                child: const SizedBox.shrink(),
                topBarTitle: const Text('Top Bar Title'),
                pageTitle: const Text('Page Title'),
              ),
              pageTitleKey: pageTitleKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Top Bar Title'), findsOneWidget);
      expect(find.text('Page Title'), findsNothing);
    });

    testWidgets(
        'should use page title when top bar title is not provided and page title is Text',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WoltModalSheetTopBarTitle(
              page: WoltModalSheetPage.withSingleChild(
                child: const SizedBox.shrink(),
                pageTitle: Text('Page Title', key: pageTitleKey),
              ),
              pageTitleKey: pageTitleKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Page Title'), findsOneWidget);
    });

    testWidgets(
        'should display nothing when neither top bar title nor page title is provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WoltModalSheetTopBarTitle(
              page: WoltModalSheetPage.withSingleChild(
                child: const SizedBox.shrink(),
              ),
              pageTitleKey: pageTitleKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(WoltModalSheetTopBarTitle).at(0)).size,
          Size.zero);
    });
  });
}
