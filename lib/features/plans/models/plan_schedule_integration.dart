import 'package:flutter/foundation.dart';
import 'plan.dart';
import '../../schedules/models/schedule.dart';

class PlanScheduleIntegration {
  final Plan plan;
  final List<Schedule> schedules;
  final Map<String, dynamic> stats;
  final List<Schedule> upcomingSchedules;
  final List<Schedule> completedSchedules;
  final List<Schedule> overdueSchedules;
  final bool hasConflicts;
  final List<ScheduleConflict> conflicts;
  final double completionRate;
  final int totalSchedules;
  final int completedCount;
  final int inProgressCount;
  final int waitingCount;

  PlanScheduleIntegration({
    required this.plan,
    required this.schedules,
    required this.stats,
    required this.upcomingSchedules,
    required this.completedSchedules,
    required this.overdueSchedules,
    required this.hasConflicts,
    required this.conflicts,
    required this.completionRate,
    required this.totalSchedules,
    required this.completedCount,
    required this.inProgressCount,
    required this.waitingCount,
  });

  factory PlanScheduleIntegration.fromPlanAndSchedules(Plan plan, List<Schedule> allSchedules) {
    final planSchedules = allSchedules.where((s) => s.planId == plan.id).toList();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 일정 분류
    final upcomingSchedules = planSchedules.where((s) => s.date.isAfter(today)).toList();
    final completedSchedules = planSchedules.where((s) => s.status == 'done').toList();
    final overdueSchedules = planSchedules.where((s) => 
      s.date.isBefore(today) && s.status != 'done'
    ).toList();

    // 통계 계산
    final totalSchedules = planSchedules.length;
    final completedCount = completedSchedules.length;
    final inProgressCount = planSchedules.where((s) => s.status == 'in_progress').length;
    final waitingCount = planSchedules.where((s) => s.status == 'waiting').length;
    final completionRate = totalSchedules > 0 ? (completedCount / totalSchedules) * 100 : 0.0;

    // 충돌 검사
    final conflicts = _detectConflicts(planSchedules);
    final hasConflicts = conflicts.isNotEmpty;

    // 통합 통계
    final stats = {
      'totalSchedules': totalSchedules,
      'completed': completedCount,
      'inProgress': inProgressCount,
      'waiting': waitingCount,
      'overdue': overdueSchedules.length,
      'upcoming': upcomingSchedules.length,
      'completionRate': completionRate,
      'hasConflicts': hasConflicts,
      'conflictCount': conflicts.length,
      'averageDuration': _calculateAverageDuration(planSchedules),
      'efficiency': _calculateEfficiency(planSchedules),
      'patientSatisfaction': _calculatePatientSatisfaction(planSchedules),
    };

    return PlanScheduleIntegration(
      plan: plan,
      schedules: planSchedules,
      stats: stats,
      upcomingSchedules: upcomingSchedules,
      completedSchedules: completedSchedules,
      overdueSchedules: overdueSchedules,
      hasConflicts: hasConflicts,
      conflicts: conflicts,
      completionRate: completionRate,
      totalSchedules: totalSchedules,
      completedCount: completedCount,
      inProgressCount: inProgressCount,
      waitingCount: waitingCount,
    );
  }

  // 충돌 검사 로직
  static List<ScheduleConflict> _detectConflicts(List<Schedule> schedules) {
    final conflicts = <ScheduleConflict>[];
    final sortedSchedules = List<Schedule>.from(schedules)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (int i = 0; i < sortedSchedules.length - 1; i++) {
      final current = sortedSchedules[i];
      final next = sortedSchedules[i + 1];

      // 시간 충돌 검사
      if (current.date.isAtSameMomentAs(next.date)) {
        final currentTime = _parseTime(current.time);
        final nextTime = _parseTime(next.time);
        
        if (_hasTimeOverlap(currentTime, nextTime)) {
          conflicts.add(ScheduleConflict(
            type: ConflictType.TIME_OVERLAP,
            schedule1: current,
            schedule2: next,
            description: '시간이 겹치는 일정이 있습니다.',
            severity: ConflictSeverity.HIGH,
          ));
        }
      }

      // 리소스 충돌 검사 (같은 치료사, 같은 장소)
      if (current.therapistName == next.therapistName && 
          current.date.isAtSameMomentAs(next.date)) {
        conflicts.add(ScheduleConflict(
          type: ConflictType.RESOURCE_CONFLICT,
          schedule1: current,
          schedule2: next,
          description: '같은 치료사가 동시에 다른 일정을 가집니다.',
          severity: ConflictSeverity.MEDIUM,
        ));
      }

      // 장소 충돌 검사
      if (current.location == next.location && 
          current.date.isAtSameMomentAs(next.date)) {
        conflicts.add(ScheduleConflict(
          type: ConflictType.LOCATION_CONFLICT,
          schedule1: current,
          schedule2: next,
          description: '같은 장소에서 동시에 다른 일정이 있습니다.',
          severity: ConflictSeverity.MEDIUM,
        ));
      }
    }

    return conflicts;
  }

  // 시간 파싱
  static Map<String, int> _parseTime(String time) {
    // "오전 9:00~10:00" 형식 파싱
    final parts = time.split('~');
    final startTime = parts[0].trim();
    final endTime = parts[1].trim();
    
    final startHour = int.parse(startTime.split(':')[0].replaceAll('오전', '').replaceAll('오후', '').trim());
    final startMinute = int.parse(startTime.split(':')[1]);
    final endHour = int.parse(endTime.split(':')[0].replaceAll('오전', '').replaceAll('오후', '').trim());
    final endMinute = int.parse(endTime.split(':')[1]);
    
    return {
      'startHour': startHour,
      'startMinute': startMinute,
      'endHour': endHour,
      'endMinute': endMinute,
    };
  }

  // 시간 겹침 검사
  static bool _hasTimeOverlap(Map<String, int> time1, Map<String, int> time2) {
    final start1 = time1['startHour']! * 60 + time1['startMinute']!;
    final end1 = time1['endHour']! * 60 + time1['endMinute']!;
    final start2 = time2['startHour']! * 60 + time2['startMinute']!;
    final end2 = time2['endHour']! * 60 + time2['endMinute']!;
    
    return start1 < end2 && start2 < end1;
  }

  // 평균 소요 시간 계산
  static double _calculateAverageDuration(List<Schedule> schedules) {
    if (schedules.isEmpty) return 0.0;
    
    double totalMinutes = 0;
    for (final schedule in schedules) {
      final time = _parseTime(schedule.time);
      final duration = (time['endHour']! * 60 + time['endMinute']!) - 
                      (time['startHour']! * 60 + time['startMinute']!);
      totalMinutes += duration;
    }
    
    return totalMinutes / schedules.length;
  }

  // 효율성 계산
  static double _calculateEfficiency(List<Schedule> schedules) {
    if (schedules.isEmpty) return 0.0;
    
    final completed = schedules.where((s) => s.status == 'done').length;
    final total = schedules.length;
    final onTime = schedules.where((s) => 
      s.status == 'done' && s.date.isBefore(DateTime.now())
    ).length;
    
    final completionRate = total > 0 ? completed / total : 0.0;
    final onTimeRate = completed > 0 ? onTime / completed : 0.0;
    
    return (completionRate * 0.6 + onTimeRate * 0.4) * 100;
  }

  // 환자 만족도 계산
  static double _calculatePatientSatisfaction(List<Schedule> schedules) {
    if (schedules.isEmpty) return 0.0;
    
    double satisfaction = 100.0;
    
    // 지연된 일정에 대한 페널티
    final overdue = schedules.where((s) => 
      s.date.isBefore(DateTime.now()) && s.status != 'done'
    ).length;
    satisfaction -= overdue * 10;
    
    // 취소된 일정에 대한 페널티
    final cancelled = schedules.where((s) => s.status == 'cancelled').length;
    satisfaction -= cancelled * 15;
    
    // 완료된 일정에 대한 보너스
    final completed = schedules.where((s) => s.status == 'done').length;
    satisfaction += completed * 2;
    
    return satisfaction.clamp(0.0, 100.0);
  }

  // 통합 상태 평가
  String get integrationStatus {
    if (completionRate >= 90 && !hasConflicts) return '우수';
    if (completionRate >= 70 && conflicts.length <= 2) return '양호';
    if (completionRate >= 50) return '보통';
    return '개선필요';
  }

  // 우선순위 계산
  int get priority {
    int priority = 0;
    
    // 지연된 일정이 많을수록 높은 우선순위
    priority += overdueSchedules.length * 10;
    
    // 충돌이 많을수록 높은 우선순위
    priority += conflicts.length * 5;
    
    // 완료율이 낮을수록 높은 우선순위
    priority += (100 - completionRate).round();
    
    // 마감일이 가까울수록 높은 우선순위
    final dueDate = DateTime.tryParse(plan.due);
    if (dueDate != null) {
      final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
      if (daysUntilDue <= 7) priority += 20;
      else if (daysUntilDue <= 14) priority += 10;
    }
    
    return priority;
  }

  // 다음 액션 추천
  List<String> get recommendedActions {
    final actions = <String>[];
    
    if (overdueSchedules.isNotEmpty) {
      actions.add('지연된 일정 ${overdueSchedules.length}개 처리 필요');
    }
    
    if (conflicts.isNotEmpty) {
      actions.add('일정 충돌 ${conflicts.length}개 해결 필요');
    }
    
    if (completionRate < 70) {
      actions.add('완료율 향상을 위한 일정 조정 필요');
    }
    
    if (upcomingSchedules.isEmpty) {
      actions.add('향후 일정 추가 필요');
    }
    
    return actions;
  }
}

enum ConflictType { TIME_OVERLAP, RESOURCE_CONFLICT, LOCATION_CONFLICT }
enum ConflictSeverity { LOW, MEDIUM, HIGH }

class ScheduleConflict {
  final ConflictType type;
  final Schedule schedule1;
  final Schedule schedule2;
  final String description;
  final ConflictSeverity severity;

  ScheduleConflict({
    required this.type,
    required this.schedule1,
    required this.schedule2,
    required this.description,
    required this.severity,
  });

  String get resolution {
    switch (type) {
      case ConflictType.TIME_OVERLAP:
        return '일정 시간 조정 필요';
      case ConflictType.RESOURCE_CONFLICT:
        return '치료사 배정 조정 필요';
      case ConflictType.LOCATION_CONFLICT:
        return '장소 배정 조정 필요';
    }
  }
}

class PlanScheduleSummary {
  final int planId;
  final String planTitle;
  final String patientName;
  final String status;
  final DateTime? nextScheduleDate;
  final int totalSchedules;
  final int completedSchedules;
  final double completionRate;
  final String? nextScheduleTime;
  final String? nextScheduleLocation;

  const PlanScheduleSummary({
    required this.planId,
    required this.planTitle,
    required this.patientName,
    required this.status,
    this.nextScheduleDate,
    required this.totalSchedules,
    required this.completedSchedules,
    required this.completionRate,
    this.nextScheduleTime,
    this.nextScheduleLocation,
  });

  factory PlanScheduleSummary.fromIntegration(PlanScheduleIntegration integration) {
    final nextSchedule = integration.schedules
        .where((s) => s.status == 'waiting' || s.status == 'in_progress')
        .where((s) => s.date.isAfter(DateTime.now()))
        .fold<Schedule?>(null, (prev, curr) => 
            prev == null || curr.date.isBefore(prev.date) ? curr : prev);

    return PlanScheduleSummary(
      planId: integration.plan.id,
      planTitle: integration.plan.method,
      patientName: integration.plan.patient,
      status: integration.plan.status,
      nextScheduleDate: nextSchedule?.date,
      totalSchedules: integration.totalSchedules,
      completedSchedules: integration.completedCount,
      completionRate: integration.completionRate,
      nextScheduleTime: nextSchedule?.time,
      nextScheduleLocation: nextSchedule?.location,
    );
  }
}

// 통합 데이터 서비스 클래스
class PlanScheduleIntegrationService {
  static List<PlanScheduleIntegration> createIntegrations(List<Plan> plans, List<Schedule> schedules) {
    return plans.map((plan) => PlanScheduleIntegration.fromPlanAndSchedules(plan, schedules)).toList();
  }

  static List<PlanScheduleSummary> createSummaries(List<PlanScheduleIntegration> integrations) {
    return integrations.map((integration) => PlanScheduleSummary.fromIntegration(integration)).toList();
  }

  static List<Schedule> getSchedulesForPlan(int planId, List<Schedule> allSchedules) {
    return allSchedules.where((schedule) => schedule.planId == planId).toList();
  }

  static List<Plan> getPlansWithSchedules(List<Plan> plans) {
    return plans.where((plan) => plan.hasSchedules).toList();
  }

  static List<Schedule> getPlanRelatedSchedules(List<Schedule> schedules) {
    return schedules.where((schedule) => schedule.isPlanRelated).toList();
  }

  static Map<String, dynamic> getPlanScheduleStats(Plan plan, List<Schedule> schedules) {
    final planSchedules = getSchedulesForPlan(plan.id, schedules);
    final completed = planSchedules.where((s) => s.status == 'done').length;
    final total = planSchedules.length;
    final rate = total > 0 ? (completed / total) * 100 : 0.0;

    return {
      'totalSchedules': total,
      'completedSchedules': completed,
      'pendingSchedules': planSchedules.where((s) => s.status == 'waiting').length,
      'completionRate': rate,
      'hasSchedules': total > 0,
    };
  }

  static void updatePlanWithScheduleInfo(Plan plan, List<Schedule> schedules) {
    final stats = getPlanScheduleStats(plan, schedules);
    final scheduleIds = schedules
        .where((s) => s.planId == plan.id)
        .map((s) => s.id)
        .toList();

    plan.copyWith(
      hasSchedules: stats['hasSchedules'],
      scheduleIds: scheduleIds,
    );
  }

  static List<Map<String, dynamic>> convertPlansToMap(List<Plan> plans) {
    return plans.map((plan) => plan.toMap()).toList();
  }

  static List<Plan> convertMapToPlans(List<Map<String, dynamic>> planMaps) {
    return planMaps.map((map) => Plan.fromMap(map)).toList();
  }

  static List<Map<String, dynamic>> convertSchedulesToMap(List<Schedule> schedules) {
    return schedules.map((schedule) => schedule.toMap()).toList();
  }

  static List<Schedule> convertMapToSchedules(List<Map<String, dynamic>> scheduleMaps) {
    return scheduleMaps.map((map) => Schedule.fromMap(map)).toList();
  }
} 