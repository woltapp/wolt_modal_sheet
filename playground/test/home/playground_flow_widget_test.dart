import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:playground/main.dart';

void main() {
  testWidgets('home screen ...', (tester) async {
    PatrolTester $ = PatrolTester(
      tester: tester,
      config: const PatrolTesterConfig(),
    );
    await $.pumpWidget(const DemoApp(
      androidSdkVersion: 30,
    ));
    tester.view.physicalSize = const Size(400.0, 600.0);
    tester.view.devicePixelRatio = 1.0;

    //Page with forced max height and background color flow
    expect($('Wolt Modal Sheet Playground'), findsOneWidget);
    await $('Show Modal Sheet').tap();
    expect($('Choose a use case'), findsOneWidget);
    await $('Page with forced max height').tap();
    await $('Let\'s start!').tap();
    expect(
        $('Page with forced max height and background color'), findsAtLeast(1));
    await $('Close').tap();
    expect($('Page with forced max height and background color'), findsNothing);

    // Page with a hero image flow
    await $('Show Modal Sheet').tap();
    expect($('Choose a use case'), findsOneWidget);
    await $('Page with hero image').tap();
    await $('Let\'s start!').tap();
    expect($(Image), findsOneWidget);
    await $('Close').tap();

    // Page with lazy loading list flow
    await $('Show Modal Sheet').tap();
    expect($('Choose a use case'), findsOneWidget);
    await $('Page with lazy loading list').tap();
    await $('Let\'s start!').tap();
    expect($(SliverList), findsAtLeast(1));
    await $(WoltCircularElevatedButton).tap();

    //Page with auto-focus text field
    //TODO: Ask to manager Shouldn't textformfiel appear on the screen when the page is opened? If so, fix the bug first
    await $('Page with auto-focus text field').scrollTo().tap();
    await $('Let\'s start!').tap();
    expect($('Page with text field'), findsOneWidget);
    expect($(TextFormField), findsOneWidget);
    expect(FocusScope.of(tester.element($(TextFormField))).hasFocus, isTrue);
    await $('Fill the text field to enable').tap();
    await $(TextFormField).scrollTo().enterText('Hello');
    await $('Submit').tap();
    expect($('Page with text field'), findsNothing);

    //Page with custom top bar
    expect($('Wolt Modal Sheet Playground'), findsOneWidget);
    await $('Show Modal Sheet').tap();
    await $('Page with custom top bar').scrollTo().tap();
    await $('Let\'s start!').tap();
    //?: I couldn't find how to test custom top bar. I couldn't take opacity value of Flow.
    await $.scrollUntilExists(finder: $(Placeholder));
    expect(
        find.byWidgetPredicate((widget) =>
            widget.runtimeType.toString() == 'TopBarAnimatedBuilder'),
        findsOneWidget);
    await $('Close').tap();

    //Page with no title and no top bar
    await $('Show Modal Sheet').tap();
    await $('Page with no title and no top bar').scrollTo().tap();
    await $('Let\'s start!').tap();
    expect(
        find.byWidgetPredicate((widget) =>
            widget.runtimeType.toString() == 'TopBarAnimatedBuilder'),
        findsNothing);
    await $('Close').tap();

    //Page with dynamic properties
    await $('Show Modal Sheet').tap();
    await $('Page with dynamic properties').scrollTo().tap();
    await $('Let\'s start!').tap();
    expect($('Dynamic page properties'), findsOneWidget);
    await $(Switch).tap(); // disable Drag for WoLt Modal Sheet
    await tester.drag($('Dynamic page properties'),
        Offset(0, tester.view.physicalSize.height / 2));
    await tester.pumpAndSettle();
    expect($('Dynamic page properties'), findsOneWidget);

    await $(Switch).tap(); // enable Drag for Wolt Modal Sheet
    await tester.drag($('Dynamic page properties'),
        Offset(0, tester.view.physicalSize.height / 2));
    await tester.pumpAndSettle();
    expect($('Dynamic page properties'), findsNothing);
    //NonScrollingWoltModalSheetPage example
    await $('Show Modal Sheet').tap();
    await $('NonScrollingWoltModalSheetPage example').scrollTo().tap();
    await $('Let\'s start!').tap();

    expect($(SliverList), findsNothing);
    await $(WoltCircularElevatedButton).tap();

    // All the pages in one flow
    await $('All the pages in one flow').scrollTo().tap();
    await $('Let\'s start!').tap();
    // hero
    expect($(Image), findsOneWidget);
    await $('Next').tap();
    // lazy list
    expect($(SliverList), findsAtLeast(1));
    await $('Next').tap();

    // text field
    expect($(TextFormField), findsOneWidget);
    await $(TextFormField).scrollTo().enterText('Hello');
    await $('Submit').tap();
    // noTitleNoTopBar
    expect(
        find.byWidgetPredicate((widget) =>
            widget.runtimeType.toString() == 'TopBarAnimatedBuilder'),
        findsNothing);
    await $('Next').tap();
    // custom top bar
    expect(
        find.byWidgetPredicate((widget) =>
            widget.runtimeType.toString() == 'TopBarAnimatedBuilder'),
        findsOneWidget);
    await $('Next').tap();
    // dynamic page properties
    expect($('Dynamic page properties'), findsOneWidget);
    await $('Next').tap();
    //NonScrollingWoltModalSheetPage example
    expect($(SliverList), findsNothing);
    await $('Flex: 1\n Tap here to go to the next page').tap();
    // forcedMaxHeight
    expect(
        $('Page with forced max height and background color'), findsAtLeast(1));
    await $('Close').tap();
     expect($('Page with forced max height and background color'), findsNothing);
  });
}
