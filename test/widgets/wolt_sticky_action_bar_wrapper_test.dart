import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_sticky_action_bar_wrapper.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  group('WoltStickyActionBarWrapper', () {
    group('Rendering', () {
      testWidgets('should render shrunk widget when stickyActionBar is null',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WoltStickyActionBarWrapper(
                page: WoltModalSheetPage(
                  stickyActionBar: null,
                  child: const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
            tester.element(find.byType(WoltStickyActionBarWrapper).at(0)).size,
            Size.zero);
      });

      testWidgets('should render stickyActionBar when provided',
          (tester) async {
        const testActionBar = Text("ActionBar");

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WoltStickyActionBarWrapper(
                page: WoltModalSheetPage(
                  stickyActionBar: testActionBar,
                  child: const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text("ActionBar"), findsOneWidget);
      });
    });

    group('Gradient visibility', () {
      testWidgets('should show gradient when hasSabGradient is true',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WoltStickyActionBarWrapper(
              page: WoltModalSheetPage(
                stickyActionBar: const Text("ActionBar"),
                child: const SizedBox.shrink(),
                hasSabGradient: true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(WoltStickyActionBarWrapper.gradientWidgetKey),
            findsOneWidget);
      });

      testWidgets('should not show gradient when hasSabGradient is false',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WoltStickyActionBarWrapper(
              page: WoltModalSheetPage(
                stickyActionBar: const Text("ActionBar"),
                hasSabGradient: false,
                child: const SizedBox.shrink(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(WoltStickyActionBarWrapper.gradientWidgetKey),
            findsNothing);
      });
    });
  });
}
