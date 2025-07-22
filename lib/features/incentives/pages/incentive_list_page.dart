import 'package:flutter/material.dart';
import '../widgets/incentive_summary_card.dart';
import '../widgets/incentive_calendar.dart';
import 'incentive_detail_page.dart';
import 'incentive_edit_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/theme/theme.dart';

enum PerformanceMetric { PATIENT_COUNT, TREATMENT_HOURS, SUCCESS_RATE, REVENUE }
enum PerformancePeriod { DAILY, WEEKLY, MONTHLY, QUARTERLY }

class PerformanceData {
  final String patientName;
  final String treatmentType;
  final int sessions;
  final double successRate;
  final int revenue;
  final DateTime startDate;
  final DateTime endDate;
  final String therapistName;
  final String? notes;

  PerformanceData({
    required this.patientName,
    required this.treatmentType,
    required this.sessions,
    required this.successRate,
    required this.revenue,
    required this.startDate,
    required this.endDate,
    required this.therapistName,
    this.notes,
  });
}

class IncentiveListPage extends StatefulWidget {
  const IncentiveListPage({Key? key}) : super(key: key);
  @override
  State<IncentiveListPage> createState() => _IncentiveListPageState();
}

class _IncentiveListPageState extends State<IncentiveListPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> incentives = [
    {'id': 1, 'date': '2024-07-01', 'amount': 120000, 'note': '환자 케이스'},
    {'id': 2, 'date': '2024-07-03', 'amount': 90000, 'note': '팀 미팅'},
    {'id': 3, 'date': '2024-07-10', 'amount': 150000, 'note': '특별 성과'},
    {'id': 4, 'date': '2024-07-15', 'amount': 80000, 'note': '업무 지원'},
    {'id': 5, 'date': '2024-07-20', 'amount': 110000, 'note': '환자 피드백'},
  ];

  List<PerformanceData> performanceData = [
    PerformanceData(
      patientName: '김환자',
      treatmentType: '어깨 재활',
      sessions: 12,
      successRate: 85.5,
      revenue: 1200000,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
      therapistName: '김치료사',
      notes: '상당한 개선 보임',
    ),
    PerformanceData(
      patientName: '이환자',
      treatmentType: '무릎 재활',
      sessions: 8,
      successRate: 92.0,
      revenue: 800000,
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      endDate: DateTime.now(),
      therapistName: '이치료사',
      notes: '목표 달성',
    ),
    PerformanceData(
      patientName: '박환자',
      treatmentType: '뇌졸중 회복',
      sessions: 15,
      successRate: 78.3,
      revenue: 1500000,
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      endDate: DateTime.now(),
      therapistName: '박치료사',
      notes: '지속적 개선 중',
    ),
    PerformanceData(
      patientName: '최환자',
      treatmentType: '척추 교정',
      sessions: 10,
      successRate: 88.7,
      revenue: 1000000,
      startDate: DateTime.now().subtract(const Duration(days: 25)),
      endDate: DateTime.now(),
      therapistName: '김치료사',
      notes: '예상보다 빠른 회복',
    ),
  ];

  String selectedYear = '2024';
  String selectedMonth = '07';
  String selectedType = '전체';
  int goalAmount = 500000;
  final goalCtl = TextEditingController();
  List<String> yearList = ['2024', '2023'];
  List<String> monthList = [for (var i = 1; i <= 12; i++) i.toString().padLeft(2, '0')];
  List<String> typeList = ['전체', '환자 케이스', '팀 미팅', '특별 성과', '업무 지원', '환자 피드백'];
  late AnimationController _fabController;
  late Animation<double> _fabAnim;
  int _tabIndex = 0;
  PerformanceMetric selectedMetric = PerformanceMetric.REVENUE;
  PerformancePeriod selectedPeriod = PerformancePeriod.MONTHLY;
  final ThemeData appTheme = csTheme;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    _fabAnim = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeInOut));
  }
  
  @override
  void dispose() {
    goalCtl.dispose();
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserSettings() async {
    goalAmount = await SettingsService.getGoalAmount();
    goalCtl.text = goalAmount.toString();
  }
  
  void openEdit([Map<String, dynamic>? data]) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => IncentiveEditPage(data: data)),
    );
    if (result is Map<String, dynamic>) {
      setState(() {
        if (data == null) {
          incentives.add({
            'id': (incentives.isNotEmpty ? (incentives.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b) + 1) : 1),
            ...result,
          });
        } else {
          final idx = incentives.indexWhere((e) => e['id'] == data['id']);
          if (idx != -1) incentives[idx] = {...incentives[idx], ...result};
        }
      });
    }
  }
  
  void openDetail(Map<String, dynamic> data) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => IncentiveDetailPage(data: data)),
    );
  }
  
  List<Map<String, dynamic>> get filteredIncentives {
    return incentives.where((e) {
      final y = e['date'].substring(0, 4);
      final m = e['date'].substring(5, 7);
      if (selectedYear != '전체' && y != selectedYear) return false;
      if (selectedMonth != '전체' && m != selectedMonth) return false;
      if (selectedType != '전체' && e['note'] != selectedType) return false;
      return true;
    }).toList();
  }
  
  int get totalAmount => incentives.fold(0, (sum, e) => sum + (e['amount'] as int));
  int get monthAmount => incentives.where((e) => e['date'].substring(0, 4) == selectedYear && e['date'].substring(5, 7) == selectedMonth).fold(0, (sum, e) => sum + (e['amount'] as int));
  Map<String, dynamic>? get lastIncentive => incentives.isNotEmpty ? incentives.last : null;
  
  double get goalRate {
    if (goalAmount <= 0) return 0.0;
    final currentAmount = monthAmount.toDouble();
    final rate = (currentAmount / goalAmount) * 100;
    return rate.clamp(0.0, 999.9);
  }
  
  List<int> get monthlySums {
    List<int> sums = List.filled(12, 0);
    for (var e in incentives) {
      final y = int.parse(e['date'].substring(0, 4));
      final m = int.parse(e['date'].substring(5, 7));
      if (selectedYear == '전체' || y.toString() == selectedYear) {
        sums[m - 1] += e['amount'] as int;
      }
    }
    return sums;
  }

  int get totalPatients => performanceData.length;
  int get totalSessions => performanceData.fold(0, (sum, p) => sum + p.sessions);
  double get averageSuccessRate => performanceData.isEmpty ? 0.0 : performanceData.fold(0.0, (sum, p) => sum + p.successRate) / performanceData.length;
  int get totalRevenue => performanceData.fold(0, (sum, p) => sum + p.revenue);

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
                color: CsColors.primary.withOpacity(0.10),
                border: Border.all(
                  color: CsColors.primary.withOpacity(0.22),
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.trending_up_rounded,
                color: CsColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '성과',
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
              _showGoalSettingsDialog();
            },
            tooltip: '목표 설정',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => openEdit(),
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
                  label: '총 성과',
                  value: '${NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(totalAmount)}원',
                  color: const Color(0xFFFACC15),
                  icon: Icons.trending_up,
                ),
                const SizedBox(width: 8),
                _StatCard(
                  label: '이번 달',
                  value: '${NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(monthAmount)}원',
                  color: const Color(0xFF5EEAD4),
                  icon: Icons.calendar_today,
                ),
                const SizedBox(width: 8),
                _StatCard(
                  label: '목표 달성',
                  value: '${goalRate.toStringAsFixed(1)}%',
                  color: goalRate >= 100 ? const Color(0xFF23C981) : const Color(0xFFEF4444),
                  icon: Icons.flag,
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
                    value: selectedMonth,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF23262F),
                    style: const TextStyle(color: Colors.white),
                    items: monthList.map((month) => DropdownMenuItem(
                      value: month,
                      child: Text(month),
                    )).toList(),
                    onChanged: (v) => setState(() => selectedMonth = v!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedType,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF23262F),
                    style: const TextStyle(color: Colors.white),
                    items: typeList.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    )).toList(),
                    onChanged: (v) => setState(() => selectedType = v!),
                  ),
                ),
              ],
            ),
          ),
          // 탭
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF23262F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    label: '캘린더',
                    isSelected: _tabIndex == 0,
                    onTap: () => setState(() => _tabIndex = 0),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: '성과 분석',
                    isSelected: _tabIndex == 1,
                    onTap: () => setState(() => _tabIndex = 1),
                  ),
                ),
              ],
            ),
          ),
          // 콘텐츠
          Expanded(
            child: _tabIndex == 0
                ? IncentiveCalendar(
                    incentives: filteredIncentives,
                    onCellTap: (data) => openDetail(data),
                  )
                : _PerformanceAnalysisTab(),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnim,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnim.value,
            child: FloatingActionButton(
              heroTag: 'incentive_fab',
              onPressed: () => openEdit(),
              child: const Icon(Icons.add),
            ),
          );
        },
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

  void _showGoalSettingsDialog() {
    final goalController = TextEditingController(text: goalAmount.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF23262F),
        title: const Text('목표 설정', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '월별 목표 금액을 설정하세요',
              style: TextStyle(color: Color(0xFF8E95A7)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: '목표 금액',
                labelStyle: TextStyle(color: Color(0xFF8E95A7)),
                suffixText: '원',
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
              final newGoal = int.tryParse(goalController.text) ?? goalAmount;
              setState(() {
                goalAmount = newGoal;
              });
              await SettingsService.saveGoalAmount(newGoal);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('목표가 ${NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(newGoal)}원으로 설정되었습니다.'),
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

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5EEAD4).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF5EEAD4) : const Color(0xFF8E95A7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _PerformanceAnalysisTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          '성과 분석 기능 구현 영역',
          style: TextStyle(color: Color(0xFF8E95A7)),
        ),
      ),
    );
  }
} 