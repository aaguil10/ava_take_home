import 'package:ava_take_home/features/employment/models/employment_info.dart';

abstract class EmploymentRepository {
  Future<EmploymentInfo> loadEmploymentInfo();

  Future<void> saveEmploymentInfo(EmploymentInfo info);
}
