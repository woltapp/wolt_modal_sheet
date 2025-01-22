import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_modal_sheet/src/widgets/wolt_navigation_toolbar.dart';

void main() {
  testWidgets(
    'Leading/Trailing widget constaints',
    (tester) async {
      const IconData leadingIcon = Icons.chevron_left;
      const IconData trailingIcon = Icons.chevron_right;
      const double iconSize = 24.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: SizedBox(
                height: 72.0,
                child: WoltNavigationToolbar(
                  leading: const ColoredBox(
                    color: Color(0xFF00FF00),
                    child: Icon(leadingIcon),
                  ),
                  trailing: Container(
                    color: const Color(0xFFFF0000),
                    child: const Icon(trailingIcon),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final Size leadingSize = tester.getSize(find.ancestor(
          of: find.byIcon(leadingIcon), matching: find.byType(ColoredBox)));
      expect(leadingSize, const Size.square(iconSize));

      final Size trailingSize = tester.getSize(find.ancestor(
          of: find.byIcon(trailingIcon), matching: find.byType(ColoredBox)));
      expect(trailingSize, const Size.square(iconSize));
    },
  );
}
