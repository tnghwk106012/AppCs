import 'package:flutter/foundation.dart';

enum ScheduleType { PERSONAL, TEAM }
enum ScheduleShareStatus { NOT_SHARED, SHARED, RECEIVED }
enum RepeatType { NONE, DAILY, WEEKLY, MONTHLY, CUSTOM }
enum ConflictStatus { NONE, WARNING, CONFLICT }

class Schedule {
  final int id;
  final String title;
  final String time;
  final String location;
  final String patientName;
  final String status;
  final String category;
  final String importance;
  final bool repeat;
  final DateTime date;
  // 계획 연동 관련 필드
  final int? planId;
  final String? planMethod;
  final String? planProtocol;
  final String? planGoal;
  final String? therapistName;
  final bool isPlanRelated;
  // 개인/팀 일정 구분 및 공유 관련 필드
  final ScheduleType type;
  final ScheduleShareStatus shareStatus;
  final List<String> sharedWith; // 공유된 사용자 목록
  final String? sharedBy; // 공유한 사용자
  final DateTime? sharedAt; // 공유된 시간
  final String? originalScheduleId; // 팀 일정에서 변환된 경우 원본 ID
  // 반복 일정 관련 필드
  final RepeatType repeatType;
  final int? repeatInterval; // 반복 간격 (일/주/월)
  final DateTime? repeatUntil; // 반복 종료일
  final List<int>? repeatDays; // 주간 반복 시 요일 (1=월요일, 7=일요일)
  final String? repeatTime; // 반복 시간
  // 충돌 확인 관련 필드
  final ConflictStatus conflictStatus;
  final List<String>? conflictingSchedules; // 충돌하는 일정 ID 목록
  final String? conflictMessage; // 충돌 메시지
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Schedule({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.patientName,
    required this.status,
    required this.category,
    required this.importance,
    required this.repeat,
    required this.date,
    this.planId,
    this.planMethod,
    this.planProtocol,
    this.planGoal,
    this.therapistName,
    this.isPlanRelated = false,
    this.type = ScheduleType.PERSONAL,
    this.shareStatus = ScheduleShareStatus.NOT_SHARED,
    this.sharedWith = const [],
    this.sharedBy,
    this.sharedAt,
    this.originalScheduleId,
    this.repeatType = RepeatType.NONE,
    this.repeatInterval,
    this.repeatUntil,
    this.repeatDays,
    this.repeatTime,
    this.conflictStatus = ConflictStatus.NONE,
    this.conflictingSchedules,
    this.conflictMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'] as int,
      title: map['title'] as String,
      time: map['time'] as String,
      location: map['location'] as String,
      patientName: map['patientName'] as String,
      status: map['status'] as String,
      category: map['category'] as String,
      importance: map['importance'] as String,
      repeat: map['repeat'] as bool,
      date: DateTime.parse(map['date'] as String),
      planId: map['planId'] as int?,
      planMethod: map['planMethod'] as String?,
      planProtocol: map['planProtocol'] as String?,
      planGoal: map['planGoal'] as String?,
      therapistName: map['therapistName'] as String?,
      isPlanRelated: map['isPlanRelated'] as bool? ?? false,
      type: ScheduleType.values.firstWhere(
        (e) => e.toString() == 'ScheduleType.${map['type'] ?? 'PERSONAL'}',
        orElse: () => ScheduleType.PERSONAL,
      ),
      shareStatus: ScheduleShareStatus.values.firstWhere(
        (e) => e.toString() == 'ScheduleShareStatus.${map['shareStatus'] ?? 'NOT_SHARED'}',
        orElse: () => ScheduleShareStatus.NOT_SHARED,
      ),
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      sharedBy: map['sharedBy'] as String?,
      sharedAt: map['sharedAt'] != null ? DateTime.parse(map['sharedAt']) : null,
      originalScheduleId: map['originalScheduleId'] as String?,
      repeatType: RepeatType.values.firstWhere(
        (e) => e.toString() == 'RepeatType.${map['repeatType'] ?? 'NONE'}',
        orElse: () => RepeatType.NONE,
      ),
      repeatInterval: map['repeatInterval'] as int?,
      repeatUntil: map['repeatUntil'] != null ? DateTime.parse(map['repeatUntil']) : null,
      repeatDays: map['repeatDays'] != null ? List<int>.from(map['repeatDays']) : null,
      repeatTime: map['repeatTime'] as String?,
      conflictStatus: ConflictStatus.values.firstWhere(
        (e) => e.toString() == 'ConflictStatus.${map['conflictStatus'] ?? 'NONE'}',
        orElse: () => ConflictStatus.NONE,
      ),
      conflictingSchedules: map['conflictingSchedules'] != null ? List<String>.from(map['conflictingSchedules']) : null,
      conflictMessage: map['conflictMessage'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'location': location,
      'patientName': patientName,
      'status': status,
      'category': category,
      'importance': importance,
      'repeat': repeat,
      'date': date.toIso8601String(),
      'planId': planId,
      'planMethod': planMethod,
      'planProtocol': planProtocol,
      'planGoal': planGoal,
      'therapistName': therapistName,
      'isPlanRelated': isPlanRelated,
      'type': type.toString().split('.').last,
      'shareStatus': shareStatus.toString().split('.').last,
      'sharedWith': sharedWith,
      'sharedBy': sharedBy,
      'sharedAt': sharedAt?.toIso8601String(),
      'originalScheduleId': originalScheduleId,
      'repeatType': repeatType.toString().split('.').last,
      'repeatInterval': repeatInterval,
      'repeatUntil': repeatUntil?.toIso8601String(),
      'repeatDays': repeatDays,
      'repeatTime': repeatTime,
      'conflictStatus': conflictStatus.toString().split('.').last,
      'conflictingSchedules': conflictingSchedules,
      'conflictMessage': conflictMessage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Schedule copyWith({
    int? id,
    String? title,
    String? time,
    String? location,
    String? patientName,
    String? status,
    String? category,
    String? importance,
    bool? repeat,
    DateTime? date,
    int? planId,
    String? planMethod,
    String? planProtocol,
    String? planGoal,
    String? therapistName,
    bool? isPlanRelated,
    ScheduleType? type,
    ScheduleShareStatus? shareStatus,
    List<String>? sharedWith,
    String? sharedBy,
    DateTime? sharedAt,
    String? originalScheduleId,
    RepeatType? repeatType,
    int? repeatInterval,
    DateTime? repeatUntil,
    List<int>? repeatDays,
    String? repeatTime,
    ConflictStatus? conflictStatus,
    List<String>? conflictingSchedules,
    String? conflictMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Schedule(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      location: location ?? this.location,
      patientName: patientName ?? this.patientName,
      status: status ?? this.status,
      category: category ?? this.category,
      importance: importance ?? this.importance,
      repeat: repeat ?? this.repeat,
      date: date ?? this.date,
      planId: planId ?? this.planId,
      planMethod: planMethod ?? this.planMethod,
      planProtocol: planProtocol ?? this.planProtocol,
      planGoal: planGoal ?? this.planGoal,
      therapistName: therapistName ?? this.therapistName,
      isPlanRelated: isPlanRelated ?? this.isPlanRelated,
      type: type ?? this.type,
      shareStatus: shareStatus ?? this.shareStatus,
      sharedWith: sharedWith ?? this.sharedWith,
      sharedBy: sharedBy ?? this.sharedBy,
      sharedAt: sharedAt ?? this.sharedAt,
      originalScheduleId: originalScheduleId ?? this.originalScheduleId,
      repeatType: repeatType ?? this.repeatType,
      repeatInterval: repeatInterval ?? this.repeatInterval,
      repeatUntil: repeatUntil ?? this.repeatUntil,
      repeatDays: repeatDays ?? this.repeatDays,
      repeatTime: repeatTime ?? this.repeatTime,
      conflictStatus: conflictStatus ?? this.conflictStatus,
      conflictingSchedules: conflictingSchedules ?? this.conflictingSchedules,
      conflictMessage: conflictMessage ?? this.conflictMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 개인 일정인지 확인
  bool get isPersonal => type == ScheduleType.PERSONAL;
  
  // 팀 일정인지 확인
  bool get isTeam => type == ScheduleType.TEAM;
  
  // 공유된 일정인지 확인
  bool get isShared => shareStatus == ScheduleShareStatus.SHARED;
  
  // 공유받은 일정인지 확인
  bool get isReceived => shareStatus == ScheduleShareStatus.RECEIVED;
  
  // 공유 가능한지 확인
  bool get canShare => isPersonal && shareStatus == ScheduleShareStatus.NOT_SHARED;
  
  // 공유 해제 가능한지 확인
  bool get canUnshare => isPersonal && shareStatus == ScheduleShareStatus.SHARED;

  // 반복 일정인지 확인
  bool get isRepeating => repeatType != RepeatType.NONE;

  // 충돌이 있는지 확인
  bool get hasConflict => conflictStatus != ConflictStatus.NONE;
} 