import 'package:ava_take_home/features/home/data/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(HomeState.initial());

  void loadHomeData() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));

    final accountDetails = await repository.fetchAccountDetails();
    final factors = await repository.fetchCreditFactors();
    final accounts = await repository.fetchCreditCardAccounts();
    final creditScoreHistory = await repository.fetchCreditScoreHistory();

    emit(
      HomeState(
        accountDetails: accountDetails,
        factors: factors,
        accounts: accounts,
        creditScoreHistory: creditScoreHistory,
        isLoading: false,
      ),
    );
  }
}
