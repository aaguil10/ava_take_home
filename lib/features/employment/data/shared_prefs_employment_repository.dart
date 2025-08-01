import 'package:ava_take_home/features/employment/data/employment_repository.dart';
import 'package:ava_take_home/features/employment/models/employment_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsEmploymentRepository implements EmploymentRepository {
  static const _key = 'employment_info_json';

  final Future<SharedPreferences> _prefsFuture;

  SharedPrefsEmploymentRepository({Future<SharedPreferences>? prefs})
    : _prefsFuture = prefs ?? SharedPreferences.getInstance();

  @override
  Future<EmploymentInfo> loadEmploymentInfo() async {
    final prefs = await _prefsFuture;
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) {
      return EmploymentInfo.empty();
    }
    try {
      return EmploymentInfo.fromJson(jsonStr);
    } catch (_) {
      // If stored data is malformed, fallback to empty and overwrite on next save
      return EmploymentInfo.empty();
    }
  }

  @override
  Future<void> saveEmploymentInfo(EmploymentInfo info) async {
    final prefs = await _prefsFuture;
    await prefs.setString(_key, info.toJson());
  }
}
