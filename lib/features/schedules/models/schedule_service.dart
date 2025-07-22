import 'schedule.dart';
import '../../plans/models/plan.dart';

class ScheduleService {
  // 팀 일정을 개인 일정으로 변환
  static Schedule convertTeamToPersonal(Schedule teamSchedule, String userId) {
    return teamSchedule.copyWith(
      id: DateTime.now().millisecondsSinceEpoch, // 새로운 ID 생성
      type: ScheduleType.PERSONAL,
      shareStatus: ScheduleShareStatus.NOT_SHARED,
      originalScheduleId: teamSchedule.id.toString(),
      sharedWith: [],
      sharedBy: null,
      sharedAt: null,
    );
  }

  // 개인 일정을 팀 일정으로 변환
  static Schedule convertPersonalToTeam(Schedule personalSchedule) {
    return personalSchedule.copyWith(
      type: ScheduleType.TEAM,
      shareStatus: ScheduleShareStatus.NOT_SHARED,
      sharedWith: [],
      sharedBy: null,
      sharedAt: null,
    );
  }

  // 일정 공유 (강화된 버전)
  static Schedule shareSchedule(Schedule schedule, List<String> users, {String? message}) {
    return schedule.copyWith(
      shareStatus: ScheduleShareStatus.SHARED,
      sharedWith: users,
      sharedAt: DateTime.now(),
    );
  }

  // 일정 공유 해제
  static Schedule unshareSchedule(Schedule schedule) {
    return schedule.copyWith(
      shareStatus: ScheduleShareStatus.NOT_SHARED,
      sharedWith: [],
      sharedBy: null,
      sharedAt: null,
    );
  }

  // 공유받은 일정으로 표시
  static Schedule receiveSchedule(Schedule schedule, String sharedBy) {
    return schedule.copyWith(
      shareStatus: ScheduleShareStatus.RECEIVED,
      sharedBy: sharedBy,
      sharedAt: DateTime.now(),
    );
  }

  // 개인 일정만 필터링
  static List<Schedule> getPersonalSchedules(List<Schedule> schedules) {
    return schedules.where((schedule) => schedule.isPersonal).toList();
  }

  // 팀 일정만 필터링
  static List<Schedule> getTeamSchedules(List<Schedule> schedules) {
    return schedules.where((schedule) => schedule.isTeam).toList();
  }

  // 공유된 일정만 필터링 (강화된 버전)
  static List<Schedule> getSharedSchedules(List<Schedule> schedules, {String? sharedBy}) {
    if (sharedBy != null) {
      return schedules.where((s) => s.isShared && s.sharedBy == sharedBy).toList();
    }
    return schedules.where((schedule) => schedule.isShared || schedule.isReceived).toList();
  }

  // 공유받은 일정만 필터링
  static List<Schedule> getReceivedSchedules(List<Schedule> schedules) {
    return schedules.where((schedule) => schedule.isReceived).toList();
  }

  // 공유 가능한 일정만 필터링
  static List<Schedule> getShareableSchedules(List<Schedule> schedules) {
    return schedules.where((schedule) => schedule.canShare).toList();
  }

  // 공유 해제 가능한 일정만 필터링
  static List<Schedule> getUnshareableSchedules(List<Schedule> schedules) {
    return schedules.where((schedule) => schedule.canUnshare).toList();
  }

  // 특정 사용자와 공유된 일정 필터링
  static List<Schedule> getSchedulesSharedWith(List<Schedule> schedules, String userId) {
    return schedules.where((schedule) => 
      schedule.sharedWith.contains(userId) || schedule.sharedBy == userId
    ).toList();
  }

  // 일정 통계 정보 생성
  static Map<String, dynamic> getScheduleStats(List<Schedule> schedules) {
    final personal = getPersonalSchedules(schedules);
    final team = getTeamSchedules(schedules);
    final shared = getSharedSchedules(schedules);
    final received = getReceivedSchedules(schedules);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return {
      'total': schedules.length,
      'today': schedules.where((s) => s.date.isAtSameMomentAs(today)).length,
      'upcoming': schedules.where((s) => s.date.isAfter(now)).length,
      'personal': personal.length,
      'team': team.length,
      'shared': shared.length,
      'received': received.length,
      'personalCompletion': personal.where((s) => s.status == 'done').length,
      'teamCompletion': team.where((s) => s.status == 'done').length,
    };
  }

  // 일정 그룹별 분류
  static Map<String, List<Schedule>> groupSchedulesByType(List<Schedule> schedules) {
    return {
      'personal': getPersonalSchedules(schedules),
      'team': getTeamSchedules(schedules),
      'shared': getSharedSchedules(schedules),
      'received': getReceivedSchedules(schedules),
    };
  }

  // 일정 상태별 분류 (강화된 버전)
  static Map<String, List<Schedule>> groupSchedulesByStatus(List<Schedule> schedules) {
    final grouped = <String, List<Schedule>>{};
    for (final schedule in schedules) {
      grouped.putIfAbsent(schedule.status, () => []).add(schedule);
    }
    return grouped;
  }

  // 일정 카테고리별 분류
  static Map<String, List<Schedule>> groupSchedulesByCategory(List<Schedule> schedules) {
    final categories = schedules.map((s) => s.category).toSet();
    final result = <String, List<Schedule>>{};
    
    for (final category in categories) {
      result[category] = schedules.where((s) => s.category == category).toList();
    }
    
    return result;
  }

  // 일정 검색 (강화된 버전)
  static List<Schedule> searchSchedules(List<Schedule> schedules, String query) {
    if (query.isEmpty) return schedules;
    
    final lowercaseQuery = query.toLowerCase();
    return schedules.where((schedule) {
      final searchText = [
        schedule.title,
        schedule.patientName,
        schedule.location,
        schedule.planMethod ?? '',
        schedule.planProtocol ?? '',
        schedule.planGoal ?? '',
        schedule.therapistName ?? '',
      ].join(' ').toLowerCase();
      
      return searchText.contains(lowercaseQuery);
    }).toList();
  }

  // 일정 정렬 (날짜, 중요도, 상태별)
  static List<Schedule> sortSchedules(List<Schedule> schedules, {String? sortBy}) {
    final sorted = List<Schedule>.from(schedules);
    
    switch (sortBy) {
      case 'date':
        sorted.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'date_desc':
        sorted.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'importance':
        final importanceOrder = {'매우중요': 3, '중요': 2, '보통': 1};
        sorted.sort((a, b) => 
          (importanceOrder[b.importance] ?? 0).compareTo(importanceOrder[a.importance] ?? 0));
        break;
      case 'status':
        final statusOrder = {'waiting': 1, 'in_progress': 2, 'done': 3};
        sorted.sort((a, b) => 
          (statusOrder[a.status] ?? 0).compareTo(statusOrder[b.status] ?? 0));
        break;
      default:
        sorted.sort((a, b) => a.date.compareTo(b.date));
    }
    
    return sorted;
  }

  // 일정 필터링 (복합 조건)
  static List<Schedule> filterSchedules(List<Schedule> schedules, {
    ScheduleType? type,
    ScheduleShareStatus? shareStatus,
    String? status,
    String? category,
    String? importance,
    DateTime? startDate,
    DateTime? endDate,
    int? planId,
    bool? isPlanRelated,
  }) {
    return schedules.where((schedule) {
      if (type != null && schedule.type != type) return false;
      if (shareStatus != null && schedule.shareStatus != shareStatus) return false;
      if (status != null && schedule.status != status) return false;
      if (category != null && schedule.category != category) return false;
      if (importance != null && schedule.importance != importance) return false;
      if (startDate != null && schedule.date.isBefore(startDate)) return false;
      if (endDate != null && schedule.date.isAfter(endDate)) return false;
      if (planId != null && schedule.planId != planId) return false;
      if (isPlanRelated != null && schedule.isPlanRelated != isPlanRelated) return false;
      return true;
    }).toList();
  }

  // 일정-계획 연동 메서드들
  static Schedule linkToPlan(Schedule schedule, Plan plan) {
    return schedule.copyWith(
      planId: plan.id,
      planMethod: plan.method,
      planProtocol: plan.protocol,
      planGoal: plan.goal,
      therapistName: plan.therapistName,
      isPlanRelated: true,
    );
  }

  static Schedule unlinkFromPlan(Schedule schedule) {
    return schedule.copyWith(
      planId: null,
      planMethod: null,
      planProtocol: null,
      planGoal: null,
      therapistName: null,
      isPlanRelated: false,
    );
  }

  static List<Schedule> getSchedulesForPlan(List<Schedule> schedules, int planId) {
    return schedules.where((s) => s.planId == planId).toList();
  }

  static List<Schedule> getPlanRelatedSchedules(List<Schedule> schedules) {
    return schedules.where((s) => s.isPlanRelated).toList();
  }

  static List<Schedule> getUnlinkedSchedules(List<Schedule> schedules) {
    return schedules.where((s) => !s.isPlanRelated).toList();
  }

  // 계획별 일정 통계
  static Map<String, dynamic> getPlanScheduleStats(List<Schedule> schedules, int planId) {
    final planSchedules = getSchedulesForPlan(schedules, planId);
    final now = DateTime.now();
    
    return {
      'total': planSchedules.length,
      'completed': planSchedules.where((s) => s.status == 'done').length,
      'inProgress': planSchedules.where((s) => s.status == 'in_progress').length,
      'waiting': planSchedules.where((s) => s.status == 'waiting').length,
      'upcoming': planSchedules.where((s) => s.date.isAfter(now)).length,
      'overdue': planSchedules.where((s) => s.date.isBefore(now) && s.status != 'done').length,
    };
  }

  // 계획과 함께 공유하는 통합 공유 메서드
  static Map<String, dynamic> shareScheduleWithPlan(
    Schedule schedule, 
    Plan? plan, 
    List<String> users, 
    {String? message}
  ) {
    final sharedSchedule = shareSchedule(schedule, users, message: message);
    
    return {
      'schedule': sharedSchedule,
      'plan': plan,
      'sharedWith': users,
      'sharedAt': DateTime.now(),
      'message': message,
    };
  }

  // 팀 일정을 개인 일정으로 변환
  static Schedule convertToPersonal(Schedule teamSchedule) {
    return teamSchedule.copyWith(
      type: ScheduleType.PERSONAL,
      originalScheduleId: teamSchedule.id.toString(),
    );
  }

  // 개인 일정을 팀 일정으로 변환
  static Schedule convertToTeam(Schedule personalSchedule) {
    return personalSchedule.copyWith(
      type: ScheduleType.TEAM,
      originalScheduleId: personalSchedule.id.toString(),
    );
  }

  // 일정 그룹화 (날짜별, 계획별)
  static Map<String, List<Schedule>> groupSchedulesByDate(List<Schedule> schedules) {
    final grouped = <String, List<Schedule>>{};
    for (final schedule in schedules) {
      final key = '${schedule.date.year}-${schedule.date.month.toString().padLeft(2, '0')}-${schedule.date.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(schedule);
    }
    return grouped;
  }

  static Map<int, List<Schedule>> groupSchedulesByPlan(List<Schedule> schedules) {
    final grouped = <int, List<Schedule>>{};
    for (final schedule in schedules) {
      if (schedule.planId != null) {
        grouped.putIfAbsent(schedule.planId!, () => []).add(schedule);
      }
    }
    return grouped;
  }

  // 공유 통계
  static Map<String, dynamic> getShareStats(List<Schedule> schedules) {
    return {
      'totalShared': schedules.where((s) => s.isShared).length,
      'totalReceived': schedules.where((s) => s.isReceived).length,
      'sharedByMe': schedules.where((s) => s.isShared && s.sharedBy == null).length,
      'receivedFromOthers': schedules.where((s) => s.isReceived).length,
      'personalShared': schedules.where((s) => s.isPersonal && s.isShared).length,
      'teamShared': schedules.where((s) => s.isTeam && s.isShared).length,
    };
  }
} 