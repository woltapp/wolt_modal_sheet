import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Verify that the app page is displayed.
    expect(find.widgetWithText(ElevatedButton, 'Show Modal Sheet'), findsOneWidget);
  });
}
