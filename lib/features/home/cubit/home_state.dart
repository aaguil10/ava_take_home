import 'package:ava_take_home/features/home/models/account_detail.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';

class HomeState {
  final CreditScore score;
  final List<CreditFactor> factors;
  final List<AccountDetail> accounts;
  final bool isLoading;

  const HomeState({
    required this.score,
    required this.factors,
    required this.accounts,
    this.isLoading = false,
  });

  HomeState copyWith({
    CreditScore? score,
    List<CreditFactor>? factors,
    List<AccountDetail>? accounts,
    bool? isLoading,
  }) {
    return HomeState(
      score: score ?? this.score,
      factors: factors ?? this.factors,
      accounts: accounts ?? this.accounts,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory HomeState.initial() => HomeState(
    score: CreditScore(value: 0, label: 'Good', delta: 0),
    factors: [],
    accounts: [],
    isLoading: true,
  );
}
