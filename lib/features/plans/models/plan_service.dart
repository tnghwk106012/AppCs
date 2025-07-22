import 'plan.dart';
import '../../schedules/models/schedule.dart';

class PlanService {
  // 계획별 일정 조회
  static List<Schedule> getSchedulesForPlan(List<Schedule> schedules, int planId) {
    return schedules.where((s) => s.planId == planId).toList();
  }

  // 계획에 일정 연동
  static Plan linkScheduleToPlan(Plan plan, Schedule schedule) {
    final updatedScheduleIds = List<int>.from(plan.scheduleIds ?? []);
    if (!updatedScheduleIds.contains(schedule.id)) {
      updatedScheduleIds.add(schedule.id);
    }
    
    return plan.copyWith(
      scheduleIds: updatedScheduleIds,
      hasSchedules: true,
    );
  }

  // 계획에서 일정 연동 해제
  static Plan unlinkScheduleFromPlan(Plan plan, int scheduleId) {
    final updatedScheduleIds = List<int>.from(plan.scheduleIds ?? []);
    updatedScheduleIds.remove(scheduleId);
    
    return plan.copyWith(
      scheduleIds: updatedScheduleIds,
      hasSchedules: updatedScheduleIds.isNotEmpty,
    );
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
      'completionRate': planSchedules.isNotEmpty 
          ? (planSchedules.where((s) => s.status == 'done').length / planSchedules.length * 100).round()
          : 0,
    };
  }

  // 계획 필터링
  static List<Plan> filterPlans(List<Plan> plans, {
    String? status,
    String? method,
    bool? hasSchedules,
    bool? isArchived,
  }) {
    return plans.where((plan) {
      if (status != null && plan.status != status) return false;
      if (method != null && plan.method != method) return false;
      if (hasSchedules != null && plan.hasSchedules != hasSchedules) return false;
      if (isArchived != null && plan.isArchived != isArchived) return false;
      return true;
    }).toList();
  }

  // 계획 정렬
  static List<Plan> sortPlans(List<Plan> plans, {String sortBy = 'due'}) {
    final sorted = List<Plan>.from(plans);
    switch (sortBy) {
      case 'due':
        sorted.sort((a, b) => a.due.compareTo(b.due));
        break;
      case 'method':
        sorted.sort((a, b) => a.method.compareTo(b.method));
        break;
      case 'status':
        final statusOrder = {'대기': 1, '진행중': 2, '완료': 3};
        sorted.sort((a, b) => (statusOrder[a.status] ?? 0).compareTo(statusOrder[b.status] ?? 0));
        break;
      case 'patient':
        sorted.sort((a, b) => a.patient.compareTo(b.patient));
        break;
    }
    return sorted;
  }

  // 계획 검색
  static List<Plan> searchPlans(List<Plan> plans, String query) {
    if (query.isEmpty) return plans;
    
    final lowercaseQuery = query.toLowerCase();
    return plans.where((plan) {
      final searchText = [
        plan.patient,
        plan.method,
        plan.protocol,
        plan.goal,
        plan.indicators,
        plan.detail,
        plan.therapistName ?? '',
      ].join(' ').toLowerCase();
      
      return searchText.contains(lowercaseQuery);
    }).toList();
  }

  // 계획 통계
  static Map<String, dynamic> getPlanStats(List<Plan> plans) {
    return {
      'total': plans.length,
      'active': plans.where((p) => !p.isArchived && !p.isTrashed).length,
      'archived': plans.where((p) => p.isArchived).length,
      'trashed': plans.where((p) => p.isTrashed).length,
      'withSchedules': plans.where((p) => p.hasSchedules).length,
      'completed': plans.where((p) => p.status == '완료').length,
      'inProgress': plans.where((p) => p.status == '진행중').length,
      'waiting': plans.where((p) => p.status == '대기').length,
    };
  }

  // 계획 그룹화
  static Map<String, List<Plan>> groupPlansByStatus(List<Plan> plans) {
    final grouped = <String, List<Plan>>{};
    for (final plan in plans) {
      grouped.putIfAbsent(plan.status, () => []).add(plan);
    }
    return grouped;
  }

  static Map<String, List<Plan>> groupPlansByMethod(List<Plan> plans) {
    final grouped = <String, List<Plan>>{};
    for (final plan in plans) {
      grouped.putIfAbsent(plan.method, () => []).add(plan);
    }
    return grouped;
  }

  // 계획 아카이브/복원
  static Plan archivePlan(Plan plan) {
    return plan.copyWith(isArchived: true);
  }

  static Plan unarchivePlan(Plan plan) {
    return plan.copyWith(isArchived: false);
  }

  // 계획 휴지통 이동/복원
  static Plan trashPlan(Plan plan) {
    return plan.copyWith(
      isTrashed: true,
      deletedAt: DateTime.now(),
    );
  }

  static Plan restorePlan(Plan plan) {
    return plan.copyWith(
      isTrashed: false,
      deletedAt: null,
    );
  }
} 