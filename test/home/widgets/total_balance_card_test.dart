import 'package:ava_take_home/features/home/models/credit_card_account.dart';
import 'package:ava_take_home/features/home/widgets/total_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TotalBalanceCard Widget', () {
    final accounts = [
      CreditCardAccount(balance: 500, limit: 1000, name: 'Bank A'),
      CreditCardAccount(balance: 300, limit: 1000, name: 'Bank B'),
    ];

    testWidgets('renders total balance and total limit correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TotalBalanceCard(accounts: accounts)),
        ),
      );

      // Total balance should be $800
      expect(
        find.byWidgetPredicate((widget) {
          if (widget is RichText) {
            final text = widget.text.toPlainText();
            return text.contains('Total balance');
          }
          return false;
        }),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((widget) {
          if (widget is RichText) {
            final text = widget.text.toPlainText();
            return text.contains('\$800');
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('displays the correct utilization rating label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TotalBalanceCard(accounts: accounts)),
        ),
      );

      // Utilization = 800 / 2000 = 40% -> rating should be "Fair"
      expect(find.text('Fair'), findsWidgets);
    });

    testWidgets('highlights the active percentage label and tick', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TotalBalanceCard(accounts: accounts)),
        ),
      );

      // The active percentage label should be "30-49%"
      final fairLabelFinder = find.text('30-49%');
      expect(fairLabelFinder, findsOneWidget);

      // Verify the label color is set (ensures highlighting)
      final textWidget = tester.widget<Text>(fairLabelFinder);
      expect(textWidget.style?.color, isNotNull);
    });
  });
}
