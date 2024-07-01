import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  group('Opening sheet', () {
    testWidgets('WoltModalSheet.show opens a sheet page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(
            child: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  WoltModalSheet.show(
                    context: context,
                    pageListBuilder: (context) {
                      return <WoltModalSheetPage>[
                        WoltModalSheetPage(
                          child: const Text('Wolt modal sheet page'),
                        ),
                      ];
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            }),
          )),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Wolt modal sheet page'), findsOneWidget);
    });

    testWidgets('Empty pageListBuilder throws an error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(
            child: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  WoltModalSheet.show(
                    context: context,
                    pageListBuilder: (context) {
                      return <WoltModalSheetPage>[];
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            }),
          )),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      final AssertionError exception = tester.takeException() as AssertionError;
      expect(exception, isAssertionError);
      expect(
          exception.message, 'pageListBuilder must return a non-empty list.');
    });
  });

  group('WoltModalSheet State Management', () {
    testWidgets('should update pages when notifier changes',
        (WidgetTester tester) async {
      final pageListBuilderNotifier = ValueNotifier((BuildContext _) => [
            WoltModalSheetPage(
              child: const Text('Initial Page'),
            ),
          ]);

      await tester.pumpWidget(
        MaterialApp(
          home: WoltModalSheet(
            pageListBuilderNotifier: pageListBuilderNotifier,
            pageIndexNotifier: ValueNotifier(0),
            onModalDismissedWithBarrierTap: () {},
            onModalDismissedWithDrag: () {},
            decorator: null,
            modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
            transitionAnimationController: null,
            route: WoltModalSheetRoute<void>(
                pageListBuilderNotifier: pageListBuilderNotifier),
            enableDrag: null,
            showDragHandle: null,
            useSafeArea: false,
          ),
        ),
      );

      // Initial state check
      expect(find.text('Initial Page'), findsOneWidget);

      // Update the notifier
      pageListBuilderNotifier.value = (_) => [
            WoltModalSheetPage(child: const Text('Updated Page')),
          ];

      // Trigger the listener
      pageListBuilderNotifier.notifyListeners();
      await tester.pumpAndSettle();

      // Check if the UI is updated
      expect(find.text('Updated Page'), findsOneWidget);
    });

    testWidgets('listener should be removed on dispose',
        (WidgetTester tester) async {
      final pageListBuilderNotifier = ValueNotifier((_) => [
            WoltModalSheetPage(child: const Text('Initial Page')),
          ]);

      await tester.pumpWidget(
        MaterialApp(
          home: WoltModalSheet(
            pageListBuilderNotifier: pageListBuilderNotifier,
            pageIndexNotifier: ValueNotifier(0),
            onModalDismissedWithBarrierTap: () {},
            onModalDismissedWithDrag: () {},
            decorator: null,
            modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
            transitionAnimationController: null,
            route: WoltModalSheetRoute<void>(
                pageListBuilderNotifier: pageListBuilderNotifier),
            enableDrag: null,
            showDragHandle: null,
            useSafeArea: false,
          ),
        ),
      );

      // Update the notifier after the widget is disposed
      await tester.pumpWidget(Container()); // Dispose the widget
      pageListBuilderNotifier.value = (_) => [
            WoltModalSheetPage(child: const Text('Should Not Update')),
          ];

      // Trigger the listener
      pageListBuilderNotifier.notifyListeners();
      await tester.pumpAndSettle();

      // Since the widget is disposed, this text should not be found
      expect(find.text('Should Not Update'), findsNothing);
    });
  });

  group('barrierDismissible', () {
    testWidgets(
        'Does not dismiss on barrier tap if barrierDismissible is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    WoltModalSheet.show(
                      context: context,
                      barrierDismissible: false,
                      onModalDismissedWithDrag: () =>
                          Navigator.of(context).pop(),
                      pageListBuilder: (context) {
                        return <WoltModalSheetPage>[
                          WoltModalSheetPage(
                            child: const Text('Wolt modal sheet page'),
                          ),
                        ];
                      },
                    );
                  },
                  child: const Text('Open sheet'),
                );
              },
            ),
          )),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Wolt modal sheet page'), findsOneWidget);

      // Tap on the barrier.
      await tester.tapAt(const Offset(50, 50));
      await tester.pumpAndSettle();
      expect(find.text('Wolt modal sheet page'), findsOneWidget);
    });

    testWidgets('Does dismiss on barrier tap if barrierDismissible is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(
            child: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  WoltModalSheet.show(
                    context: context,
                    barrierDismissible: true,
                    pageListBuilder: (context) {
                      return <WoltModalSheetPage>[
                        WoltModalSheetPage(
                          child: const Text('Wolt modal sheet page'),
                        ),
                      ];
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            }),
          )),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Wolt modal sheet page'), findsOneWidget);

      // Tap on the barrier.
      await tester.tapAt(const Offset(50, 50));
      await tester.pumpAndSettle();
      expect(find.text('Wolt modal sheet page'), findsNothing);
    });
  });

  testWidgets('Empty pageListBuilder throws an error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  WoltModalSheet.show(
                    context: context,
                    pageListBuilder: (context) {
                      return <WoltModalSheetPage>[];
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            },
          ),
        )),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNotNull);
  });

  testWidgets('WoltModalSheet.modalTypeBuilder defaults - default window size',
      (tester) async {
    Size viewSize = const Size(800.0, 600.0);
    Size sheetPageSize = const Size(400.0, 71.0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  WoltModalSheet.show(
                    context: context,
                    pageListBuilder: (context) {
                      return <WoltModalSheetPage>[
                        WoltModalSheetPage(
                          child: const Text('Wolt modal sheet page'),
                        ),
                      ];
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            },
          ),
        )),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    Finder sheetMaterial = find.byType(Material).last;

    // The default modalTypeBuilder should be a dialog on wide screens.
    expect(tester.getSize(sheetMaterial), sheetPageSize);
    expect(tester.getTopLeft(sheetMaterial),
        Offset((viewSize.width / 2) - (sheetPageSize.width / 2), 253.0));
    expect(tester.getTopRight(sheetMaterial),
        Offset((viewSize.width / 2) + (sheetPageSize.width / 2), 253.0));
  });

  testWidgets('WoltModalSheet.modalTypeBuilder defaults - narrow window size',
      (tester) async {
    Size viewSize = const Size(300.0, 600.0);
    Size sheetPageSize = Size(viewSize.width, 71.0);

    tester.view.physicalSize = viewSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  WoltModalSheet.show(
                    context: context,
                    pageListBuilder: (context) {
                      return <WoltModalSheetPage>[
                        WoltModalSheetPage(
                          child: const Text('Wolt modal sheet page'),
                        ),
                      ];
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            },
          ),
        )),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    Finder sheetMaterial = find.byType(Material).last;

    // The default modalTypeBuilder should be a bottom sheet on narrow screens.
    expect(tester.getSize(sheetMaterial), sheetPageSize);
    expect(tester.getTopLeft(sheetMaterial), const Offset(0.0, 504.0));
    expect(tester.getTopRight(sheetMaterial), Offset(viewSize.width, 504.0));
  }, skip: true); // [Intended]: This is skipped due to a bug in the framework.
}
