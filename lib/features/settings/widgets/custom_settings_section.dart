import 'package:flutter/material.dart';
import '../../../core/services/settings_service.dart';

class CustomSettingsSection extends StatefulWidget {
  const CustomSettingsSection({Key? key}) : super(key: key);
  @override
  State<CustomSettingsSection> createState() => _CustomSettingsSectionState();
}

class _CustomSettingsSectionState extends State<CustomSettingsSection> {
  final TextEditingController _annualLeaveController = TextEditingController();
  final TextEditingController _goalAmountController = TextEditingController();
  final TextEditingController _goalRateController = TextEditingController();
  
  int annualLeave = 12;
  int goalAmount = 500000;
  double goalRate = 85.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _annualLeaveController.dispose();
    _goalAmountController.dispose();
    _goalRateController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    annualLeave = await SettingsService.getAnnualLeave();
    goalAmount = await SettingsService.getGoalAmount();
    goalRate = await SettingsService.getGoalRate();
    
    setState(() {
      _annualLeaveController.text = annualLeave.toString();
      _goalAmountController.text = goalAmount.toString();
      _goalRateController.text = goalRate.toString();
    });
  }

  Future<void> _saveSettings() async {
    setState(() {
      annualLeave = int.tryParse(_annualLeaveController.text) ?? 12;
      goalAmount = int.tryParse(_goalAmountController.text) ?? 500000;
      goalRate = double.tryParse(_goalRateController.text) ?? 85.0;
    });
    
    await SettingsService.saveAnnualLeave(annualLeave);
    await SettingsService.saveGoalAmount(goalAmount);
    await SettingsService.saveGoalRate(goalRate);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('설정이 저장되었습니다.'),
          backgroundColor: Color(0xFF5EEAD4),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF23262F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2B3040), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5EEAD4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Color(0xFF5EEAD4),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '사용자 정의 설정',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '연차 및 성과 목표 설정',
                        style: TextStyle(
                          color: Color(0xFF8E95A7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF2B3040), height: 1),
          _buildSettingItem(
            icon: Icons.beach_access_rounded,
            title: '연차 설정',
            subtitle: '연간 총 연차 일수',
            controller: _annualLeaveController,
            suffix: '일',
            onChanged: (value) => _saveSettings(),
          ),
          const Divider(color: Color(0xFF2B3040), height: 1),
          _buildSettingItem(
            icon: Icons.trending_up_rounded,
            title: '성과 목표',
            subtitle: '월별 목표 금액',
            controller: _goalAmountController,
            suffix: '원',
            onChanged: (value) => _saveSettings(),
          ),
          const Divider(color: Color(0xFF2B3040), height: 1),
          _buildSettingItem(
            icon: Icons.flag_rounded,
            title: '목표 달성률',
            subtitle: '목표 달성 기준',
            controller: _goalRateController,
            suffix: '%',
            onChanged: (value) => _saveSettings(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetToDefaults,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('기본값으로 초기화'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8E95A7),
                      side: const BorderSide(color: Color(0xFF2B3040)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save_rounded, size: 18),
                    label: const Text('저장'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5EEAD4),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required String suffix,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF5EEAD4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5EEAD4),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8E95A7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                suffixText: suffix,
                suffixStyle: const TextStyle(
                  color: Color(0xFF8E95A7),
                  fontSize: 12,
                ),
                filled: true,
                fillColor: const Color(0xFF181A20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2B3040)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2B3040)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF5EEAD4)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resetToDefaults() async {
    await SettingsService.resetToDefaults();
    await _loadSettings();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('기본값으로 초기화되었습니다.'),
          backgroundColor: Color(0xFFFACC15),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
} 