import 'package:ava_take_home/features/home/models/account_details.dart';
import 'package:ava_take_home/features/home/models/credit_card_account.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';

class HomeState {
  final AccountDetails accountDetails;
  final List<CreditFactor> factors;
  final List<CreditCardAccount> accounts;
  final List<CreditScore> creditScoreHistory;
  final bool isLoading;

  const HomeState({
    required this.accountDetails,
    required this.factors,
    required this.accounts,
    required this.creditScoreHistory,
    this.isLoading = false,
  });

  HomeState copyWith({
    AccountDetails? accountDetails,
    List<CreditFactor>? factors,
    List<CreditCardAccount>? accounts,
    List<CreditScore>? creditScoreHistory,
    bool? isLoading,
  }) {
    return HomeState(
      accountDetails: accountDetails ?? this.accountDetails,
      factors: factors ?? this.factors,
      accounts: accounts ?? this.accounts,
      creditScoreHistory: creditScoreHistory ?? this.creditScoreHistory,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory HomeState.initial() => HomeState(
    accountDetails: AccountDetails(
      balance: 0,
      creditLimit: 0,
      spendLimit: 0,
      currentSpend: 0,
    ),
    factors: [],
    accounts: [],
    creditScoreHistory: [],
    isLoading: true,
  );
}
