import 'dart:async';

import 'package:ava_take_home/features/home/models/account_details.dart';
import 'package:ava_take_home/features/home/models/credit_card_account.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';

import 'home_repository.dart';

/// Simple fake repository returning static data with a delay
class MockHomeRepository implements HomeRepository {
  @override
  Future<AccountDetails> fetchAccountDetails() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AccountDetails(
      balance: 30,
      creditLimit: 600,
      spendLimit: 100,
      currentSpend: 75,
    );
  }

  @override
  Future<List<CreditFactor>> fetchCreditFactors() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      CreditFactor(
        name: 'Payment History',
        value: '100%',
        impact: 'HIGH IMPACT',
      ),
      CreditFactor(
        name: 'Credit Card Utilization',
        value: '4%',
        impact: 'LOW IMPACT',
      ),
      CreditFactor(name: 'Derogatory Marks', value: '2', impact: 'MED IMPACT'),
      CreditFactor(
        name: 'Age of Credit History',
        value: '1ys 4mo',
        impact: 'LOW IMPACT',
      ),
      CreditFactor(name: 'Hard Inquiries', value: '3', impact: 'MED IMPACT'),
      CreditFactor(name: 'Total Accounts', value: '9', impact: 'MED IMPACT'),
    ];
  }

  @override
  Future<List<CreditCardAccount>> fetchCreditCardAccounts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      CreditCardAccount(
        name: 'Syncb/Amazon',
        balance: 1500,
        limit: 6300,
        reportedAt: DateTime.now(),
      ),
      CreditCardAccount(
        name: 'Capital One',
        balance: 500,
        limit: 4000,
        reportedAt: DateTime.now(),
      ),
      CreditCardAccount(
        name: 'Chase',
        balance: 34,
        limit: 2500,
        reportedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<CreditScore>> fetchCreditScoreHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      CreditScore(value: 610, label: 'Good', dateTime: _buildDateMonthsAgo(11)),
      CreditScore(value: 600, label: 'Good', dateTime: _buildDateMonthsAgo(10)),
      CreditScore(value: 620, label: 'Good', dateTime: _buildDateMonthsAgo(9)),
      CreditScore(value: 650, label: 'Good', dateTime: _buildDateMonthsAgo(8)),
      CreditScore(value: 625, label: 'Good', dateTime: _buildDateMonthsAgo(7)),
      CreditScore(value: 675, label: 'Good', dateTime: _buildDateMonthsAgo(6)),
      CreditScore(value: 650, label: 'Good', dateTime: _buildDateMonthsAgo(5)),
      CreditScore(value: 660, label: 'Good', dateTime: _buildDateMonthsAgo(4)),
      CreditScore(value: 680, label: 'Good', dateTime: _buildDateMonthsAgo(3)),
      CreditScore(value: 700, label: 'Good', dateTime: _buildDateMonthsAgo(2)),
      CreditScore(value: 695, label: 'Good', dateTime: _buildDateMonthsAgo(1)),
      CreditScore(value: 697, label: 'Good', dateTime: _buildDateMonthsAgo(0)),
    ];
  }

  DateTime _buildDateMonthsAgo(int monthsAgo) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month - monthsAgo,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
  }
}
