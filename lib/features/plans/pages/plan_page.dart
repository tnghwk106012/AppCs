import 'package:flutter/material.dart';
import '../models/plan.dart';
import '../../../core/widgets/filter_bar.dart';
import 'package:hello_world_app/core/theme/theme.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);
  @override
  State<PlanPage> createState() => PlanPageState();
}

class PlanPageState extends State<PlanPage> {
  List<Plan> plans = [
    Plan(
      id: 1,
      patient: '김환자',
      method: 'Manual Therapy',
      protocol: 'Shoulder Rehab Phase1',
      goal: '가동범위 증가',
      indicators: 'ROM 120도',
      detail: '주 3회, 4주간 진행',
      tags: ['운동', '재활'],
      status: '진행중',
      due: '2024-07-10',
      treatmentLocation: 'A병동',
      treatmentTime: '오전 9:00~10:00',
      therapistName: '김치료사',
      hasSchedules: true,
      scheduleIds: [1, 2, 3],
      isOwned: true,
      shareStatus: PlanShareStatus.NOT_SHARED,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Plan(
      id: 2,
      patient: '이환자',
      method: 'Exercise Therapy',
      protocol: 'Knee Post-Op Phase2',
      goal: '근력 회복',
      indicators: '무릎 굴곡 110도',
      detail: '매일 30분 운동',
      tags: ['운동', '회복'],
      status: '대기',
      due: '2024-07-15',
      treatmentLocation: 'B센터',
      treatmentTime: '오후 2:00~3:00',
      therapistName: '이치료사',
      hasSchedules: false,
      isOwned: false,
      sharedBy: '박치료사',
      shareStatus: PlanShareStatus.PENDING,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Plan(
      id: 3,
      patient: '박환자',
      method: 'Occupational Therapy',
      protocol: 'Stroke Recovery Protocol',
      goal: '일상생활 능력 향상',
      indicators: 'ADL 점수 80점',
      detail: '주 2회, 6주간 진행',
      tags: ['재활', '일상생활'],
      status: '완료',
      due: '2024-06-30',
      treatmentLocation: '상담실',
      treatmentTime: '오전 10:00~11:00',
      therapistName: '박치료사',
      hasSchedules: true,
      scheduleIds: [4, 5, 6, 7],
      isOwned: true,
      shareStatus: PlanShareStatus.SHARED,
      sharedWith: ['김치료사', '이치료사'],
      templateType: PlanTemplateType.STROKE_RECOVERY,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  String search = '';
  String statusFilter = '전체';
  String ownershipFilter = '전체';
  String therapistFilter = '전체';
  String locationFilter = '전체';
  String dateRangeFilter = '전체';
  String sortKey = '최신순';
  String templateFilter = '전체';
  DateTime? startDate;
  DateTime? endDate;
  DateTime? dueDateFilter;

  // 템플릿 데이터
  final List<Map<String, dynamic>> templates = [
    {
      'id': 1,
      'name': '어깨 재활 프로토콜',
      'type': PlanTemplateType.SHOULDER_REHAB,
      'method': 'Manual Therapy',
      'protocol': 'Shoulder Rehab Phase1',
      'goal': '가동범위 증가',
      'indicators': 'ROM 120도',
      'detail': '주 3회, 4주간 진행',
      'tags': ['운동', '재활'],
    },
    {
      'id': 2,
      'name': '무릎 수술 후 재활',
      'type': PlanTemplateType.KNEE_REHAB,
      'method': 'Exercise Therapy',
      'protocol': 'Knee Post-Op Phase2',
      'goal': '근력 회복',
      'indicators': '무릎 굴곡 110도',
      'detail': '매일 30분 운동',
      'tags': ['운동', '회복'],
    },
    {
      'id': 3,
      'name': '뇌졸중 회복 프로토콜',
      'type': PlanTemplateType.STROKE_RECOVERY,
      'method': 'Occupational Therapy',
      'protocol': 'Stroke Recovery Protocol',
      'goal': '일상생활 능력 향상',
      'indicators': 'ADL 점수 80점',
      'detail': '주 2회, 6주간 진행',
      'tags': ['재활', '일상생활'],
    },
  ];

  void _applySort(List<Plan> list) {
    switch (sortKey) {
      case '이름순':
        list.sort((a, b) => a.patient.compareTo(b.patient));
        break;
      case '마감일순':
        list.sort((a, b) => a.due.compareTo(b.due));
        break;
      case '상태순':
        list.sort((a, b) => a.status.compareTo(b.status));
        break;
      case '치료사순':
        list.sort((a, b) => (a.therapistName ?? '').compareTo(b.therapistName ?? ''));
        break;
      default:
        list.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlans = plans.where((plan) {
      final query = search.toLowerCase();
      final statusMatch = statusFilter == '전체' || plan.status == statusFilter;
      final ownershipMatch = ownershipFilter == '전체' || 
          (ownershipFilter == '내 계획' && plan.isOwned) ||
          (ownershipFilter == '공유받은 계획' && !plan.isOwned);
      final therapistMatch = therapistFilter == '전체' || plan.therapistName == therapistFilter;
      final locationMatch = locationFilter == '전체' || plan.treatmentLocation == locationFilter;
      final templateMatch = templateFilter == '전체' || 
          (templateFilter == '템플릿 사용' && plan.templateType != null) ||
          (templateFilter == '커스텀' && plan.templateType == null);
      final searchMatch = search.isEmpty || 
          plan.patient.toLowerCase().contains(query) ||
          plan.method.toLowerCase().contains(query);
      
      // 날짜 범위 필터
      final rangeMatch = (startDate == null || DateTime.parse(plan.due).isAfter(startDate!.subtract(const Duration(days: 1)))) &&
                        (endDate == null || DateTime.parse(plan.due).isBefore(endDate!.add(const Duration(days: 1))));
      
      // 마감일 필터
      final dueMatch = dueDateFilter == null || 
          DateTime.parse(plan.due).year == dueDateFilter!.year &&
          DateTime.parse(plan.due).month == dueDateFilter!.month &&
          DateTime.parse(plan.due).day == dueDateFilter!.day;
      
      return statusMatch && ownershipMatch && therapistMatch && locationMatch && 
             templateMatch && searchMatch && rangeMatch && dueMatch;
    }).toList();
    _applySort(filteredPlans);

    return Scaffold(
      backgroundColor: csTheme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: csTheme.colorScheme.background,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: csTheme.colorScheme.primary.withOpacity(0.10),
                border: Border.all(
                  color: csTheme.colorScheme.primary.withOpacity(0.22),
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.assignment_rounded,
                color: csTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '계획',
              style: csTheme.textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: csTheme.colorScheme.primary),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            tooltip: '검색',
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: csTheme.colorScheme.primary),
            onPressed: () {
              _showAdvancedFilterDialog();
            },
            tooltip: '필터',
          ),
          IconButton(
            icon: Icon(Icons.sort, color: csTheme.colorScheme.primary),
            onPressed: () {
              _showSortDialog();
            },
            tooltip: '정렬',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: csTheme.colorScheme.primary),
            onSelected: (value) {
              if (value == 'refresh') {
                setState(() {});
              } else if (value == 'templates') {
                _showTemplateDialog();
              } else if (value == 'settings') {
                Navigator.of(context).pushNamed('/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'refresh', child: Text('새로고침')),
              const PopupMenuItem(value: 'templates', child: Text('템플릿 관리')),
              const PopupMenuItem(value: 'settings', child: Text('설정')),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add, color: csTheme.colorScheme.primary),
            onPressed: () => _showQuickAddDialog(),
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
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildAdvancedFilters(),
              const SizedBox(height: 18),
              if (filteredPlans.isEmpty)
                _buildEmptyState()
              else
                _buildPlanList(filteredPlans),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: TextField(
        onChanged: (value) => setState(() => search = value),
        decoration: InputDecoration(
          hintText: '환자명 또는 치료법 검색',
          prefixIcon: Icon(Icons.search, color: csTheme.colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        ),
        style: csTheme.textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    final theme = csTheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 상태 필터 (Material Icon+텍스트, 한 줄)
            Row(
              children: [
                _PlanChip(
                  icon: Icons.circle,
                  label: '대기',
                  selected: statusFilter == '대기',
                  onTap: () => setState(() => statusFilter = '대기'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _PlanChip(
                  icon: Icons.circle,
                  label: '진행',
                  selected: statusFilter == '진행중',
                  onTap: () => setState(() => statusFilter = '진행중'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _PlanChip(
                  icon: Icons.circle,
                  label: '완료',
                  selected: statusFilter == '완료',
                  onTap: () => setState(() => statusFilter = '완료'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _PlanChip(
                  icon: Icons.all_inclusive,
                  label: '전체',
                  selected: statusFilter == '전체',
                  onTap: () => setState(() => statusFilter = '전체'),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 2. 소유권 필터 (Material Icon+텍스트, 한 줄)
            Row(
              children: [
                _PlanChip(
                  icon: Icons.person,
                  label: '내 계획',
                  selected: ownershipFilter == '내 계획',
                  onTap: () => setState(() => ownershipFilter = '내 계획'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _PlanChip(
                  icon: Icons.group,
                  label: '공유',
                  selected: ownershipFilter == '공유받은 계획',
                  onTap: () => setState(() => ownershipFilter = '공유받은 계획'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _PlanChip(
                  icon: Icons.all_inclusive,
                  label: '전체',
                  selected: ownershipFilter == '전체',
                  onTap: () => setState(() => ownershipFilter = '전체'),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 3. 템플릿 필터 (Material Icon, 한 줄)
            Row(
              children: [
                _PlanChip(
                  icon: Icons.description,
                  label: '템플릿',
                  selected: templateFilter == '템플릿 사용',
                  onTap: () => setState(() => templateFilter = '템플릿 사용'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _PlanChip(
                  icon: Icons.edit,
                  label: '커스텀',
                  selected: templateFilter == '커스텀',
                  onTap: () => setState(() => templateFilter = '커스텀'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _PlanChip(
                  icon: Icons.all_inclusive,
                  label: '전체',
                  selected: templateFilter == '전체',
                  onTap: () => setState(() => templateFilter = '전체'),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 4. 마감일/범위 필터 (공통 위젯)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dueDateFilter,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => dueDateFilter = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.13)),
                      ),
                      child: Text(
                        dueDateFilter != null
                            ? '${dueDateFilter!.year}.${dueDateFilter!.month.toString().padLeft(2, '0')}.${dueDateFilter!.day.toString().padLeft(2, '0')}'
                            : '마감일',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: dueDateFilter != null ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('~', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => startDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.13)),
                      ),
                      child: Text(
                        startDate != null
                            ? '${startDate!.year}.${startDate!.month.toString().padLeft(2, '0')}.${startDate!.day.toString().padLeft(2, '0')}'
                            : '시작일',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: startDate != null ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('~', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => endDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.13)),
                      ),
                      child: Text(
                        endDate != null
                            ? '${endDate!.year}.${endDate!.month.toString().padLeft(2, '0')}.${endDate!.day.toString().padLeft(2, '0')}'
                            : '종료일',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: endDate != null ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                if (startDate != null || endDate != null)
                  IconButton(
                    icon: Icon(Icons.clear, size: 18, color: theme.colorScheme.primary.withOpacity(0.7)),
                    onPressed: () => setState(() { startDate = null; endDate = null; }),
                    tooltip: '날짜 초기화',
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // 5. 치료사/장소 필터 (아이콘+드롭다운, 한 줄)
            Row(
              children: [
                const Icon(Icons.person_outline, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: therapistFilter == '전체' ? null : therapistFilter,
                    hint: const Text('치료사'),
                    items: plans.map((p) => p.therapistName).toSet().map((therapist) => DropdownMenuItem(
                      value: therapist,
                      child: Text(therapist ?? ''),
                    )).toList(),
                    onChanged: (value) => setState(() => therapistFilter = value ?? '전체'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                    icon: const Icon(Icons.arrow_drop_down),
                    dropdownColor: theme.colorScheme.surface,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: locationFilter == '전체' ? null : locationFilter,
                    hint: const Text('장소'),
                    items: plans.map((p) => p.treatmentLocation).toSet().map((location) => DropdownMenuItem(
                      value: location,
                      child: Text(location ?? ''),
                    )).toList(),
                    onChanged: (value) => setState(() => locationFilter = value ?? '전체'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                    icon: const Icon(Icons.arrow_drop_down),
                    dropdownColor: theme.colorScheme.surface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanList(List<Plan> plans) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return _buildSimplePlanCard(plan);
      },
    );
  }

  Widget _buildSimplePlanCard(Plan plan) {
    final theme = csTheme;
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
                Icon(Icons.assignment_rounded, color: theme.colorScheme.primary, size: 24),
                const SizedBox(height: 8),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _getStatusColor(plan.status),
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.background, width: 2),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  plan.status,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: _getStatusColor(plan.status),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan.patient,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!plan.isOwned)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(Icons.groups_rounded, color: theme.colorScheme.primary.withOpacity(0.55), size: 18),
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    plan.method,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary.withOpacity(0.82),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (plan.goal.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '목표: ${plan.goal}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (plan.hasSchedules)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '일정 연동됨',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (plan.templateType != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '템플릿 사용',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
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

  Color _getShareStatusColor(PlanShareStatus status) {
    switch (status) {
      case PlanShareStatus.NOT_SHARED:
        return Colors.grey;
      case PlanShareStatus.SHARED:
        return const Color(0xFF5EEAD4);
      case PlanShareStatus.PENDING:
        return const Color(0xFFFACC15);
      case PlanShareStatus.ACCEPTED:
        return const Color(0xFF60A5FA);
      case PlanShareStatus.REJECTED:
        return const Color(0xFFEF4444);
    }
  }

  IconData _getShareStatusIcon(PlanShareStatus status) {
    switch (status) {
      case PlanShareStatus.NOT_SHARED:
        return Icons.share;
      case PlanShareStatus.SHARED:
        return Icons.check;
      case PlanShareStatus.PENDING:
        return Icons.schedule;
      case PlanShareStatus.ACCEPTED:
        return Icons.check_circle;
      case PlanShareStatus.REJECTED:
        return Icons.cancel;
    }
  }

  String _getShareStatusText(PlanShareStatus status) {
    switch (status) {
      case PlanShareStatus.NOT_SHARED:
        return '미공유';
      case PlanShareStatus.SHARED:
        return '공유됨';
      case PlanShareStatus.PENDING:
        return '대기중';
      case PlanShareStatus.ACCEPTED:
        return '수락됨';
      case PlanShareStatus.REJECTED:
        return '거부됨';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            '치료계획이 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 치료계획을 추가해보세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickAddDialog() {
    final patientCtl = TextEditingController();
    final methodCtl = TextEditingController();
    final goalCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 치료계획'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: patientCtl,
              decoration: const InputDecoration(
                labelText: '환자명',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: methodCtl,
              decoration: const InputDecoration(
                labelText: '치료방법',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: goalCtl,
              decoration: const InputDecoration(
                labelText: '목표',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (patientCtl.text.trim().isEmpty || methodCtl.text.trim().isEmpty) return;
              setState(() {
                plans.insert(0, Plan(
                  id: DateTime.now().millisecondsSinceEpoch,
                  patient: patientCtl.text.trim(),
                  method: methodCtl.text.trim(),
                  protocol: '',
                  goal: goalCtl.text.trim(),
                  indicators: '',
                  detail: '',
                  tags: [],

                  status: '진행중',
                  due: DateTime.now().toString().substring(0, 10),
                  isOwned: true,
                  hasSchedules: false,
                  createdAt: DateTime.now(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _showAdvancedFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('상세 필터'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('상태: '),
                DropdownButton<String>(
                  value: statusFilter,
                  items: const [
                    DropdownMenuItem(value: '전체', child: Text('전체')),
                    DropdownMenuItem(value: '진행중', child: Text('진행중')),
                    DropdownMenuItem(value: '대기', child: Text('대기')),
                    DropdownMenuItem(value: '완료', child: Text('완료')),
                  ],
                  onChanged: (v) => setState(() => statusFilter = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('소유: '),
                DropdownButton<String>(
                  value: ownershipFilter,
                  items: const [
                    DropdownMenuItem(value: '전체', child: Text('전체')),
                    DropdownMenuItem(value: '내 계획', child: Text('내 계획')),
                    DropdownMenuItem(value: '공유받은 계획', child: Text('공유받은 계획')),
                  ],
                  onChanged: (v) => setState(() => ownershipFilter = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('치료사: '),
                DropdownButton<String>(
                  value: therapistFilter,
                  items: [
                    const DropdownMenuItem(value: '전체', child: Text('전체')),
                    ...plans.map((p) => p.therapistName).where((t) => t != null).toSet().map(
                      (t) => DropdownMenuItem(value: t, child: Text(t!)),
                    ),
                  ],
                  onChanged: (v) => setState(() => therapistFilter = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('장소: '),
                DropdownButton<String>(
                  value: locationFilter,
                  items: [
                    const DropdownMenuItem(value: '전체', child: Text('전체')),
                    ...plans.map((p) => p.treatmentLocation).where((l) => l != null).toSet().map(
                      (l) => DropdownMenuItem(value: l, child: Text(l!)),
                    ),
                  ],
                  onChanged: (v) => setState(() => locationFilter = v!),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('정렬'),
        content: DropdownButton<String>(
          value: sortKey,
          items: const [
            DropdownMenuItem(value: '최신순', child: Text('최신순')),
            DropdownMenuItem(value: '이름순', child: Text('이름순')),
            DropdownMenuItem(value: '마감일순', child: Text('마감일순')),
            DropdownMenuItem(value: '상태순', child: Text('상태순')),
            DropdownMenuItem(value: '치료사순', child: Text('치료사순')),
          ],
          onChanged: (v) => setState(() => sortKey = v!),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showTemplateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계획 템플릿'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return ListTile(
                leading: Icon(Icons.assignment, size: 24, color: const Color(0xFFFACC15)),
                title: Text(template['name']),
                subtitle: Text(template['method']),
                onTap: () {
                  Navigator.pop(context);
                  _createPlanFromTemplate(template);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _createPlanFromTemplate(Map<String, dynamic> template) {
    final patientCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${template['name']} 사용'),
        content: TextField(
          controller: patientCtl,
          decoration: const InputDecoration(
            labelText: '환자명',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (patientCtl.text.trim().isEmpty) return;
              setState(() {
                plans.insert(0, Plan(
                  id: DateTime.now().millisecondsSinceEpoch,
                  patient: patientCtl.text.trim(),
                  method: template['method'],
                  protocol: template['protocol'],
                  goal: template['goal'],
                  indicators: template['indicators'],
                  detail: template['detail'],
                  tags: List<String>.from(template['tags']),

                  status: '진행중',
                  due: DateTime.now().toString().substring(0, 10),
                  isOwned: true,
                  hasSchedules: false,
                  templateType: template['type'],
                  createdAt: DateTime.now(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }

  void _showScheduleIntegrationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 연동'),
        content: const Text('일정 연동 기능은 일정 페이지에서 구현됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showPlanDetail(Plan plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF23262F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _getStatusColor(plan.status).withOpacity(0.2),
                          child: Icon(
                            Icons.assignment,
                            color: _getStatusColor(plan.status),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.patient,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                plan.method,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow('목표', plan.goal),
                    _buildDetailRow('프로토콜', plan.protocol),
                    _buildDetailRow('지표', plan.indicators),
                    _buildDetailRow('치료장소', plan.treatmentLocation ?? '미지정'),
                    _buildDetailRow('치료시간', plan.treatmentTime ?? '미지정'),
                    _buildDetailRow('담당치료사', plan.therapistName ?? '미지정'),
                    if (!plan.isOwned) _buildDetailRow('공유자', plan.sharedBy ?? ''),
                    if (plan.hasSchedules) _buildDetailRow('연동 일정', '${plan.scheduleIds?.length ?? 0}개'),
                    if (plan.templateType != null) _buildDetailRow('템플릿', _getTemplateTypeText(plan.templateType!)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        if (plan.isOwned) ...[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // 편집 페이지로 이동
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5EEAD4),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('편집'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _showShareDialog(plan);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFFACC15),
                                side: const BorderSide(color: Color(0xFFFACC15)),
                              ),
                              child: const Text('공유'),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _showShareActionDialog(plan);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5EEAD4),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('공유 응답'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTemplateTypeText(PlanTemplateType type) {
    switch (type) {
      case PlanTemplateType.SHOULDER_REHAB:
        return '어깨 재활';
      case PlanTemplateType.KNEE_REHAB:
        return '무릎 재활';
      case PlanTemplateType.STROKE_RECOVERY:
        return '뇌졸중 회복';
      case PlanTemplateType.CUSTOM:
        return '커스텀';
    }
  }

  void _showShareDialog(Plan plan) {
    final usersCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계획 공유'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usersCtl,
              decoration: const InputDecoration(
                labelText: '공유할 사용자 (쉼표로 구분)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (usersCtl.text.trim().isNotEmpty) {
                final users = usersCtl.text.split(',').map((u) => u.trim()).toList();
                setState(() {
                  final index = plans.indexWhere((p) => p.id == plan.id);
                  if (index != -1) {
                    plans[index] = plan.copyWith(
                      shareStatus: PlanShareStatus.SHARED,
                      sharedWith: users,
                    );
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text('공유'),
          ),
        ],
      ),
    );
  }

  void _showShareActionDialog(Plan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('공유 응답'),
        content: const Text('이 계획을 수락하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                final index = plans.indexWhere((p) => p.id == plan.id);
                if (index != -1) {
                  plans[index] = plan.copyWith(
                    shareStatus: PlanShareStatus.REJECTED,
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text('거부'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = plans.indexWhere((p) => p.id == plan.id);
                if (index != -1) {
                  plans[index] = plan.copyWith(
                    shareStatus: PlanShareStatus.ACCEPTED,
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text('수락'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '진행중':
        return const Color(0xFF5EEAD4);
      case '대기':
        return const Color(0xFFFACC15);
      case '완료':
        return const Color(0xFF60A5FA);
      default:
        return Colors.grey;
    }
  }
}

// 상태/소유권/템플릿 Chip 위젯 (Material Icon+텍스트)
class _PlanChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;
  const _PlanChip({this.icon, required this.label, required this.selected, required this.onTap, required this.theme});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary.withOpacity(0.18) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 