import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  Widget buildSheetWithShow({
    WoltModalType Function(BuildContext)? modalTypeBuilder,
    Widget Function(Widget)? pageContentDecorator,
    Widget Function(Widget)? modalDecorator,
    bool? barrierDismissible,
    List<WoltModalSheetPage> Function(BuildContext)? pageListBuilder,
    Color? modalBarrierColor,
  }) {
    return MaterialApp(
      home: Scaffold(body: Center(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                WoltModalSheet.show(
                  context: context,
                  modalTypeBuilder: modalTypeBuilder,
                  pageContentDecorator: pageContentDecorator,
                  modalDecorator: modalDecorator,
                  barrierDismissible: barrierDismissible,
                  modalBarrierColor: modalBarrierColor,
                  pageListBuilder: pageListBuilder ??
                      (context) {
                        return <WoltModalSheetPage>[
                          WoltModalSheetPage(
                            child: const Center(
                              child: Text('Wolt modal sheet page'),
                            ),
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
    );
  }

  Finder sheetPageMaterialFinder([WidgetTester? _]) {
    return find
        .ancestor(
          of: find.text('Wolt modal sheet page'),
          matching: find.byType(Material),
        )
        .first;
  }

  group('Opening sheet', () {
    testWidgets('WoltModalSheet.show opens a sheet page', (tester) async {
      await tester.pumpWidget(buildSheetWithShow());

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Wolt modal sheet page'), findsOneWidget);
    });

    testWidgets('Empty pageListBuilder throws an error', (tester) async {
      await tester.pumpWidget(buildSheetWithShow(
        pageListBuilder: (context) {
          return <WoltModalSheetPage>[];
        },
      ));

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      final AssertionError exception = tester.takeException() as AssertionError;
      expect(exception, isAssertionError);
      expect(
        exception.message,
        'pageListBuilder must return a non-empty list.',
      );
    });
  });

  group('barrierDismissible', () {
    testWidgets(
      'Does not dismiss on barrier tap if barrierDismissible is false',
      (tester) async {
        await tester.pumpWidget(buildSheetWithShow(barrierDismissible: false));

        await tester.tap(find.text('Open sheet'));
        await tester.pumpAndSettle();
        expect(find.text('Wolt modal sheet page'), findsOneWidget);

        // Tap on the barrier.
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();
        expect(find.text('Wolt modal sheet page'), findsOneWidget);
      },
    );

    testWidgets(
      'Does dismiss on barrier tap if barrierDismissible is true',
      (tester) async {
        await tester.pumpWidget(buildSheetWithShow(barrierDismissible: true));

        await tester.tap(find.text('Open sheet'));
        await tester.pumpAndSettle();
        expect(find.text('Wolt modal sheet page'), findsOneWidget);

        // Tap on the barrier.
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();
        expect(find.text('Wolt modal sheet page'), findsNothing);
      },
    );
  });

  testWidgets('Empty pageListBuilder throws an error', (tester) async {
    await tester.pumpWidget(buildSheetWithShow(
      pageListBuilder: (context) {
        return <WoltModalSheetPage>[];
      },
    ));

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNotNull);
  });

  testWidgets(
    'WoltModalSheet.modalTypeBuilder defaults - wide window size',
    (tester) async {
      Size viewSize = const Size(800.0, 600.0);
      Size sheetPageSize = const Size(524.0, 86.0);

      await tester.pumpWidget(buildSheetWithShow());

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      Finder sheetMaterial = sheetPageMaterialFinder(tester);

      // The default modalTypeBuilder should be a dialog on wide screens.
      expect(tester.getSize(sheetMaterial), sheetPageSize);
      expect(
        tester.getTopLeft(sheetMaterial),
        Offset((viewSize.width / 2) - (sheetPageSize.width / 2), 257.0),
      );
      expect(
        tester.getTopRight(sheetMaterial),
        Offset((viewSize.width / 2) + (sheetPageSize.width / 2), 257.0),
      );
    },
  );

  testWidgets(
    'WoltModalSheet.modalTypeBuilder defaults - narrow window size',
    (tester) async {
      Size viewSize = const Size(300.0, 600.0);
      Size sheetPageSize = Size(viewSize.width, 86.0);

      tester.view.physicalSize = viewSize;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildSheetWithShow());

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      Finder sheetMaterial = sheetPageMaterialFinder(tester);

      // The default modalTypeBuilder should be a bottom sheet on narrow screens.
      expect(tester.getSize(sheetMaterial), sheetPageSize);
      expect(tester.getTopLeft(sheetMaterial), const Offset(0.0, 514.0));
      expect(tester.getTopRight(sheetMaterial), Offset(viewSize.width, 514.0));
    },
    skip: true,
  ); // [Intended]: This is skipped due to a bug in the framework.

  testWidgets('Custom WoltModalSheet.modalTypeBuilder', (tester) async {
    await tester.pumpWidget(buildSheetWithShow(
      modalTypeBuilder: (context) {
        return WoltModalType.bottomSheet();
      },
    ));

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(sheetPageMaterialFinder(tester)),
      const Size(800.0, 86.0),
    );

    // Tap to dismiss the sheet.
    await tester.tapAt(const Offset(50, 50));
    await tester.pumpAndSettle();

    expect(find.text('Wolt modal sheet page'), findsNothing);

    await tester.pumpWidget(buildSheetWithShow(
      modalTypeBuilder: (context) {
        return WoltModalType.dialog();
      },
    ));

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(sheetPageMaterialFinder(tester)),
      const Size(524.0, 86.0),
    );

    // Tap to dismiss the sheet.
    await tester.tapAt(const Offset(50, 50));
    await tester.pumpAndSettle();

    expect(find.text('Wolt modal sheet page'), findsNothing);
    await tester.pumpWidget(buildSheetWithShow(
      barrierDismissible: true,
      modalTypeBuilder: (context) {
        return WoltModalType.alertDialog();
      },
    ));

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(sheetPageMaterialFinder(tester)),
      const Size(404.0, 86.0),
    );

    // Tap to dismiss the sheet.
    await tester.tapAt(const Offset(50, 50));
    await tester.pumpAndSettle();

    expect(find.text('Wolt modal sheet page'), findsNothing);

    await tester.pumpWidget(buildSheetWithShow(
      modalTypeBuilder: (context) {
        return WoltModalType.sideSheet();
      },
    ));

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(sheetPageMaterialFinder(tester)),
      const Size(524.0, 600.0),
    );
  });

  group("Decorators", () {
    testWidgets('Custom WoltModalSheet.modalDecorator', (tester) async {
      const Color coloredBoxColor = Color(0xFFFF0000);
      await tester.pumpWidget(buildSheetWithShow(
        modalDecorator: (child) {
          return ColoredBox(color: coloredBoxColor, child: child);
        },
      ));

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      expect(
        tester.widget<ColoredBox>(find.byType(ColoredBox).last).color,
        coloredBoxColor,
      );
      expect(
        tester.getSize(find.byType(ColoredBox).last),
        equals(const Size(800.0, 600.0)),
      );
    });

    testWidgets('Custom WoltModalSheet.pageContentDecorator', (tester) async {
      const Color coloredBoxColor = Color(0xFFFF00FF);
      await tester.pumpWidget(buildSheetWithShow(
        pageContentDecorator: (child) {
          return ColoredBox(color: coloredBoxColor, child: child);
        },
      ));

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      expect(
        tester.widget<ColoredBox>(find.byType(ColoredBox).last).color,
        coloredBoxColor,
      );
      expect(
        tester.getSize(find.byType(ColoredBox).last),
        equals(const Size(524.0, 86.0)),
      );
    });

    testWidgets(
      'getters return the correct page, page index and list of pages',
      (tester) async {
        const page1Id = 'page1';
        const page2Id = 'page2';
        final page1 =
            WoltModalSheetPage(child: const Text('Page 1'), id: page1Id);
        final page2 =
            WoltModalSheetPage(child: const Text('Page 2'), id: page2Id);

        await tester.pumpWidget(buildSheetWithShow(
          pageListBuilder: (_) => [page1, page2],
        ));

        await tester.tap(find.text('Open sheet'));
        await tester.pumpAndSettle();

        final WoltModalSheetState modal =
            WoltModalSheet.of(tester.element(find.text('Page 1')));

        expect(modal.pages.length, 2);
        expect(modal.pages[0].id, page1Id);
        expect(modal.pages[1].id, page2Id);
        expect(modal.currentPage, page1);
        expect(modal.currentPageIndex, 0);
        expect(modal.isAtFirstPage, isTrue);
        expect(modal.isAtLastPage, isFalse);

        // Go to next page
        modal.showNext();
        await tester.pumpAndSettle();

        expect(modal.pages.length, 2);
        expect(modal.pages[0].id, page1Id);
        expect(modal.pages[1].id, page2Id);
        expect(modal.currentPage, page2);
        expect(modal.currentPageIndex, 1);
        expect(modal.isAtFirstPage, isFalse);
        expect(modal.isAtLastPage, isTrue);
      },
    );
  });

  testWidgets('WoltModalSheet.modalBarrierColor defaults', (tester) async {
    Color barrierColor = Colors.black54;
    await tester.pumpWidget(buildSheetWithShow());

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    final ColoredBox coloredBox = tester.widget(find.byType(ColoredBox));
    expect(coloredBox.color, barrierColor);
  });

  testWidgets('Custom WoltModalSheet.modalBarrierColor', (tester) async {
    Color barrierColor = const Color(0xFFFF0000);
    await tester
        .pumpWidget(buildSheetWithShow(modalBarrierColor: barrierColor));

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    final ColoredBox coloredBox = tester.widget(find.byType(ColoredBox));
    expect(coloredBox.color, barrierColor);
  });
}
