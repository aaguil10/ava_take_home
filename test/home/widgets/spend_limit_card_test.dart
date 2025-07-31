import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/account_details.dart';
import 'package:ava_take_home/features/home/widgets/spend_limit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpendLimitCard Widget', () {
    // Sample account details: $30 balance, $600 credit limit, $100 spend limit, $75 spent.
    final accountDetails = AccountDetails(
      balance: 30,
      creditLimit: 600,
      spendLimit: 100,
      currentSpend: 75,
    );

    testWidgets('renders labels and values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SpendLimitCard(accountDetails: accountDetails)),
        ),
      );

      // Header/spend limit line
      expect(find.text('Spend limit: \$100'), findsOneWidget);
      expect(find.text('Why is it different?'), findsOneWidget);

      // Balance and credit limit
      expect(find.text('\$30'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('\$600'), findsOneWidget);
      expect(find.text('Credit limit'), findsOneWidget);

      // Utilization computed as balance / creditLimit = 30/600 = 0.05 -> 5%
      expect(find.text('Utilization'), findsOneWidget);
      expect(find.text('5%'), findsOneWidget);
    });

    testWidgets('shows current spend tooltip after animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SpendLimitCard(accountDetails: accountDetails)),
        ),
      );

      // Initial frame - animation begins
      await tester.pump(); // start animation

      // Tooltip should show "$75" (currentSpend)
      expect(find.text('\$75'), findsOneWidget);
    });

    testWidgets('progress bar and markers layout exists', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SpendLimitCard(accountDetails: accountDetails)),
        ),
      );

      // Allow animation to settle
      await tester.pumpAndSettle();

      // Background bar should exist (we expect a container with the secondaryGreenLight color)
      final bgBar = find.descendant(
        of: find.byType(SpendLimitCard),
        matching: find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).color == secondaryGreenLight,
        ),
      );
      expect(bgBar, findsWidgets);

      // Green progress marker (a small green bar) should be present
      final greenMarker = find.descendant(
        of: find.byType(SpendLimitCard),
        matching: find.byWidgetPredicate(
          (w) => w is Container && (w as Container).color == secondaryGreen,
        ),
      );
      expect(greenMarker, findsWidgets);
    });

    testWidgets('tap on "Why is it different?" is tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SpendLimitCard(accountDetails: accountDetails)),
        ),
      );

      final whyText = find.text('Why is it different?');
      expect(whyText, findsOneWidget);

      // Ensure tap doesn't throw
      await tester.tap(whyText);
      await tester.pump();
    });
  });
}
