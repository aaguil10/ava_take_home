import 'package:ava_take_home/features/home/models/credit_score.dart';
import 'package:ava_take_home/features/home/widgets/credit_score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditScoreCard Widget', () {
    testWidgets('renders score, label, and delta correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final now = DateTime.now();
      final before = DateTime(
        now.year,
        now.month - 1,
        now.day,
        now.hour,
        now.minute,
        now.second,
      );

      final history = [
        CreditScore(value: 695, label: 'Good', dateTime: before),
        CreditScore(value: 697, label: 'Good', dateTime: now),
      ];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreditScoreCard(history: history)),
        ),
      );

      // Allow animation to start and credit score for finish animating.
      await tester.pump(const Duration(seconds: 1));

      // Assert
      expect(find.text('Credit Score'), findsOneWidget);
      expect(find.text('+2pts'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);

      // The numeric score appears
      expect(find.textContaining('697'), findsOneWidget);
    });
  });
}
