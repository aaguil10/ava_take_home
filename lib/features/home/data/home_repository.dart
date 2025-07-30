import 'package:ava_take_home/features/home/models/account_detail.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';

/// Abstract contract so it’s easy to mock in tests
abstract class HomeRepository {
  Future<CreditScore> fetchCreditScore();

  Future<List<CreditFactor>> fetchCreditFactors();

  Future<List<AccountDetail>> fetchAccountDetails();
}
