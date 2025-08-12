import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  testWidgets(
    'Should update pages when notifier changes',
    (WidgetTester tester) async {
      final pageListBuilderNotifier = ValueNotifier((BuildContext _) => [
            WoltModalSheetPage(child: const Text('Initial Page')),
          ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            final NavigatorState navigator = Navigator.of(context);
            return WoltModalSheet(
              pageListBuilderNotifier: pageListBuilderNotifier,
              pageIndexNotifier: ValueNotifier(0),
              onModalDismissedWithBarrierTap: () {},
              onModalDismissedWithDrag: () {},
              pageContentDecorator: null,
              modalDecorator: null,
              modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
              transitionAnimationController: null,
              route: WoltModalSheetRoute(
                pageListBuilderNotifier: pageListBuilderNotifier,
                transitionAnimationController:
                    AnimationController(vsync: navigator),
                barrierDismissible: true,
              ),
              enableDrag: null,
              showDragHandle: null,
              useSafeArea: false,
              extraNotifier: ValueNotifier(null),
            );
          }),
        ),
      );

      // Initial state check.
      expect(find.text('Initial Page'), findsOneWidget);

      // Update the notifier.
      pageListBuilderNotifier.value = (_) => [
            WoltModalSheetPage(child: const Text('Updated Page')),
          ];

      // Trigger the listener.
      pageListBuilderNotifier.notifyListeners();
      await tester.pumpAndSettle();

      // Check if the UI is updated.
      expect(find.text('Updated Page'), findsOneWidget);
    },
  );

  testWidgets(
    'Listener should be removed on dispose',
    (WidgetTester tester) async {
      final pageListBuilderNotifier = ValueNotifier((_) => [
            WoltModalSheetPage(child: const Text('Initial Page')),
          ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            final NavigatorState navigator = Navigator.of(context);
            return WoltModalSheet(
              pageListBuilderNotifier: pageListBuilderNotifier,
              pageIndexNotifier: ValueNotifier(0),
              onModalDismissedWithBarrierTap: () {},
              onModalDismissedWithDrag: () {},
              pageContentDecorator: null,
              modalDecorator: null,
              modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
              transitionAnimationController: null,
              extraNotifier: ValueNotifier(null),
              route: WoltModalSheetRoute(
                pageListBuilderNotifier: pageListBuilderNotifier,
                transitionAnimationController:
                    AnimationController(vsync: navigator),
                barrierDismissible: true,
              ),
              enableDrag: null,
              showDragHandle: null,
              useSafeArea: false,
            );
          }),
        ),
      );

      // Update the notifier after the widget is disposed.
      await tester.pumpWidget(Container()); // Dispose the widget.
      pageListBuilderNotifier.value = (_) => [
            WoltModalSheetPage(child: const Text('Should Not Update')),
          ];

      // Trigger the listener.
      pageListBuilderNotifier.notifyListeners();
      await tester.pumpAndSettle();

      // Since the widget is disposed, this text should not be found.
      expect(find.text('Should Not Update'), findsNothing);
    },
  );
}
