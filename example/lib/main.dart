import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final pageIndexNotifier = ValueNotifier(0);

    WoltModalSheetPage page1(BuildContext modalSheetContext) {
      return WoltModalSheetPage.withSingleChild(
        stickyActionBar: StickyActionBarWrapper(
          child: Column(
            children: [
              WoltElevatedButton(
                onPressed: () => Navigator.of(modalSheetContext).pop(),
                theme: WoltElevatedButtonTheme.secondary,
                child: const Text('Cancel'),
              ),
              const SizedBox(height: 8),
              WoltElevatedButton(
                onPressed: () {
                  pageIndexNotifier.value = pageIndexNotifier.value + 1;
                },
                child: const Text('Next page'),
              ),
            ],
          ),
        ),
        pageTitle: const ModalSheetTitle('Pagination'),
        topBarTitle: const ModalSheetTopBarTitle('Pagination'),
        closeButton: WoltModalSheetCloseButton(onClosed: Navigator.of(modalSheetContext).pop),
        mainContentPadding: const EdgeInsetsDirectional.all(16),
        child: const Padding(
            padding: EdgeInsets.only(bottom: 120, top: 16),
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                '''
Pagination involves a sequence of screens the user navigates sequentially. We chose a lateral motion for these transitions. When proceeding forward, the next screen emerges from the right; moving backward, the screen reverts to its original position. We felt that sliding the next screen entirely from the right could be overly distracting. As a result, we decided to move and fade in the next page using 30% of the modal side.
''',
              ),
            )),
      );
    }

    WoltModalSheetPage page2(BuildContext modalSheetContext) {
      return WoltModalSheetPage.withCustomSliverList(
        mainContentPadding: EdgeInsetsDirectional.zero,
        stickyActionBar: StickyActionBarWrapper(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: WoltElevatedButton(
              onPressed: () {
                Navigator.of(modalSheetContext).pop();
                pageIndexNotifier.value = 0;
              },
              child: const Text('Close'),
            ),
          ),
        ),
        pageTitle: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ModalSheetTitle('Material Colors'),
        ),
        heroImageHeight: 200,
        heroImage: const Image(
          image: AssetImage('lib/assets/images/material_colors_hero.png'),
          fit: BoxFit.cover,
        ),
        topBarTitle: const ModalSheetTopBarTitle('Material Colors'),
        backButton: WoltModalSheetBackButton(onBackPressed: () {
          pageIndexNotifier.value = pageIndexNotifier.value - 1;
        }),
        closeButton: WoltModalSheetCloseButton(onClosed: () {
          Navigator.of(modalSheetContext).pop();
          pageIndexNotifier.value = 0;
        }),
        sliverList: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => ColorTile(color: allMaterialColors[index]),
            childCount: allMaterialColors.length,
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: SizedBox(
                width: 200,
                child: WoltElevatedButton(
                  onPressed: () {
                    WoltModalSheet.show<void>(
                      pageIndexNotifier: pageIndexNotifier,
                      context: context,
                      pageListBuilderNotifier: (modalSheetContext) {
                        return [
                          page1(modalSheetContext),
                          page2(modalSheetContext),
                        ];
                      },
                      modalTypeBuilder: (context) {
                        final size = MediaQuery.of(context).size.width;
                        if (size < 768) {
                          return WoltModalType.bottomSheet;
                        } else {
                          return WoltModalType.dialog;
                        }
                      },
                      onModalDismissedWithBarrierTap: () {
                        debugPrint('Closed modal sheet with barrier tap');
                        pageIndexNotifier.value = 0;
                      },
                      maxDialogWidth: 560,
                      minDialogWidth: 400,
                      minPageHeight: 0.4,
                      maxPageHeight: 0.9,
                    );
                  },
                  child: const Text('Show Wolt Modal Sheet'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final Color color;

  const ColorTile({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 100,
      child: Center(
        child: Text(
          color.toString(),
          style: TextStyle(
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

List<Color> get allMaterialColors {
  List<Color> allMaterialColorsWithShades = [];

  for (MaterialColor color in Colors.primaries) {
    allMaterialColorsWithShades.add(color.shade100);
    allMaterialColorsWithShades.add(color.shade200);
    allMaterialColorsWithShades.add(color.shade300);
    allMaterialColorsWithShades.add(color.shade400);
    allMaterialColorsWithShades.add(color.shade500);
    allMaterialColorsWithShades.add(color.shade600);
    allMaterialColorsWithShades.add(color.shade700);
    allMaterialColorsWithShades.add(color.shade800);
    allMaterialColorsWithShades.add(color.shade900);
  }
  return allMaterialColorsWithShades;
}
