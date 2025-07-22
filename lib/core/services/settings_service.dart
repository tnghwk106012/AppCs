import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _annualLeaveKey = 'annual_leave';
  static const String _goalAmountKey = 'goal_amount';
  static const String _goalRateKey = 'goal_rate';

  static Future<void> saveAnnualLeave(int annualLeave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_annualLeaveKey, annualLeave);
  }

  static Future<int> getAnnualLeave() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_annualLeaveKey) ?? 12;
  }

  static Future<void> saveGoalAmount(int goalAmount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goalAmountKey, goalAmount);
  }

  static Future<int> getGoalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_goalAmountKey) ?? 500000;
  }

  static Future<void> saveGoalRate(double goalRate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_goalRateKey, goalRate);
  }

  static Future<double> getGoalRate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_goalRateKey) ?? 85.0;
  }

  static Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_annualLeaveKey, 12);
    await prefs.setInt(_goalAmountKey, 500000);
    await prefs.setDouble(_goalRateKey, 85.0);
  }
} 