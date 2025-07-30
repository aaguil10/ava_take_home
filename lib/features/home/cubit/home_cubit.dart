import 'package:ava_take_home/features/home/data/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(HomeState.initial());

  void loadHomeData() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));

    final score = await repository.fetchCreditScore();
    final factors = await repository.fetchCreditFactors();
    final accounts = await repository.fetchAccountDetails();

    emit(
      HomeState(
        score: score,
        factors: factors,
        accounts: accounts,
        isLoading: false,
      ),
    );
  }
}
