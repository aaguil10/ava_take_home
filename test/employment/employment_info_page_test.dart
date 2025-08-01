import 'package:ava_take_home/features/employment/cubit/employment_cubit.dart';
import 'package:ava_take_home/features/employment/cubit/employment_state.dart';
import 'package:ava_take_home/features/employment/data/employment_repository.dart';
import 'package:ava_take_home/features/employment/models/employment_info.dart';
import 'package:ava_take_home/features/employment/view/employment_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeEmploymentCubit extends Cubit<EmploymentState>
    implements EmploymentCubit {
  FakeEmploymentCubit()
    : super(
        EmploymentState(
          mode: EmploymentMode.edit,
          info: EmploymentInfo(
            employmentType: 'Full-time',
            employer: '',
            jobTitle: '',
            grossAnnualIncome: '',
            payFrequency: 'Bi-weekly',
            nextPayday: DateTime.now(),
            directDeposit: false,
            employerAddress: '',
            timeWithEmployerYears: 0,
            timeWithEmployerMonths: 0,
          ),
        ),
      );

  @override
  Future<void> load() async {}

  @override
  void toggleEdit() {}

  @override
  void updateInfo(EmploymentInfo updated) {
    emit(state.copyWith(info: updated));
  }

  @override
  Future<void> saveAndConfirm() async {}

  @override
  EmploymentRepository get repository => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestable({required EmploymentCubit cubit}) {
    return MaterialApp(
      home: BlocProvider<EmploymentCubit>.value(
        value: cubit,
        child: const EmploymentInfoPage(),
      ),
    );
  }

  group('EmploymentInfoPage form validation', () {
    late FakeEmploymentCubit cubit;

    setUp(() {
      cubit = FakeEmploymentCubit();
    });

    testWidgets('shows error when required fields are empty', (tester) async {
      await tester.pumpWidget(buildTestable(cubit: cubit));
      await tester.pumpAndSettle();

      // Ensure we're in edit mode by tapping Continue (should trigger validation)
      final continueButton = find.text('Continue');
      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();
      expect(continueButton, findsOneWidget);

      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // Expect required field errors for Employer, Job title, Gross annual income, Employer address
      expect(find.text('Required'), findsNWidgets(4));
    });

    testWidgets('rejects non-letter input for Employer and Job title', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable(cubit: cubit));
      await tester.pumpAndSettle();

      //Enter invalid employer (with number) and job title (with symbol)
      await tester.enterText(
        find.byKey(const Key('employerField')),
        'Apple123',
      );

      await tester.enterText(find.byKey(const Key('jobTitleField')), '@Dev');
      await tester.enterText(
        find.byKey(const Key('grossAnnualIncomeField')),
        '50000',
      ); // valid
      await tester.enterText(
        find.byKey(const Key('employerAddressField')),
        '123 Main St',
      ); // valid

      final continueButton = find.text('Continue');
      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.text('Must be letters and spaces only'), findsNWidgets(2));
      expect(find.text('Required'), findsNothing);
    });

    testWidgets('rejects non-numeric input for Gross annual income', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('employerField')), 'Apple');
      await tester.enterText(
        find.byKey(const Key('jobTitleField')),
        'Engineer',
      );
      await tester.enterText(
        find.byKey(const Key('grossAnnualIncomeField')),
        '50k',
      ); // invalid
      await tester.enterText(
        find.byKey(const Key('employerAddressField')),
        '1 Infinite Loop',
      );

      final continueButton = find.text('Continue');
      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.text('Must be numbers only'), findsOneWidget);
    });

    testWidgets('passes validation with good inputs', (tester) async {
      await tester.pumpWidget(buildTestable(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('employerField')), 'Apple');
      await tester.enterText(
        find.byKey(const Key('jobTitleField')),
        'Engineer',
      );
      await tester.enterText(
        find.byKey(const Key('grossAnnualIncomeField')),
        '120000',
      );
      await tester.enterText(
        find.byKey(const Key('employerAddressField')),
        '1 Infinite Loop',
      );

      final continueButton = find.text('Continue');
      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // No error texts should be present
      expect(find.text('Required'), findsNothing);
      expect(find.text('Must be letters and spaces only'), findsNothing);
      expect(find.text('Must be numbers only'), findsNothing);
    });
  });
}
