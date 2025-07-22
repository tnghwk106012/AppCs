import 'package:flutter/material.dart';
import '../widgets/holiday_calendar.dart';
import 'holiday_detail_page.dart';
import 'holiday_request_page.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/theme/theme.dart';

class HolidayCalendarPage extends StatefulWidget {
  const HolidayCalendarPage({Key? key}) : super(key: key);
  @override
  State<HolidayCalendarPage> createState() => _HolidayCalendarPageState();
}

class _HolidayCalendarPageState extends State<HolidayCalendarPage> {
  List<Map<String, dynamic>> holidays = [
    {'id': 1, 'start': '2024-07-01', 'end': '2024-07-01', 'reason': '연차', 'status': '승인'},
    {'id': 2, 'start': '2024-07-05', 'end': '2024-07-07', 'reason': '여름휴가', 'status': '대기'},
    {'id': 3, 'start': '2024-07-12', 'end': '2024-07-12', 'reason': '병가', 'status': '반려'},
    {'id': 4, 'start': '2024-07-20', 'end': '2024-07-21', 'reason': '가족행사', 'status': '승인'},
    {'id': 5, 'start': '2024-07-25', 'end': '2024-07-25', 'reason': '반차', 'status': '대기'},
  ];
  
  String selectedYear = '2024';
  String selectedStatus = '전체';
  int annualLeave = 12; // 사용자 설정 연차
  List<String> statusList = ['전체', '승인', '대기', '반려'];
  List<String> yearList = ['2024', '2023'];
  final ThemeData appTheme = csTheme;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    annualLeave = await SettingsService.getAnnualLeave();
  }

  void openDetail(Map<String, dynamic> data) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HolidayDetailPage(data: data)),
    );
  }
  
  void openRequest([Map<String, dynamic>? data]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HolidayRequestPage(data: data)),
    );
  }
  
  List<Map<String, dynamic>> get filteredHolidays {
    return holidays.where((h) {
      final year = h['start'].substring(0, 4);
      if (selectedYear != '전체' && year != selectedYear) return false;
      if (selectedStatus != '전체' && h['status'] != selectedStatus) return false;
      return true;
    }).toList();
  }
  
  Map<String, int> get stats {
    int used = holidays.where((h) => h['status'] == '승인').fold(0, (sum, h) => sum + (DateTime.parse(h['end']).difference(DateTime.parse(h['start'])).inDays + 1));
    int remain = annualLeave - used; // 사용자 설정 연차 사용
    int planned = holidays.where((h) => h['status'] == '대기').fold(0, (sum, h) => sum + (DateTime.parse(h['end']).difference(DateTime.parse(h['start'])).inDays + 1));
    return {'used': used, 'remain': remain, 'planned': planned};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.colorScheme.background,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme.colorScheme.primary.withOpacity(0.10),
                border: Border.all(
                  color: appTheme.colorScheme.primary.withOpacity(0.22),
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.beach_access_rounded,
                color: appTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '휴가',
              style: appTheme.textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            tooltip: '검색',
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {
              _showFilterDialog();
            },
            tooltip: '필터',
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _showAnnualLeaveSettingsDialog();
            },
            tooltip: '연차 설정',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => openRequest(),
            tooltip: '추가',
          ),
        ],
      ),
      backgroundColor: const Color(0xFF181A20),
      body: Column(
        children: [
          // 통계 카드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _StatCard(
                  label: '사용',
                  value: '${stats['used']}일',
                  color: const Color(0xFF5EEAD4),
                  icon: Icons.check_circle,
                ),
                const SizedBox(width: 8),
                _StatCard(
                  label: '잔여',
                  value: '${stats['remain']}일',
                  color: const Color(0xFFFACC15),
                  icon: Icons.schedule,
                ),
                const SizedBox(width: 8),
                _StatCard(
                  label: '예정',
                  value: '${stats['planned']}일',
                  color: const Color(0xFF60A5FA),
                  icon: Icons.event,
                ),
              ],
            ),
          ),
          // 필터
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedYear,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF23262F),
                    style: const TextStyle(color: Colors.white),
                    items: yearList.map((year) => DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    )).toList(),
                    onChanged: (v) => setState(() => selectedYear = v!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF23262F),
                    style: const TextStyle(color: Colors.white),
                    items: statusList.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    )).toList(),
                    onChanged: (v) => setState(() => selectedStatus = v!),
                  ),
                ),
              ],
            ),
          ),
          // 캘린더
          Expanded(
            child: HolidayCalendar(
              holidays: filteredHolidays,
              onCellTap: (data) => openDetail(data),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'holiday_fab',
        onPressed: () => openRequest(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF23262F),
        title: const Text('필터', style: TextStyle(color: Colors.white)),
        content: const Text('필터 기능 구현 영역', style: TextStyle(color: Color(0xFF8E95A7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기', style: TextStyle(color: Color(0xFF5EEAD4))),
          ),
        ],
      ),
    );
  }

  void _showAnnualLeaveSettingsDialog() {
    final annualLeaveController = TextEditingController(text: annualLeave.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF23262F),
        title: const Text('연차 설정', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '연간 총 연차 일수를 설정하세요',
              style: TextStyle(color: Color(0xFF8E95A7)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: annualLeaveController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: '연차 일수',
                labelStyle: TextStyle(color: Color(0xFF8E95A7)),
                suffixText: '일',
                suffixStyle: TextStyle(color: Color(0xFF8E95A7)),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2B3040)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5EEAD4)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Color(0xFF8E95A7))),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAnnualLeave = int.tryParse(annualLeaveController.text) ?? annualLeave;
              setState(() {
                annualLeave = newAnnualLeave;
              });
              await SettingsService.saveAnnualLeave(newAnnualLeave);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('연차가 ${newAnnualLeave}일로 설정되었습니다.'),
                  backgroundColor: const Color(0xFF5EEAD4),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5EEAD4),
              foregroundColor: Colors.black,
            ),
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 