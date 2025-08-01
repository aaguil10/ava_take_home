import 'package:ava_take_home/features/employment/cubit/employment_cubit.dart';
import 'package:ava_take_home/features/employment/cubit/employment_state.dart';
import 'package:ava_take_home/features/employment/data/shared_prefs_employment_repository.dart';
import 'package:ava_take_home/features/employment/models/employment_info.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({}); // clears storage
  final prefs = SharedPreferences.getInstance();
  final repo = SharedPrefsEmploymentRepository(prefs: prefs);
  group('EmploymentCubit', () {
    late EmploymentCubit cubit;

    setUp(() {
      cubit = EmploymentCubit(repository: repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is loading with empty info', () {
      expect(cubit.state.info.employer, '');
      expect(cubit.state.isLoading, true);
    });

    blocTest<EmploymentCubit, EmploymentState>(
      'load() fetches and emits info',
      build: () => cubit,
      act: (c) => c.load(),
      wait: const Duration(milliseconds: 250),
      expect: () => [
        isA<EmploymentState>().having(
          (s) => s.isLoading,
          'loading start',
          true,
        ),
        isA<EmploymentState>().having((s) => s.isLoading, 'loading end', false),
      ],
    );

    blocTest<EmploymentCubit, EmploymentState>(
      'toggleEdit switches mode',
      build: () => cubit,
      act: (c) => c.toggleEdit(),
      expect: () => [
        isA<EmploymentState>().having(
          (s) => s.mode,
          'mode',
          EmploymentMode.edit,
        ),
      ],
    );

    blocTest<EmploymentCubit, EmploymentState>(
      'saveAndConfirm sets nav to toFeedback',
      build: () => cubit,
      seed: () => EmploymentState(
        info: EmploymentInfo.empty(),
        mode: EmploymentMode.view,
        isLoading: false,
        isSaving: false,
      ),
      act: (c) => c.saveAndConfirm(),
      wait: const Duration(milliseconds: 150),
      expect: () => [
        isA<EmploymentState>().having((s) => s.isSaving, 'saving', true),
        isA<EmploymentState>().having((s) => s.isSaving, 'saved', false),
      ],
    );
  });
}
