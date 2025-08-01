import 'package:ava_take_home/features/employment/models/employment_info.dart';

enum EmploymentMode { view, edit }

enum EmploymentNav { none, toFeedback }

class EmploymentState {
  final EmploymentInfo info;
  final EmploymentMode mode;
  final EmploymentNav nav;
  final bool isSaving;
  final bool isLoading;

  const EmploymentState({
    required this.info,
    this.mode = EmploymentMode.view,
    this.nav = EmploymentNav.none,
    this.isSaving = false,
    this.isLoading = false,
  });

  EmploymentState copyWith({
    EmploymentInfo? info,
    EmploymentMode? mode,
    EmploymentNav? nav,
    bool? isSaving,
    bool? isLoading,
  }) {
    return EmploymentState(
      info: info ?? this.info,
      mode: mode ?? this.mode,
      nav: nav ?? this.nav,
      isSaving: isSaving ?? this.isSaving,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory EmploymentState.initial() => EmploymentState(
    info: EmploymentInfo.empty(),
    mode: EmploymentMode.view,
    nav: EmploymentNav.none,
    isSaving: false,
    isLoading: true,
  );
}
