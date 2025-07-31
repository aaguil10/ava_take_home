import 'package:ava_take_home/features/home/models/credit_score.dart';
import 'package:ava_take_home/features/home/widgets/credit_score_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditScoreChart', () {
    final history = [
      CreditScore(value: 600, label: 'Fair', dateTime: DateTime(2025, 1, 1)),
      CreditScore(value: 650, label: 'Fair', dateTime: DateTime(2025, 1, 2)),
      CreditScore(value: 700, label: 'Good', dateTime: DateTime(2025, 1, 3)),
      CreditScore(value: 750, label: 'Good', dateTime: DateTime(2025, 1, 4)),
      CreditScore(
        value: 800,
        label: 'Excellent',
        dateTime: DateTime(2025, 1, 5),
      ),
    ];

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreditScoreChart(history: history)),
        ),
      );
      expect(find.byType(CreditScoreChart), findsOneWidget);
    });

    testWidgets('displays correct labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreditScoreChart(history: history)),
        ),
      );
      expect(find.text("600"), findsWidgets);
      expect(find.text("650"), findsWidgets);
      expect(find.text("700"), findsWidgets);
    });
  });
}
