import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  runApp(const MainApp());
}

const double _bottomPaddingForButton = 150.0;
const double _buttonHeight = 56.0;
const double _pagePadding = 16.0;
const double _pageBreakpoint = 768.0;
const double _heroImageHeight = 200.0;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final pageIndexNotifier = ValueNotifier(0);

    WoltModalSheetPage page1(BuildContext modalSheetContext, TextTheme textTheme) {
      return WoltModalSheetPage.withSingleChild(
        stickyActionBar: Padding(
          padding: const EdgeInsets.all(_pagePadding),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(modalSheetContext).pop(),
                child: const SizedBox(
                  height: _buttonHeight,
                  width: double.infinity,
                  child: Center(child: Text('Cancel')),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => pageIndexNotifier.value = pageIndexNotifier.value + 1,
                child: const SizedBox(
                  height: _buttonHeight,
                  width: double.infinity,
                  child: Center(child: Text('Next page')),
                ),
              ),
            ],
          ),
        ),
        topBarTitle: Text('Pagination', style: textTheme.titleSmall),
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
        child: const Padding(
            padding: EdgeInsets.fromLTRB(
              _pagePadding,
              _pagePadding,
              _pagePadding,
              _bottomPaddingForButton,
            ),
            child: Text(
              '''
Pagination involves a sequence of screens the user navigates sequentially. We chose a lateral motion for these transitions. When proceeding forward, the next screen emerges from the right; moving backward, the screen reverts to its original position. We felt that sliding the next screen entirely from the right could be overly distracting. As a result, we decided to move and fade in the next page using 30% of the modal side.
''',
            )),
      );
    }

    WoltModalSheetPage page2(BuildContext modalSheetContext, TextTheme textTheme) {
      return WoltModalSheetPage.withCustomSliverList(
        stickyActionBar: Padding(
          padding: const EdgeInsets.fromLTRB(_pagePadding, 0, _pagePadding, _pagePadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(modalSheetContext).pop();
              pageIndexNotifier.value = 0;
            },
            child: const SizedBox(
              height: _buttonHeight,
              width: double.infinity,
              child: Center(child: Text('Close')),
            ),
          ),
        ),
        pageTitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _pagePadding),
          child: Text(
            'Material Colors',
            style: textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        heroImageHeight: _heroImageHeight,
        heroImage: const Image(
          image: AssetImage('lib/assets/images/material_colors_hero.png'),
          fit: BoxFit.cover,
        ),
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
        ),
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(modalSheetContext).pop();
            pageIndexNotifier.value = 0;
          },
        ),
        sliverList: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => ColorTile(color: allMaterialColors[index]),
            childCount: allMaterialColors.length,
          ),
        ),
      );
    }

    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: const Color(0xFF009DE0), useMaterial3: true),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: SizedBox(
                width: _heroImageHeight,
                child: ElevatedButton(
                  onPressed: () {
                    WoltModalSheet.show<void>(
                      pageIndexNotifier: pageIndexNotifier,
                      context: context,
                      pageListBuilder: (modalSheetContext) {
                        final textTheme = Theme.of(context).textTheme;
                        return [
                          page1(modalSheetContext, textTheme),
                          page2(modalSheetContext, textTheme),
                        ];
                      },
                      modalTypeBuilder: (context) {
                        final size = MediaQuery.of(context).size.width;
                        if (size < _pageBreakpoint) {
                          return WoltModalType.bottomSheet;
                        } else {
                          return WoltModalType.dialog;
                        }
                      },
                      onModalDismissedWithBarrierTap: () {
                        debugPrint('Closed modal sheet with barrier tap');
                        Navigator.of(context).pop();
                        pageIndexNotifier.value = 0;
                      },
                      maxDialogWidth: 560,
                      minDialogWidth: 400,
                      minPageHeight: 0.4,
                      maxPageHeight: 0.9,
                    );
                  },
                  child: const SizedBox(
                    height: _buttonHeight,
                    child: Center(child: Text('Show Modal Sheet')),
                  ),
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
