import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/credit_card_account.dart';
import 'package:ava_take_home/features/home/widgets/credit_account_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditAccountCard Widget', () {
    late List<CreditCardAccount> accounts;

    setUp(() {
      accounts = [
        CreditCardAccount(
          name: 'Syncb/Amazon',
          balance: 1500,
          limit: 6300,
          reportedAt: DateTime(2023, 6, 20),
        ),
        CreditCardAccount(
          name: 'Capital One',
          balance: 200,
          limit: 4000,
          reportedAt: DateTime(2023, 6, 18),
        ),
      ];
    });

    testWidgets('renders both accounts with divider between them', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreditAccountCard(accounts: accounts)),
        ),
      );

      // Should find each account name
      expect(find.text('Syncb/Amazon'), findsOneWidget);
      expect(find.text('Capital One'), findsOneWidget);

      // Should find formatted utilization text for both (e.g., "24%" and "12%")
      expect(find.textContaining('%'), findsNWidgets(2));

      // Should find balance and limit texts
      expect(find.textContaining('1500'), findsOneWidget);
      expect(find.textContaining('6300'), findsOneWidget);
      expect(find.textContaining('200'), findsOneWidget);
      expect(find.textContaining('4000'), findsOneWidget);

      // Reported on text appears
      expect(find.textContaining('Reported on'), findsNWidgets(2));

      // Divider count is accounts.length - 1
      expect(find.byType(Divider), findsNWidgets(accounts.length - 1));
    });

    testWidgets('progress bar shows filled portion based on utilization', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreditAccountCard(accounts: accounts)),
        ),
      );

      // Let animation run
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Find the card for Syncb/Amazon
      final syncbCard = find.ancestor(
        of: find.text('Syncb/Amazon'),
        matching: find.byType(Card),
      );
      expect(syncbCard, findsOneWidget);

      // Inside that card, find the filled progress bar segment.
      // The implementation uses a FractionallySizedBox with a colored Container.
      final filledBar = find.descendant(
        of: syncbCard,
        matching: find.byWidgetPredicate((w) {
          if (w is FractionallySizedBox) {
            // its child is the filled bar
            return true;
          }
          if (w is Container && w.decoration is BoxDecoration) {
            final decoration = w.decoration as BoxDecoration;
            return decoration.color ==
                secondaryGreen; // match actual filled color
          }
          return false;
        }),
      );

      expect(filledBar, findsWidgets);
    });

    testWidgets('handles single account without extra divider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreditAccountCard(accounts: [accounts.first])),
        ),
      );

      expect(find.text('Syncb/Amazon'), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
    });
  });
}
