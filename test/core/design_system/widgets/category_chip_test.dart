import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/category_chip.dart';

void main() {
  group('CategoryChip Widget Tests', () {
    testWidgets('should render category label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'smartphones',
              isSelected: false,
              onSelected: () {},
            ),
          ),
        ),
      );

      // Label is formatted as 'Smartphones'
      expect(find.text('Smartphones'), findsOneWidget);
    });

    testWidgets('should show selection state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'laptops',
              isSelected: true,
              onSelected: () {},
            ),
          ),
        ),
      );

      final filterChip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(filterChip.selected, isTrue);
    });

    testWidgets('should trigger onSelected callback', (WidgetTester tester) async {
      bool selected = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'beauty',
              isSelected: false,
              onSelected: () => selected = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FilterChip));
      expect(selected, isTrue);
    });
  });
}
