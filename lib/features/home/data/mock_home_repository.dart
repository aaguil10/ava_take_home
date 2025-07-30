import 'dart:async';

import 'package:ava_take_home/features/home/models/account_detail.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';

import 'home_repository.dart';

/// Simple fake repository returning static data with a delay
class MockHomeRepository implements HomeRepository {
  @override
  Future<CreditScore> fetchCreditScore() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const CreditScore(value: 720, label: 'Good', delta: 2);
  }

  @override
  Future<List<CreditFactor>> fetchCreditFactors() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      CreditFactor(name: 'Payment History', value: '100%', impact: 'High'),
      CreditFactor(name: 'Credit Utilization', value: '4%', impact: 'Low'),
      CreditFactor(name: 'Derogatory Marks', value: '0', impact: 'Medium'),
    ];
  }

  @override
  Future<List<AccountDetail>> fetchAccountDetails() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      AccountDetail(name: 'Syncb/Amazon', balance: 1500, limit: 6300),
      AccountDetail(name: 'Capital One', balance: 500, limit: 4000),
    ];
  }
}
