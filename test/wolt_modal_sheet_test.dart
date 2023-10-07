import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  group('Creating sheet', () {
    testWidgets('WoltModalSheet.show opens a sheet', (tester) async {
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
                        WoltModalSheetPage.withSingleChild(
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
      expect(exception.message, 'pageListBuilder must return a non-empty list.');
    });
  });

  group('Modal sheet barrier dismissible', () {
    testWidgets('WoltModalSheet does not dismiss on barrier tap if barrierDismissible is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(
            child: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  WoltModalSheet.show(
                    context: context,
                    barrierDismissible: false,
                    onModalDismissedWithDrag: () => Navigator.of(context).pop(),
                    pageListBuilder: (context) {
                      return <WoltModalSheetPage>[
                        WoltModalSheetPage.withSingleChild(
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

      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();
      expect(find.text('Wolt modal sheet page'), findsOneWidget);
    });

    testWidgets('WoltModalSheet dismisses on barrier tap if barrierDismissible is true',
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
                        WoltModalSheetPage.withSingleChild(
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

      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();
      expect(find.text('Wolt modal sheet page'), findsNothing);
    });
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

    expect(tester.takeException(), isNotNull);
  });

  testWidgets('WoltModalSheet.modalTypeBuilder defaults', (tester) async {
    const Size wideSize = Size(800.0, 600.0);
    const Size narrowSize = Size(300.0, 600.0);

    addTearDown(tester.view.reset);
    tester.view.physicalSize = wideSize;
    tester.view.devicePixelRatio = 1.0;

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
                      WoltModalSheetPage.withSingleChild(
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

    Finder sheetMaterial = find.byType(Material).last;

    // The default modalTypeBuilder should be a dialog on wide screens.
    expect(tester.getSize(sheetMaterial), const Size(320.0, 160.0));
    expect(tester.getTopLeft(sheetMaterial), const Offset(240.0, 220.0));

    // Configure to show the narrow layout.
    tester.view.physicalSize = narrowSize;
    await tester.pumpAndSettle();

    // The default modalTypeBuilder should be a bottom sheet on narrow screens.
    expect(tester.getSize(sheetMaterial), const Size(300.0, 160.0));
    expect(tester.getTopLeft(sheetMaterial), const Offset(0.0, 440.0));
  });
}
