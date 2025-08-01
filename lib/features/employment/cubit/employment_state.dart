import 'package:ava_take_home/features/employment/models/employment_info.dart';

enum EmploymentMode { view, edit }

class EmploymentState {
  final EmploymentInfo info;
  final EmploymentMode mode;
  final bool isSaving;
  final bool isLoading;

  const EmploymentState({
    required this.info,
    this.mode = EmploymentMode.view,
    this.isSaving = false,
    this.isLoading = false,
  });

  EmploymentState copyWith({
    EmploymentInfo? info,
    EmploymentMode? mode,
    bool? isSaving,
    bool? isLoading,
  }) {
    return EmploymentState(
      info: info ?? this.info,
      mode: mode ?? this.mode,
      isSaving: isSaving ?? this.isSaving,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory EmploymentState.initial() => EmploymentState(
    info: EmploymentInfo.empty(),
    mode: EmploymentMode.view,
    isSaving: false,
    isLoading: true,
  );
}
