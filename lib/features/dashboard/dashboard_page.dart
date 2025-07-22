import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> todaySchedules = [
    {
      'id': 1,
      'title': '김환자 치료',
      'time': '오전 9:00~10:00',
      'patient': '김환자',
      'status': 'waiting',
      'location': 'A병동',
    },
    {
      'id': 2,
      'title': '이환자 상담',
      'time': '오후 2:00~3:00',
      'patient': '이환자',
      'status': 'in_progress',
      'location': '상담실',
    },
    {
      'id': 3,
      'title': '박환자 진료',
      'time': '오전 10:00~11:00',
      'patient': '박환자',
      'status': 'done',
      'location': '외래실',
    },
  ];

  final List<Map<String, dynamic>> activePlans = [
    {
      'id': 1,
      'patient': '김환자',
      'method': 'Manual Therapy',
      'goal': '가동범위 증가',
      'status': '진행중',
      'progress': 75,
    },
    {
      'id': 2,
      'patient': '이환자',
      'method': 'Exercise Therapy',
      'goal': '근력 회복',
      'status': '진행중',
      'progress': 60,
    },
    {
      'id': 3,
      'patient': '박환자',
      'method': 'Occupational Therapy',
      'goal': '일상생활 능력 향상',
      'status': '대기',
      'progress': 0,
    },
  ];

  final List<Map<String, dynamic>> pendingShares = [
    {
      'id': 1,
      'title': '김환자 치료계획',
      'sharedBy': '김치료사',
      'type': 'plan',
      'sharedAt': '2시간 전',
    },
    {
      'id': 2,
      'title': '이환자 일정',
      'sharedBy': '이치료사',
      'type': 'schedule',
      'sharedAt': '1일 전',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData appTheme = csTheme;
    return Scaffold(
      backgroundColor: appTheme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: appTheme.colorScheme.background,
        toolbarHeight: 60,
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
                Icons.home_rounded,
                color: appTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '홈',
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
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: () {
              _showSortDialog();
            },
            tooltip: '정렬',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {},
            tooltip: '추가',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 18),
              _buildQuickStats(),
              const SizedBox(height: 18),
              _buildTodaySchedules(),
              const SizedBox(height: 18),
              _buildActivePlans(),
              const SizedBox(height: 18),
              _buildPendingShares(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF23262F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2B3040),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '안녕하세요, 김치료사님!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '오늘도 좋은 하루 되세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem('오늘 일정', '${todaySchedules.length}개', Icons.calendar_today),
              const SizedBox(width: 16),
              _buildStatItem('진행중 계획', '${activePlans.where((p) => p['status'] == '진행중').length}개', Icons.assignment),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2B3040),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5EEAD4), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStatCard(
            '완료된 일정',
            '${todaySchedules.where((s) => s['status'] == 'done').length}',
            Icons.check_circle,
            const Color(0xFF60A5FA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCard(
            '대기 중',
            '${todaySchedules.where((s) => s['status'] == 'waiting').length}',
            Icons.schedule,
            const Color(0xFFFACC15),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCard(
            '진행중',
            '${todaySchedules.where((s) => s['status'] == 'in_progress').length}',
            Icons.play_circle,
            const Color(0xFF5EEAD4),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF23262F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '오늘 일정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '전체보기',
                style: TextStyle(
                  color: const Color(0xFF5EEAD4),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...todaySchedules.map((schedule) => _buildScheduleCard(schedule)),
      ],
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    final theme = csTheme;
    final statusColor = _getStatusColor(schedule['status']);
    final accentColor = theme.colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event, color: accentColor, size: 24),
                const SizedBox(height: 8),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.background, width: 2),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _getStatusText(schedule['status']),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule['title'],
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${schedule['time']} • ${schedule['location']}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: accentColor.withOpacity(0.82),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (schedule['patient'] != null && schedule['patient'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '환자: ${schedule['patient']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '진행중인 계획',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '전체보기',
                style: TextStyle(
                  color: const Color(0xFFFACC15),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...activePlans.map((plan) => _buildPlanCard(plan)),
      ],
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final theme = csTheme;
    final accentColor = theme.colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_rounded, color: accentColor, size: 24),
                const SizedBox(height: 8),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.background, width: 2),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan['patient'],
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    plan['method'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: accentColor.withOpacity(0.82),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (plan['goal'] != null && plan['goal'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '목표: ${plan['goal']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: LinearProgressIndicator(
                      value: plan['progress'] / 100,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.13),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${plan['progress']}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingShares() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '대기 중인 공유',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '전체보기',
                style: TextStyle(
                  color: const Color(0xFF8B5CF6),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...pendingShares.map((share) => _buildShareCard(share)),
      ],
    );
  }

  Widget _buildShareCard(Map<String, dynamic> share) {
    final theme = csTheme;
    final accentColor = theme.colorScheme.primary;
    final isPlan = share['type'] == 'plan';
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(isPlan ? Icons.assignment_rounded : Icons.calendar_today, color: accentColor, size: 24),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    share['title'],
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${share['sharedBy']} • ${share['sharedAt']}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: accentColor.withOpacity(0.82),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return const Color(0xFFFACC15);
      case 'in_progress':
        return const Color(0xFF5EEAD4);
      case 'done':
        return const Color(0xFF60A5FA);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return '대기';
      case 'in_progress':
        return '진행중';
      case 'done':
        return '완료';
      default:
        return '대기';
    }
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

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF23262F),
        title: const Text('정렬', style: TextStyle(color: Colors.white)),
        content: const Text('정렬 기능 구현 영역', style: TextStyle(color: Color(0xFF8E95A7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기', style: TextStyle(color: Color(0xFF5EEAD4))),
          ),
        ],
      ),
    );
  }
} 