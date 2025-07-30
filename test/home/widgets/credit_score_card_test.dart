import 'package:ava_take_home/features/home/widgets/credit_score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditScoreCard Widget', () {
    testWidgets('renders score, label, and delta correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testScore = 720;
      const testLabel = 'Good';
      const testDelta = 5;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CreditScoreCard(
              score: testScore,
              label: testLabel,
              delta: testDelta,
            ),
          ),
        ),
      );

      // Allow animation to start and credit score for finish animating.
      await tester.pump(const Duration(seconds: 1));

      // Assert
      expect(find.text('Credit Score'), findsOneWidget);
      expect(find.text('+${testDelta}pts'), findsOneWidget);
      expect(find.text(testLabel), findsOneWidget);

      // The numeric score appears
      expect(find.textContaining(testScore.toString()), findsOneWidget);
    });

    testWidgets('animates when score changes', (WidgetTester tester) async {
      // Arrange
      const initialScore = 600;
      const updatedScore = 750;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CreditScoreCard(score: initialScore, label: 'Fair', delta: 2),
          ),
        ),
      );

      // Act: rebuild widget with new score
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CreditScoreCard(
              score: updatedScore,
              label: 'Excellent',
              delta: 10,
            ),
          ),
        ),
      );

      // Allow animation to run
      await tester.pump(const Duration(seconds: 1));

      // Assert: new score and label should now be rendered
      expect(find.text('Excellent'), findsOneWidget);
      expect(find.textContaining(updatedScore.toString()), findsOneWidget);
    });
  });
}
