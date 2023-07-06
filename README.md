WoltModalSheet is designed to revolutionize the use of Flutter modal sheets. Built with Wolt-grade design quality and used extensively in [Wolt](https://wolt.com/) products, this UI component offers a visually appealing and user-friendly modal sheet with multiple pages, motion animation for page transitions, and scrollable content within each page.

## Features

### Multi-Page Layout

Traverse through numerous pages within a single sheet.

![Experience multi-page navigation in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_multi.gif?raw=true)

### Scrollable Content

Greater flexibility with scrollable content per page, accommodating large content effortlessly.

![Scroll with ease in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_scrolling.gif?raw=true)

### Responsive Design

The modal sheet adjusts to fit all screen sizes, appearing as a dialog on larger screens and as a bottom sheet on smaller screens, guided by user-specified conditions.

![Adaptability to different screen sizes in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_responsive.gif?raw=true)

### Motion Animation

Engage users with dynamic motion animation for page transitions and scrolling.

| Pagination                                                                                                 | Scrolling                                                                                             |
| ---------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| ![Pagination](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_motion_pagination.gif?raw=true) | ![Scrolling](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_scroll_motion.gif?raw=true) |


### Imperative and Declarative Navigation

The library showcases examples of both imperative and declarative navigation patterns to display modal sheet on screen.

![Illustration of imperative and declarative navigation in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_navigator_2.gif?raw=true)

### Dynamic Pagination

User input can dynamically shape the modal sheet's page list.

![Dynamic pagination in action in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_dynamic_pagination.gif?raw=true)

### State Management Integration

Pages in the Wolt Modal Sheet offer a customizable look and the page components are supplied with the WoltModalSheetPage class instance. The API provides a way to manage the state among the page components to be used with popular libraries such as Bloc and Provider


## Getting started

To use this plugin, add wolt_modal_sheet as a dependency in your pubspec.yaml file.

## Usage

This package has 4 example projects.

### Example app

The `example` app demonstrates how to display a two-page modal sheet.

```dart

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
                  child: const Text('Show Wolt Modal Sheet'),
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```
The code snippet above produces the following:
</br>
</br>
![Dynamic pagination in action in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_onboarding.gif?raw=true)

### Playground app with imperative navigation

The `playground` app demonstrates how to imperatively show the modal sheet. The purpose of this module is to play and experiment with various use cases. These use cases include:
It demonstrates
- A page with forced max height independent of its content.
- A page with a hero image
- A page with a list whose items are lazily built.
- A page with a text field.

### Playground app with declarative navigation
The `playground_navigator2` has the same content with the `playground` app but the modal sheet is shown using Navigator 2.0 (Router API) in a declarative way.
### Coffee maker app for state management example
Finally, the `coffee_maker` app demonstrates how to manage the state among the page components with an opinionated use of the Provider state management library.

The code snippet demonstrates how to decorate the modal sheet with a change notifier provider so that the page components can be rebuilt according to the current state:
```dart
  void _onCoffeeOrderSelectedInAddWaterState(BuildContext context, String coffeeOrderId) {
  final model = context.read<StoreOnlineViewModel>();
  final pageIndexNotifier = ValueNotifier(0);

  WoltModalSheet.show(
    pageIndexNotifier: pageIndexNotifier,
    context: context,
    decorator: (child) {
      return ChangeNotifierProvider<StoreOnlineViewModel>.value(
        value: model,
        builder: (_, __) => child,
      );
    },
    pageListBuilderNotifier: AddWaterModalPageBuilder.build(
      coffeeOrderId: coffeeOrderId,
      goToPreviousPage: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
      goToNextPage: () => pageIndexNotifier.value = pageIndexNotifier.value + 1,
    ),
    modalTypeBuilder: _modalTypeBuilder,
  );
}
```
![Dynamic pagination in action in WoltModalSheet](https://github.com/woltapp/wolt_modal_sheet/blob/main/doc/ss_coffee_maker.gif?raw=true)

## Additional information
In [this blog post](https://careers.wolt.com/en/blog/engineering/an-overview-of-the-multi-page-scrollable-bottom-sheet-ui-design), we explore the foundational design decisions that guide the WoltModalSheet's functionality.

