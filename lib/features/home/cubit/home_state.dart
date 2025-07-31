import 'package:ava_take_home/features/home/models/account_detail.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';

class HomeState {
  final List<CreditFactor> factors;
  final List<AccountDetail> accounts;
  final List<CreditScore> creditScoreHistory;
  final bool isLoading;

  const HomeState({
    required this.factors,
    required this.accounts,
    required this.creditScoreHistory,
    this.isLoading = false,
  });

  HomeState copyWith({
    List<CreditFactor>? factors,
    List<AccountDetail>? accounts,
    List<CreditScore>? creditScoreHistory,
    bool? isLoading,
  }) {
    return HomeState(
      factors: factors ?? this.factors,
      accounts: accounts ?? this.accounts,
      creditScoreHistory: creditScoreHistory ?? this.creditScoreHistory,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory HomeState.initial() => HomeState(
    factors: [],
    accounts: [],
    creditScoreHistory: [],
    isLoading: true,
  );
}
