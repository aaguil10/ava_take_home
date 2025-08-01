import 'dart:convert';

class EmploymentInfo {
  final String employmentType;
  final String employer;
  final String jobTitle;
  final String grossAnnualIncome;
  final String payFrequency;
  final DateTime nextPayday;
  final bool directDeposit;
  final String employerAddress;
  final int timeWithEmployerYears;
  final int timeWithEmployerMonths;

  const EmploymentInfo({
    required this.employmentType,
    required this.employer,
    required this.jobTitle,
    required this.grossAnnualIncome,
    required this.payFrequency,
    required this.nextPayday,
    required this.directDeposit,
    required this.employerAddress,
    required this.timeWithEmployerYears,
    required this.timeWithEmployerMonths,
  });

  factory EmploymentInfo.empty() => EmploymentInfo(
    employmentType: '',
    employer: '',
    jobTitle: '',
    grossAnnualIncome: '',
    payFrequency: '',
    nextPayday: DateTime.now(),
    directDeposit: false,
    employerAddress: '',
    timeWithEmployerYears: 0,
    timeWithEmployerMonths: 0,
  );

  EmploymentInfo copyWith({
    String? employmentType,
    String? employer,
    String? jobTitle,
    String? grossAnnualIncome,
    String? payFrequency,
    DateTime? nextPayday,
    bool? directDeposit,
    String? employerAddress,
    int? timeWithEmployerYears,
    int? timeWithEmployerMonths,
  }) {
    return EmploymentInfo(
      employmentType: employmentType ?? this.employmentType,
      employer: employer ?? this.employer,
      jobTitle: jobTitle ?? this.jobTitle,
      grossAnnualIncome: grossAnnualIncome ?? this.grossAnnualIncome,
      payFrequency: payFrequency ?? this.payFrequency,
      nextPayday: nextPayday ?? this.nextPayday,
      directDeposit: directDeposit ?? this.directDeposit,
      employerAddress: employerAddress ?? this.employerAddress,
      timeWithEmployerYears:
          timeWithEmployerYears ?? this.timeWithEmployerYears,
      timeWithEmployerMonths:
          timeWithEmployerMonths ?? this.timeWithEmployerMonths,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employmentType': employmentType,
      'employer': employer,
      'jobTitle': jobTitle,
      'grossAnnualIncome': grossAnnualIncome,
      'payFrequency': payFrequency,
      'nextPayday': nextPayday.toIso8601String(),
      'directDeposit': directDeposit,
      'employerAddress': employerAddress,
      'timeWithEmployerYears': timeWithEmployerYears,
      'timeWithEmployerMonths': timeWithEmployerMonths,
    };
  }

  factory EmploymentInfo.fromMap(Map<String, dynamic> map) {
    return EmploymentInfo(
      employmentType: map['employmentType'] as String? ?? '',
      employer: map['employer'] as String? ?? '',
      jobTitle: map['jobTitle'] as String? ?? '',
      grossAnnualIncome: map['grossAnnualIncome'] as String? ?? '',
      payFrequency: map['payFrequency'] as String? ?? '',
      nextPayday:
          DateTime.tryParse(map['nextPayday'] as String? ?? '') ??
          DateTime.now(),
      directDeposit: map['directDeposit'] as bool? ?? false,
      employerAddress: map['employerAddress'] as String? ?? '',
      timeWithEmployerYears: map['timeWithEmployerYears'] as int? ?? 0,
      timeWithEmployerMonths: map['timeWithEmployerMonths'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmploymentInfo.fromJson(String source) =>
      EmploymentInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
