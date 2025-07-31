import 'package:ava_take_home/features/home/models/account_details.dart';
import 'package:ava_take_home/features/home/models/credit_card_account.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';

/// Abstract contract so it’s easy to mock in tests
abstract class HomeRepository {
  Future<AccountDetails> fetchAccountDetails();

  Future<List<CreditFactor>> fetchCreditFactors();

  Future<List<CreditCardAccount>> fetchCreditCardAccounts();

  Future<List<CreditScore>> fetchCreditScoreHistory();
}
