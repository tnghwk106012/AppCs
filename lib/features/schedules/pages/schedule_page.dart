import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../../../core/widgets/filter_bar.dart';
import '../../../core/theme/theme.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  List<Schedule> schedules = [
    Schedule(
      id: 1,
      title: '김환자 치료',
      time: '오전 9:00~10:00',
      location: 'A병동',
      patientName: '김환자',
      status: 'waiting',
      category: '치료',
      importance: '중요',
      repeat: false,
      date: DateTime.now(),
      therapistName: '김치료사',
      type: ScheduleType.PERSONAL,
      shareStatus: ScheduleShareStatus.NOT_SHARED,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Schedule(
      id: 2,
      title: '이환자 상담',
      time: '오후 2:00~3:00',
      location: '상담실',
      patientName: '이환자',
      status: 'in_progress',
      category: '상담',
      importance: '보통',
      repeat: true,
      date: DateTime.now().add(const Duration(days: 1)),
      therapistName: '이치료사',
      type: ScheduleType.TEAM,
      shareStatus: ScheduleShareStatus.SHARED,
      sharedWith: ['김치료사', '박치료사'],
      repeatType: RepeatType.WEEKLY,
      repeatInterval: 1,
      repeatUntil: DateTime.now().add(const Duration(days: 30)),
      repeatDays: [1, 3, 5], // 월, 수, 금
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Schedule(
      id: 3,
      title: '박환자 진료',
      time: '오전 10:00~11:00',
      location: '외래실',
      patientName: '박환자',
      status: 'done',
      category: '진료',
      importance: '매우중요',
      repeat: false,
      date: DateTime.now().subtract(const Duration(days: 1)),
      therapistName: '박치료사',
      type: ScheduleType.PERSONAL,
      shareStatus: ScheduleShareStatus.NOT_SHARED,
      conflictStatus: ConflictStatus.WARNING,
      conflictMessage: '동일 시간대에 다른 일정이 있습니다',
      conflictingSchedules: ['4', '5'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Schedule(
      id: 4,
      title: '팀 회의',
      time: '오후 3:00~4:00',
      location: '회의실',
      patientName: '팀 전체',
      status: 'waiting',
      category: '회의',
      importance: '중요',
      repeat: true,
      date: DateTime.now().add(const Duration(days: 2)),
      therapistName: '팀장',
      type: ScheduleType.TEAM,
      shareStatus: ScheduleShareStatus.SHARED,
      sharedWith: ['김치료사', '이치료사', '박치료사'],
      repeatType: RepeatType.WEEKLY,
      repeatInterval: 1,
      repeatUntil: DateTime.now().add(const Duration(days: 90)),
      repeatDays: [2], // 화요일
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  String search = '';
  String statusFilter = '전체';
  String typeFilter = '전체';
  String categoryFilter = '전체';
  String sortKey = '최신순';
  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;
  bool showRepeatingOnly = false;
  bool showConflictOnly = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = csTheme;
    final filteredSchedules = schedules.where((schedule) {
      final query = search.toLowerCase();
      final statusMatch = statusFilter == '전체' || _getStatusText(schedule.status) == statusFilter;
      final typeMatch = typeFilter == '전체' || 
          (typeFilter == '개인' && schedule.type == ScheduleType.PERSONAL) ||
          (typeFilter == '팀' && schedule.type == ScheduleType.TEAM);
      final categoryMatch = categoryFilter == '전체' || schedule.category == categoryFilter;
      final searchMatch = search.isEmpty || 
          schedule.patientName.toLowerCase().contains(query) ||
          schedule.title.toLowerCase().contains(query);
      
      // 날짜 필터
      final dateMatch = selectedDate == null || 
          (schedule.date.year == selectedDate!.year &&
           schedule.date.month == selectedDate!.month &&
           schedule.date.day == selectedDate!.day);
      
      // 날짜 범위 필터
      final rangeMatch = (startDate == null || schedule.date.isAfter(startDate!.subtract(const Duration(days: 1)))) &&
                        (endDate == null || schedule.date.isBefore(endDate!.add(const Duration(days: 1))));
      
      // 반복 일정 필터
      final repeatMatch = !showRepeatingOnly || schedule.isRepeating;
      
      // 충돌 일정 필터
      final conflictMatch = !showConflictOnly || schedule.hasConflict;
      
      return statusMatch && typeMatch && categoryMatch && searchMatch && 
             dateMatch && rangeMatch && repeatMatch && conflictMatch;
    }).toList();

    // 정렬
    switch (sortKey) {
      case '시간순':
        filteredSchedules.sort((a, b) => a.date.compareTo(b.date));
        break;
      case '중요도순':
        filteredSchedules.sort((a, b) => _getImportanceWeight(a.importance).compareTo(_getImportanceWeight(b.importance)));
        break;
      case '환자명순':
        filteredSchedules.sort((a, b) => a.patientName.compareTo(b.patientName));
        break;
      default:
        filteredSchedules.sort((a, b) => (b.createdAt ?? DateTime(2000)).compareTo(a.createdAt ?? DateTime(2000)));
    }

    // 날짜별로 그룹화
    final groupedSchedules = <String, List<Schedule>>{};
    for (final schedule in filteredSchedules) {
      final dateKey = '${schedule.date.year}-${schedule.date.month.toString().padLeft(2, '0')}-${schedule.date.day.toString().padLeft(2, '0')}';
      groupedSchedules.putIfAbsent(dateKey, () => []).add(schedule);
    }

    return Theme(
      data: appTheme,
      child: Scaffold(
        backgroundColor: appTheme.colorScheme.background,
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
                  Icons.calendar_today,
                  color: appTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '일정',
                style: appTheme.textTheme.titleLarge,
              ),
            ],
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(appTheme),
                const SizedBox(height: 12),
                _buildAdvancedFilters(appTheme),
                const SizedBox(height: 18),
                if (groupedSchedules.isEmpty)
                  _buildEmptyState(appTheme)
                else
                  _buildScheduleList(groupedSchedules, appTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: TextField(
        onChanged: (value) => setState(() => search = value),
        decoration: InputDecoration(
          hintText: '환자명 또는 일정 검색',
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        ),
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildAdvancedFilters(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusChip(
                  icon: Icons.circle,
                  label: '대기',
                  selected: statusFilter == '대기',
                  onTap: () => setState(() => statusFilter = '대기'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  icon: Icons.circle,
                  label: '진행중',
                  selected: statusFilter == '진행중',
                  onTap: () => setState(() => statusFilter = '진행중'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  icon: Icons.circle,
                  label: '완료',
                  selected: statusFilter == '완료',
                  onTap: () => setState(() => statusFilter = '완료'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  icon: Icons.all_inclusive,
                  label: '전체',
                  selected: statusFilter == '전체',
                  onTap: () => setState(() => statusFilter = '전체'),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatusChip(
                  icon: Icons.person,
                  label: '개인',
                  selected: typeFilter == '개인',
                  onTap: () => setState(() => typeFilter = '개인'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  icon: Icons.group,
                  label: '팀',
                  selected: typeFilter == '팀',
                  onTap: () => setState(() => typeFilter = '팀'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  icon: Icons.all_inclusive,
                  label: '전체',
                  selected: typeFilter == '전체',
                  onTap: () => setState(() => typeFilter = '전체'),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatusChip(
                  icon: Icons.repeat,
                  label: '반복',
                  selected: showRepeatingOnly,
                  onTap: () => setState(() => showRepeatingOnly = !showRepeatingOnly),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  icon: Icons.warning_amber_rounded,
                  label: '충돌',
                  selected: showConflictOnly,
                  onTap: () => setState(() => showConflictOnly = !showConflictOnly),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
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
            Row(
              children: [
                const Icon(Icons.category, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: categoryFilter == '전체' ? null : categoryFilter,
                    hint: const Text('카테고리'),
                    items: [
                      '치료',
                      '상담',
                      '진료',
                      '회의',
                    ].map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    )).toList(),
                    onChanged: (value) => setState(() => categoryFilter = value ?? '전체'),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: theme.textTheme.bodyMedium,
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(Map<String, List<Schedule>> groupedSchedules, ThemeData theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: groupedSchedules.length,
      itemBuilder: (context, index) {
        final dateKey = groupedSchedules.keys.elementAt(index);
        final schedules = groupedSchedules[dateKey]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _formatDate(dateKey),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary.withOpacity(0.65),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                ),
              ),
            ),
            ...schedules.map((schedule) => _buildSimpleScheduleCard(schedule, theme)),
          ],
        );
      },
    );
  }

  String _formatDate(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    
    if (target == today) {
      return '오늘';
    } else if (target == today.add(const Duration(days: 1))) {
      return '내일';
    } else if (target == today.subtract(const Duration(days: 1))) {
      return '어제';
    } else {
      return '${date.month}월 ${date.day}일';
    }
  }

  Widget _buildSimpleScheduleCard(Schedule schedule, ThemeData theme) {
    final statusColor = _getStatusColor(schedule.status);
    final accentColor = theme.colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showScheduleDetail(schedule),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getCategoryIcon(schedule.category), color: accentColor, size: 24),
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
                    _getStatusText(schedule.status),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            schedule.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (schedule.type == ScheduleType.TEAM)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.groups_rounded, color: accentColor.withOpacity(0.55), size: 18),
                          ),
                        if (schedule.isRepeating)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(Icons.repeat, color: accentColor.withOpacity(0.38), size: 16),
                          ),
                        if (schedule.hasConflict)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error.withOpacity(0.7), size: 16),
                          ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _formatDateTime(schedule.date, schedule.time),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: accentColor.withOpacity(0.82),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (schedule.patientName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '담당: ${schedule.therapistName}  |  환자: ${schedule.patientName}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (schedule.location.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '장소: ${schedule.location}',
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
      ),
    );
  }

  String _formatDateTime(DateTime date, String? time) {
    final weekday = ['월', '화', '수', '목', '금', '토', '일'][date.weekday - 1];
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}($weekday)';
    return time != null && time.isNotEmpty ? '$dateStr $time' : dateStr;
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            '일정이 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 일정을 추가해보세요',
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
    final titleCtl = TextEditingController();
    final patientCtl = TextEditingController();
    final timeCtl = TextEditingController();
    final locationCtl = TextEditingController();
    RepeatType selectedRepeatType = RepeatType.NONE;
    DateTime selectedDate = DateTime.now();
    String selectedCategory = '치료';
    String selectedImportance = '보통';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('새 일정'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtl,
                  decoration: const InputDecoration(
                    labelText: '일정 제목',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: patientCtl,
                  decoration: const InputDecoration(
                    labelText: '환자명',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text('날짜: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: timeCtl,
                  decoration: const InputDecoration(
                    labelText: '시간',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationCtl,
                  decoration: const InputDecoration(
                    labelText: '장소',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('카테고리: '),
                    DropdownButton<String>(
                      value: selectedCategory,
                      items: ['치료', '상담', '진료', '회의'].map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      )).toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedCategory = value!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('중요도: '),
                    DropdownButton<String>(
                      value: selectedImportance,
                      items: ['보통', '중요', '매우중요'].map((importance) => DropdownMenuItem(
                        value: importance,
                        child: Text(importance),
                      )).toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedImportance = value!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('반복: '),
                    DropdownButton<RepeatType>(
                      value: selectedRepeatType,
                      items: RepeatType.values.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(_getRepeatTypeText(type)),
                      )).toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedRepeatType = value!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtl.text.trim().isEmpty || patientCtl.text.trim().isEmpty) return;
                setState(() {
                  schedules.insert(0, Schedule(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: titleCtl.text.trim(),
                    time: timeCtl.text.trim(),
                    location: locationCtl.text.trim(),
                    patientName: patientCtl.text.trim(),
                    status: 'waiting',
                    category: selectedCategory,
                    importance: selectedImportance,
                    repeat: selectedRepeatType != RepeatType.NONE,
                    date: selectedDate,
                    type: ScheduleType.PERSONAL,
                    shareStatus: ScheduleShareStatus.NOT_SHARED,
                    repeatType: selectedRepeatType,
                    createdAt: DateTime.now(),
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('추가'),
            ),
          ],
        ),
      ),
    );
  }

  String _getRepeatTypeText(RepeatType type) {
    switch (type) {
      case RepeatType.NONE:
        return '반복 안함';
      case RepeatType.DAILY:
        return '매일';
      case RepeatType.WEEKLY:
        return '매주';
      case RepeatType.MONTHLY:
        return '매월';
      case RepeatType.CUSTOM:
        return '사용자정의';
    }
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
                    DropdownMenuItem(value: '대기', child: Text('대기')),
                    DropdownMenuItem(value: '진행중', child: Text('진행중')),
                    DropdownMenuItem(value: '완료', child: Text('완료')),
                  ],
                  onChanged: (v) => setState(() => statusFilter = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('유형: '),
                DropdownButton<String>(
                  value: typeFilter,
                  items: const [
                    DropdownMenuItem(value: '전체', child: Text('전체')),
                    DropdownMenuItem(value: '개인', child: Text('개인')),
                    DropdownMenuItem(value: '팀', child: Text('팀')),
                  ],
                  onChanged: (v) => setState(() => typeFilter = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('카테고리: '),
                DropdownButton<String>(
                  value: categoryFilter,
                  items: [
                    const DropdownMenuItem(value: '전체', child: Text('전체')),
                    ...schedules.map((s) => s.category).toSet().map(
                      (c) => DropdownMenuItem(value: c, child: Text(c)),
                    ),
                  ],
                  onChanged: (v) => setState(() => categoryFilter = v!),
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
            DropdownMenuItem(value: '시간순', child: Text('시간순')),
            DropdownMenuItem(value: '중요도순', child: Text('중요도순')),
            DropdownMenuItem(value: '환자명순', child: Text('환자명순')),
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

  void _showConflictCheckDialog() {
    final conflicts = schedules.where((s) => s.hasConflict).toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('충돌 확인'),
        content: SizedBox(
          width: double.maxFinite,
          child: conflicts.isEmpty
              ? const Text('충돌하는 일정이 없습니다.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: conflicts.length,
                  itemBuilder: (context, index) {
                    final schedule = conflicts[index];
                    return ListTile(
                      leading: Icon(
                        _getConflictIcon(schedule.conflictStatus),
                        color: _getConflictColor(schedule.conflictStatus),
                      ),
                      title: Text(schedule.title),
                      subtitle: Text(schedule.conflictMessage ?? '충돌 발생'),
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

  void _showScheduleDetail(Schedule schedule) {
    final accentColor = CsColors.primary;
    final statusColor = _getStatusColor(schedule.status);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: CsColors.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: CsShadow.soft,
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(_getCategoryIcon(schedule.category), color: accentColor, size: 22),
                        const SizedBox(width: 8),
                        Text(schedule.category, style: TextStyle(color: accentColor, fontWeight: FontWeight.w700, fontSize: 15, fontFamily: 'Inter')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(_getStatusText(schedule.status), style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 15, fontFamily: 'Inter')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                schedule.title,
                style: TextStyle(
                  color: CsColors.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  fontFamily: 'Inter',
                  letterSpacing: 0.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Text(
                _formatDateTime(schedule.date, schedule.time),
                style: TextStyle(
                  color: accentColor.withOpacity(0.88),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
              if (schedule.location.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    schedule.location,
                    style: TextStyle(
                      color: CsColors.textMuted.withOpacity(0.8),
                      fontSize: 14.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              if (schedule.patientName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    '담당: ${schedule.therapistName}  |  환자: ${schedule.patientName}',
                    style: TextStyle(
                      color: CsColors.textMuted.withOpacity(0.8),
                      fontSize: 14.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              const SizedBox(height: 28),
              Divider(color: CsColors.divider, thickness: 1.1, height: 1),
              const SizedBox(height: 18),
              Row(
                children: [
                  if (schedule.isRepeating)
                    Row(
                      children: [
                        Icon(Icons.repeat, color: accentColor.withOpacity(0.38), size: 18),
                        const SizedBox(width: 8),
                        Text('반복 일정', style: TextStyle(color: accentColor.withOpacity(0.55), fontSize: 13.5, fontFamily: 'Inter')),
                      ],
                    ),
                  if (schedule.hasConflict)
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: CsColors.error.withOpacity(0.7), size: 18),
                        const SizedBox(width: 8),
                        Text('일정 충돌', style: TextStyle(color: CsColors.error.withOpacity(0.7), fontSize: 13.5, fontFamily: 'Inter')),
                      ],
                    ),
                  if (!schedule.isRepeating && !schedule.hasConflict)
                    Text('일반 일정', style: TextStyle(color: CsColors.textMuted.withOpacity(0.7), fontSize: 13.5, fontFamily: 'Inter')),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text('닫기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CsColors.surface,
                      foregroundColor: CsColors.text,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 18),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('수정'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        return status;
    }
  }

  double _getImportanceWeight(String importance) {
    switch (importance) {
      case '중요':
        return 3.0;
      case '보통':
        return 2.0;
      case '매우중요':
        return 4.0;
      default:
        return 1.0;
    }
  }

  IconData _getConflictIcon(ConflictStatus status) {
    switch (status) {
      case ConflictStatus.NONE:
        return Icons.check;
      case ConflictStatus.WARNING:
        return Icons.warning;
      case ConflictStatus.CONFLICT:
        return Icons.error;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '치료':
        return Icons.healing;
      case '상담':
        return Icons.psychology;
      case '진료':
        return Icons.medical_services;
      case '회의':
        return Icons.meeting_room;
      default:
        return Icons.event;
    }
  }

  // 충돌 상태별 컬러 반환 (컴파일 에러 해결)
  Color _getConflictColor(ConflictStatus status) {
    switch (status) {
      case ConflictStatus.NONE:
        return Colors.grey;
      case ConflictStatus.WARNING:
        return const Color(0xFFFACC15);
      case ConflictStatus.CONFLICT:
        return const Color(0xFFEF4444);
    }
  }
}

// 상태/유형/반복/충돌 Chip 위젯 (Material Icon+텍스트)
class _StatusChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;
  const _StatusChip({this.icon, required this.label, required this.selected, required this.onTap, required this.theme});
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