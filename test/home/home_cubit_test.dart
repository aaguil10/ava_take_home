import 'package:ava_take_home/features/home/cubit/home_cubit.dart';
import 'package:ava_take_home/features/home/cubit/home_state.dart';
import 'package:ava_take_home/features/home/data/home_repository.dart';
import 'package:ava_take_home/features/home/models/account_detail.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  group('HomeCubit', () {
    late HomeCubit homeCubit;
    late MockHomeRepository mockRepo;

    setUp(() {
      mockRepo = MockHomeRepository();
      final now = DateTime.now();
      final before = DateTime(
        now.year,
        now.month - 1,
        now.day,
        now.hour,
        now.minute,
        now.second,
      );
      when(() => mockRepo.fetchCreditScoreHistory()).thenAnswer(
        (_) async => [
          CreditScore(value: 718, label: 'Good', dateTime: before),
          CreditScore(value: 720, label: 'Good', dateTime: now),
        ],
      );
      when(() => mockRepo.fetchCreditFactors()).thenAnswer(
        (_) async => const [
          CreditFactor(name: 'Payment History', value: '100%', impact: 'High'),
        ],
      );
      when(() => mockRepo.fetchAccountDetails()).thenAnswer(
        (_) async => const [
          AccountDetail(name: 'Syncb/Amazon', balance: 1500, limit: 6300),
        ],
      );
      homeCubit = HomeCubit(repository: mockRepo);
    });

    tearDown(() {
      homeCubit.close();
    });

    test('initial state is HomeState.initial()', () {
      expect(homeCubit.state.isLoading, true);
      expect(homeCubit.state.creditScoreHistory, []);
    });

    blocTest<HomeCubit, HomeState>(
      'emits loaded state with mocked data when loadHomeData() is called',
      build: () => homeCubit,
      act: (cubit) => cubit.loadHomeData(),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'loading', true),
        isA<HomeState>().having(
          (s) => s.creditScoreHistory.last.value,
          'score',
          720,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'keeps factors and accounts when loaded',
      build: () => homeCubit,
      act: (cubit) => cubit.loadHomeData(),
      wait: const Duration(milliseconds: 600),
      verify: (cubit) {
        expect(cubit.state.factors.isNotEmpty, true);
        expect(cubit.state.accounts.isNotEmpty, true);
      },
    );
  });
}
