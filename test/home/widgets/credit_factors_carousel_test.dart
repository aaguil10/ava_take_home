import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/widgets/credit_factors_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditFactorsCarousel Widget', () {
    // Sample data
    final factors = [
      CreditFactor(
        name: 'Payment History',
        value: '100%',
        impact: 'HIGH IMPACT',
      ),
      CreditFactor(
        name: 'Credit Utilization',
        value: '4%',
        impact: 'LOW IMPACT',
      ),
      CreditFactor(name: 'Derogatory Marks', value: '0', impact: 'MED IMPACT'),
    ];

    testWidgets('renders all factor cards', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreditFactorsCarousel(factors: factors)),
        ),
      );

      // Each name should appear once
      for (final f in factors) {
        expect(find.text(f.name), findsOneWidget);
        expect(find.text(f.value), findsOneWidget);
        expect(find.text(f.impact), findsOneWidget);
      }

      // There should be exactly 3 cards in the list
      expect(find.byType(Card), findsNWidgets(factors.length));
    });

    testWidgets('scrolls horizontally to reveal offscreen cards', (
      tester,
    ) async {
      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              // shrink width so that not all cards fit at once
              width: 200,
              child: CreditFactorsCarousel(factors: factors),
            ),
          ),
        ),
      );

      // Initially, the last card is offscreen
      expect(find.text('Derogatory Marks'), findsNothing);

      // Scroll left by 300 pixels
      await tester.drag(find.byType(ListView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      // Now the last card should appear
      expect(find.text('Derogatory Marks'), findsOneWidget);
    });

    testWidgets('cards have correct button color and text style', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreditFactorsCarousel(factors: factors)),
        ),
      );

      // HIGH IMPACT button should have background textGreen
      final highBtn =
          find
                  .widgetWithText(ElevatedButton, 'HIGH IMPACT')
                  .evaluate()
                  .single
                  .widget
              as ElevatedButton;
      final highColor = (highBtn.style?.backgroundColor?.resolve({}));
      expect(highColor, equals(textGreen));

      // LOW IMPACT button text should be textGreen
      final lowText = tester.widget<Text>(
        find.descendant(
          of: find.widgetWithText(ElevatedButton, 'LOW IMPACT'),
          matching: find.byType(Text),
        ),
      );
      expect(lowText.style?.color, equals(textGreen));
    });
  });
}
