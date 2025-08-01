import 'package:ava_take_home/features/employment/cubit/employment_state.dart';
import 'package:ava_take_home/features/employment/data/employment_repository.dart';
import 'package:ava_take_home/features/employment/models/employment_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmploymentCubit extends Cubit<EmploymentState> {
  final EmploymentRepository repository;

  EmploymentCubit({required this.repository})
    : super(EmploymentState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final info = await repository.loadEmploymentInfo();
    emit(state.copyWith(info: info, isLoading: false));
  }

  void toggleEdit() {
    emit(
      state.copyWith(
        mode: state.mode == EmploymentMode.view
            ? EmploymentMode.edit
            : EmploymentMode.view,
      ),
    );
  }

  void updateInfo(EmploymentInfo updated) {
    emit(state.copyWith(info: updated, mode: EmploymentMode.view));
  }

  Future<void> saveAndConfirm() async {
    emit(state.copyWith(isSaving: true));
    await repository.saveEmploymentInfo(state.info);
    emit(state.copyWith(isSaving: false, nav: EmploymentNav.toFeedback));
  }

  void clearNav() {
    emit(state.copyWith(nav: EmploymentNav.none));
  }
}
