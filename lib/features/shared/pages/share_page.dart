import 'package:flutter/material.dart';
import '../../../core/widgets/filter_bar.dart';
import '../../../core/theme/theme.dart';

enum ShareStatus { PENDING, ACCEPTED, REJECTED, DELETED }
enum ShareType { TEAM_WIDE, USER_SPECIFIC, DATE_RANGE, BULK_SHARE }

class SharedItem {
  final int id;
  final String type; // 'plan' or 'schedule'
  final String title;
  final String sharedBy;
  final DateTime sharedAt;
  final ShareStatus status;
  final String patient;
  final String? method; // for plans
  final String? time; // for schedules
  final ShareType shareType;
  final List<String> sharedWith;
  final String? dateRange; // for date range sharing
  final List<int>? bulkItemIds; // for bulk sharing
  final String? notes;

  SharedItem({
    required this.id,
    required this.type,
    required this.title,
    required this.sharedBy,
    required this.sharedAt,
    required this.status,
    required this.patient,
    this.method,
    this.time,
    required this.shareType,
    required this.sharedWith,
    this.dateRange,
    this.bulkItemIds,
    this.notes,
  });

  factory SharedItem.fromMap(Map<String, dynamic> map) {
    return SharedItem(
      id: map['id'] as int,
      type: map['type'] as String,
      title: map['title'] as String,
      sharedBy: map['sharedBy'] as String,
      sharedAt: DateTime.parse(map['sharedAt'] as String),
      status: ShareStatus.values.firstWhere(
        (e) => e.toString() == 'ShareStatus.${map['status'] ?? 'PENDING'}',
        orElse: () => ShareStatus.PENDING,
      ),
      patient: map['patient'] as String,
      method: map['method'] as String?,
      time: map['time'] as String?,
      shareType: ShareType.values.firstWhere(
        (e) => e.toString() == 'ShareType.${map['shareType'] ?? 'USER_SPECIFIC'}',
        orElse: () => ShareType.USER_SPECIFIC,
      ),
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      dateRange: map['dateRange'] as String?,
      bulkItemIds: map['bulkItemIds'] != null ? List<int>.from(map['bulkItemIds']) : null,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'sharedBy': sharedBy,
      'sharedAt': sharedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'patient': patient,
      'method': method,
      'time': time,
      'shareType': shareType.toString().split('.').last,
      'sharedWith': sharedWith,
      'dateRange': dateRange,
      'bulkItemIds': bulkItemIds,
      'notes': notes,
    };
  }

  SharedItem copyWith({
    int? id,
    String? type,
    String? title,
    String? sharedBy,
    DateTime? sharedAt,
    ShareStatus? status,
    String? patient,
    String? method,
    String? time,
    ShareType? shareType,
    List<String>? sharedWith,
    String? dateRange,
    List<int>? bulkItemIds,
    String? notes,
  }) {
    return SharedItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      sharedBy: sharedBy ?? this.sharedBy,
      sharedAt: sharedAt ?? this.sharedAt,
      status: status ?? this.status,
      patient: patient ?? this.patient,
      method: method ?? this.method,
      time: time ?? this.time,
      shareType: shareType ?? this.shareType,
      sharedWith: sharedWith ?? this.sharedWith,
      dateRange: dateRange ?? this.dateRange,
      bulkItemIds: bulkItemIds ?? this.bulkItemIds,
      notes: notes ?? this.notes,
    );
  }
}

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);
  @override
  State<SharePage> createState() => SharePageState();
}

class SharePageState extends State<SharePage> {
  List<SharedItem> sharedItems = [
    SharedItem(
      id: 1,
      type: 'plan',
      title: '김환자 치료계획',
      sharedBy: '김치료사',
      sharedAt: DateTime.now().subtract(const Duration(days: 3)),
      status: ShareStatus.PENDING,
      patient: '김환자',
      method: 'Manual Therapy',
      shareType: ShareType.TEAM_WIDE,
      sharedWith: ['팀 전체'],
    ),
    SharedItem(
      id: 2,
      type: 'schedule',
      title: '이환자 치료일정',
      sharedBy: '이치료사',
      sharedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: ShareStatus.ACCEPTED,
      patient: '이환자',
      time: '오전 9:00~10:00',
      shareType: ShareType.USER_SPECIFIC,
      sharedWith: ['김치료사', '박치료사'],
    ),
    SharedItem(
      id: 3,
      type: 'plan',
      title: '박환자 재활계획',
      sharedBy: '박치료사',
      sharedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: ShareStatus.REJECTED,
      patient: '박환자',
      method: 'Exercise Therapy',
      shareType: ShareType.DATE_RANGE,
      sharedWith: ['김치료사'],
      dateRange: '2024-07-01 ~ 2024-07-31',
    ),
    SharedItem(
      id: 4,
      type: 'plan',
      title: '다중 치료계획 일괄공유',
      sharedBy: '김치료사',
      sharedAt: DateTime.now().subtract(const Duration(hours: 6)),
      status: ShareStatus.PENDING,
      patient: '다중 환자',
      method: 'Various',
      shareType: ShareType.BULK_SHARE,
      sharedWith: ['팀 전체'],
      bulkItemIds: [101, 102, 103, 104],
      notes: '4개 치료계획 일괄 공유',
    ),
    SharedItem(
      id: 5,
      type: 'schedule',
      title: '주간 팀 일정',
      sharedBy: '팀장',
      sharedAt: DateTime.now().subtract(const Duration(hours: 12)),
      status: ShareStatus.ACCEPTED,
      patient: '팀 전체',
      time: '주간 반복',
      shareType: ShareType.TEAM_WIDE,
      sharedWith: ['김치료사', '이치료사', '박치료사'],
    ),
  ];

  String search = '';
  String typeFilter = '전체';
  String statusFilter = '전체';
  String shareTypeFilter = '전체';
  String userFilter = '전체';
  String sortKey = '최신순';
  DateTime? startDate;
  DateTime? endDate;
  DateTime? sharedDateFilter;

  @override
  Widget build(BuildContext context) {
    final filteredItems = sharedItems.where((item) {
      final query = search.toLowerCase();
      final typeMatch = typeFilter == '전체' || item.type == typeFilter;
      final statusMatch = statusFilter == '전체' || 
          (statusFilter == '대기' && item.status == ShareStatus.PENDING) ||
          (statusFilter == '승인' && item.status == ShareStatus.ACCEPTED) ||
          (statusFilter == '거부' && item.status == ShareStatus.REJECTED);
      final shareTypeMatch = shareTypeFilter == '전체' || 
          (shareTypeFilter == '팀 전체' && item.shareType == ShareType.TEAM_WIDE) ||
          (shareTypeFilter == '특정 사용자' && item.shareType == ShareType.USER_SPECIFIC) ||
          (shareTypeFilter == '날짜 범위' && item.shareType == ShareType.DATE_RANGE) ||
          (shareTypeFilter == '일괄 공유' && item.shareType == ShareType.BULK_SHARE);
      final userMatch = userFilter == '전체' || item.sharedBy == userFilter;
      final searchMatch = search.isEmpty || 
          item.title.toLowerCase().contains(query) ||
          item.patient.toLowerCase().contains(query);
      
      // 날짜 범위 필터
      final rangeMatch = (startDate == null || item.sharedAt.isAfter(startDate!.subtract(const Duration(days: 1)))) &&
                        (endDate == null || item.sharedAt.isBefore(endDate!.add(const Duration(days: 1))));
      
      // 공유 날짜 필터
      final sharedDateMatch = sharedDateFilter == null || 
          item.sharedAt.year == sharedDateFilter!.year &&
          item.sharedAt.month == sharedDateFilter!.month &&
          item.sharedAt.day == sharedDateFilter!.day;
      
      return typeMatch && statusMatch && shareTypeMatch && userMatch && 
             searchMatch && rangeMatch && sharedDateMatch;
    }).toList();

    // 정렬
    switch (sortKey) {
      case '제목순':
        filteredItems.sort((a, b) => a.title.compareTo(b.title));
        break;
      case '환자명순':
        filteredItems.sort((a, b) => a.patient.compareTo(b.patient));
        break;
      case '공유자순':
        filteredItems.sort((a, b) => a.sharedBy.compareTo(b.sharedBy));
        break;
      case '상태순':
        filteredItems.sort((a, b) => a.status.index.compareTo(b.status.index));
        break;
      default:
        filteredItems.sort((a, b) => b.sharedAt.compareTo(a.sharedAt));
    }

    final csTheme = Theme.of(context);
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
                color: CsColors.primary.withOpacity(0.10),
                border: Border.all(
                  color: CsColors.primary.withOpacity(0.22),
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.share_rounded,
                color: CsColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '공유',
              style: csTheme.textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: CsColors.accent),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            tooltip: '검색',
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: CsColors.accent),
            onPressed: () {
              _showAdvancedFilterDialog();
            },
            tooltip: '필터',
          ),
          IconButton(
            icon: Icon(Icons.sort, color: CsColors.accent),
            onPressed: () {
              _showSortDialog();
            },
            tooltip: '정렬',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: CsColors.accent),
            onSelected: (value) {
              if (value == 'refresh') {
                setState(() {});
              } else if (value == 'bulk_share') {
                _showBulkShareDialog();
              } else if (value == 'settings') {
                Navigator.of(context).pushNamed('/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'refresh', child: Text('새로고침')),
              const PopupMenuItem(value: 'bulk_share', child: Text('일괄 공유')),
              const PopupMenuItem(value: 'settings', child: Text('설정')),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add, color: CsColors.accent),
            onPressed: () => _showShareDialog(),
            tooltip: '공유',
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
              if (filteredItems.isEmpty)
                _buildEmptyState()
              else
                _buildShareList(filteredItems),
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
          hintText: '제목 또는 환자명 검색',
          prefixIcon: Icon(Icons.search, color: CsColors.primary),
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
            // 1. 타입 필터 (Material Icon+텍스트, 한 줄)
            Row(
              children: [
                _ShareChip(
                  icon: Icons.description,
                  label: '계획',
                  selected: typeFilter == 'plan',
                  onTap: () => setState(() => typeFilter = 'plan'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _ShareChip(
                  icon: Icons.calendar_today,
                  label: '일정',
                  selected: typeFilter == 'schedule',
                  onTap: () => setState(() => typeFilter = 'schedule'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _ShareChip(
                  icon: Icons.all_inclusive,
                  label: '전체',
                  selected: typeFilter == '전체',
                  onTap: () => setState(() => typeFilter = '전체'),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 2. 상태 필터 (Material Icon+텍스트, 한 줄)
            Row(
              children: [
                _ShareChip(
                  icon: Icons.circle,
                  label: '대기',
                  selected: statusFilter == '대기',
                  onTap: () => setState(() => statusFilter = '대기'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _ShareChip(
                  icon: Icons.circle,
                  label: '승인',
                  selected: statusFilter == '승인',
                  onTap: () => setState(() => statusFilter = '승인'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _ShareChip(
                  icon: Icons.circle,
                  label: '거부',
                  selected: statusFilter == '거부',
                  onTap: () => setState(() => statusFilter = '거부'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _ShareChip(
                  icon: Icons.all_inclusive,
                  label: '전체',
                  selected: statusFilter == '전체',
                  onTap: () => setState(() => statusFilter = '전체'),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 3. 공유자 필터 (아이콘+드롭다운, 한 줄)
            Row(
              children: [
                const Icon(Icons.person_outline, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: userFilter == '전체' ? null : userFilter,
                    hint: const Text('공유자'),
                    items: sharedItems.map((i) => i.sharedBy).toSet().map((user) => DropdownMenuItem(
                      value: user,
                      child: Text(user),
                    )).toList(),
                    onChanged: (value) => setState(() => userFilter = value ?? '전체'),
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
            const SizedBox(height: 10),
            // 4. 공유일/범위 필터 (공통 위젯)
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
          ],
        ),
      ),
    );
  }

  Widget _buildShareList(List<SharedItem> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildShareCard(item);
      },
    );
  }

  Widget _buildShareCard(SharedItem item) {
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
            Icon(
              item.type == 'plan' ? Icons.assignment_rounded : Icons.calendar_today,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
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
                    item.type == 'plan'
                        ? '방법: ${item.method}'
                        : '시간: ${item.time}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary.withOpacity(0.82),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.patient != null && item.patient.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '환자: ${item.patient}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (item.sharedBy != null && item.sharedBy.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '공유자: ${item.sharedBy}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (item.sharedWith != null && item.sharedWith.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '대상: ${item.sharedWith.join(', ')}',
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
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(item.status).withOpacity(0.13),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getStatusText(item.status),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getStatusColor(item.status),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.share_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            '공유된 항목이 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 항목을 공유해보세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(int id, String action) {
    setState(() {
      final index = sharedItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        switch (action) {
          case 'accept':
            sharedItems[index] = sharedItems[index].copyWith(
              status: ShareStatus.ACCEPTED,
            );
            break;
          case 'reject':
            sharedItems[index] = sharedItems[index].copyWith(
              status: ShareStatus.REJECTED,
            );
            break;
          case 'delete':
            sharedItems.removeAt(index);
            break;
        }
      }
    });
    
    String message = '';
    Color backgroundColor = Colors.grey;
    
    switch (action) {
      case 'accept':
        message = '공유를 승인했습니다.';
        backgroundColor = const Color(0xFF5EEAD4);
        break;
      case 'reject':
        message = '공유를 거절했습니다.';
        backgroundColor = Colors.red[400]!;
        break;
      case 'delete':
        message = '공유를 삭제했습니다.';
        backgroundColor = Colors.grey[600]!;
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBulkShareDialog() {
    final selectedItems = <int>[];
    final usersCtl = TextEditingController();
    ShareType selectedShareType = ShareType.USER_SPECIFIC;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('다중 계획 일괄 공유'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('공유할 계획들을 선택하세요:'),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  children: [
                    _buildSelectableItem('김환자 치료계획', 101, selectedItems, setDialogState),
                    _buildSelectableItem('이환자 재활계획', 102, selectedItems, setDialogState),
                    _buildSelectableItem('박환자 운동계획', 103, selectedItems, setDialogState),
                    _buildSelectableItem('최환자 물리치료계획', 104, selectedItems, setDialogState),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('공유 방식: '),
                  DropdownButton<ShareType>(
                    value: selectedShareType,
                    items: ShareType.values.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getShareTypeText(type)),
                    )).toList(),
                    onChanged: (value) {
                      setDialogState(() => selectedShareType = value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usersCtl,
                decoration: const InputDecoration(
                  labelText: '공유 대상 (쉼표로 구분)',
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
                if (selectedItems.isNotEmpty && usersCtl.text.trim().isNotEmpty) {
                  final users = usersCtl.text.split(',').map((u) => u.trim()).toList();
                  setState(() {
                    sharedItems.insert(0, SharedItem(
                      id: DateTime.now().millisecondsSinceEpoch,
                      type: 'plan',
                      title: '다중 치료계획 일괄공유',
                      sharedBy: '현재 사용자',
                      sharedAt: DateTime.now(),
                      status: ShareStatus.PENDING,
                      patient: '다중 환자',
                      method: 'Various',
                      shareType: ShareType.BULK_SHARE,
                      sharedWith: users,
                      bulkItemIds: selectedItems,
                      notes: '${selectedItems.length}개 치료계획 일괄 공유',
                    ));
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('일괄 공유'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableItem(String title, int id, List<int> selectedItems, StateSetter setDialogState) {
    final isSelected = selectedItems.contains(id);
    return CheckboxListTile(
      title: Text(title),
      value: isSelected,
      onChanged: (value) {
        setDialogState(() {
          if (value == true) {
            selectedItems.add(id);
          } else {
            selectedItems.remove(id);
          }
        });
      },
    );
  }

  void _showShareDialog() {
    final titleCtl = TextEditingController();
    final patientCtl = TextEditingController();
    final usersCtl = TextEditingController();
    String selectedType = 'plan';
    ShareType selectedShareType = ShareType.USER_SPECIFIC;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('새 공유'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('유형: '),
                  DropdownButton<String>(
                    value: selectedType,
                    items: const [
                      DropdownMenuItem(value: 'plan', child: Text('치료계획')),
                      DropdownMenuItem(value: 'schedule', child: Text('일정')),
                    ],
                    onChanged: (value) {
                      setDialogState(() => selectedType = value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtl,
                decoration: const InputDecoration(
                  labelText: '제목',
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
              Row(
                children: [
                  const Text('공유 방식: '),
                  DropdownButton<ShareType>(
                    value: selectedShareType,
                    items: ShareType.values.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getShareTypeText(type)),
                    )).toList(),
                    onChanged: (value) {
                      setDialogState(() => selectedShareType = value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usersCtl,
                decoration: const InputDecoration(
                  labelText: '공유 대상 (쉼표로 구분)',
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
                if (titleCtl.text.trim().isNotEmpty && usersCtl.text.trim().isNotEmpty) {
                  final users = usersCtl.text.split(',').map((u) => u.trim()).toList();
                  setState(() {
                    sharedItems.insert(0, SharedItem(
                      id: DateTime.now().millisecondsSinceEpoch,
                      type: selectedType,
                      title: titleCtl.text.trim(),
                      sharedBy: '현재 사용자',
                      sharedAt: DateTime.now(),
                      status: ShareStatus.PENDING,
                      patient: patientCtl.text.trim(),
                      method: selectedType == 'plan' ? 'Manual Therapy' : null,
                      time: selectedType == 'schedule' ? '오전 9:00~10:00' : null,
                      shareType: selectedShareType,
                      sharedWith: users,
                    ));
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('공유'),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareDetail(SharedItem item) {
    final isPlan = item.type == 'plan';
    final isBulkShare = item.shareType == ShareType.BULK_SHARE;
    
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
                          backgroundColor: _getStatusColor(item.status).withOpacity(0.2),
                          child: Icon(
                            isPlan ? Icons.assignment : Icons.calendar_today,
                            color: _getStatusColor(item.status),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                isPlan ? '치료계획' : '일정',
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
                    _buildDetailRow('환자', item.patient),
                    if (isPlan) _buildDetailRow('치료방법', item.method ?? ''),
                    if (!isPlan) _buildDetailRow('시간', item.time ?? ''),
                    _buildDetailRow('공유자', item.sharedBy),
                    _buildDetailRow('공유일', _formatDate(item.sharedAt)),
                    _buildDetailRow('공유 방식', _getShareTypeText(item.shareType)),
                    _buildDetailRow('공유 대상', item.sharedWith.join(', ')),
                    _buildDetailRow('상태', _getStatusText(item.status)),
                    if (isBulkShare && item.bulkItemIds != null)
                      _buildDetailRow('일괄 항목', '${item.bulkItemIds!.length}개'),
                    if (item.notes != null)
                      _buildDetailRow('메모', item.notes!),
                    const SizedBox(height: 24),
                    if (item.status == ShareStatus.PENDING) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _handleAction(item.id, 'accept');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5EEAD4),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('승인'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _handleAction(item.id, 'reject');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red[400],
                                side: BorderSide(color: Colors.red[400]!),
                              ),
                              child: const Text('거절'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _handleAction(item.id, 'delete');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[400],
                            side: BorderSide(color: Colors.grey[400]!),
                          ),
                          child: const Text('삭제'),
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // 상세보기
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5EEAD4),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('상세보기'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
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
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
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
                    DropdownMenuItem(value: '대기', child: Text('대기')),
                    DropdownMenuItem(value: '승인', child: Text('승인')),
                    DropdownMenuItem(value: '거부', child: Text('거부')),
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
                    DropdownMenuItem(value: 'plan', child: Text('계획')),
                    DropdownMenuItem(value: 'schedule', child: Text('일정')),
                  ],
                  onChanged: (v) => setState(() => typeFilter = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('공유 방식: '),
                DropdownButton<String>(
                  value: shareTypeFilter,
                  items: const [
                    DropdownMenuItem(value: '전체', child: Text('전체')),
                    DropdownMenuItem(value: '팀', child: Text('팀')),
                    DropdownMenuItem(value: '일괄', child: Text('일괄')),
                    DropdownMenuItem(value: '특정', child: Text('특정')),
                  ],
                  onChanged: (v) => setState(() => shareTypeFilter = v!),
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
            DropdownMenuItem(value: '오래된순', child: Text('오래된순')),
            DropdownMenuItem(value: '상태순', child: Text('상태순')),
            DropdownMenuItem(value: '공유자순', child: Text('공유자순')),
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

  Color _getStatusColor(ShareStatus status) {
    switch (status) {
      case ShareStatus.ACCEPTED:
        return const Color(0xFF5EEAD4);
      case ShareStatus.PENDING:
        return const Color(0xFFFACC15);
      case ShareStatus.REJECTED:
        return Colors.red[400]!;
      case ShareStatus.DELETED:
        return Colors.grey[600]!;
    }
  }

  String _getStatusText(ShareStatus status) {
    switch (status) {
      case ShareStatus.ACCEPTED:
        return '승인됨';
      case ShareStatus.PENDING:
        return '대기';
      case ShareStatus.REJECTED:
        return '거절됨';
      case ShareStatus.DELETED:
        return '삭제됨';
    }
  }

  Color _getShareTypeColor(ShareType shareType) {
    switch (shareType) {
      case ShareType.TEAM_WIDE:
        return const Color(0xFFFACC15);
      case ShareType.USER_SPECIFIC:
        return const Color(0xFF5EEAD4);
      case ShareType.DATE_RANGE:
        return const Color(0xFF8B5CF6);
      case ShareType.BULK_SHARE:
        return const Color(0xFFFACC15);
    }
  }

  String _getShareTypeText(ShareType shareType) {
    switch (shareType) {
      case ShareType.TEAM_WIDE:
        return '팀 전체';
      case ShareType.USER_SPECIFIC:
        return '특정 사용자';
      case ShareType.DATE_RANGE:
        return '날짜 범위';
      case ShareType.BULK_SHARE:
        return '일괄 공유';
    }
  }

  String _formatDate(DateTime date) {
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
}

// 타입/상태 Chip 위젯 (Material Icon+텍스트)
class _ShareChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;
  const _ShareChip({this.icon, required this.label, required this.selected, required this.onTap, required this.theme});
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