import 'package:flutter/foundation.dart';

enum PlanShareStatus {
  NOT_SHARED,
  SHARED,
  PENDING,
  ACCEPTED,
  REJECTED
}

enum PlanTemplateType {
  SHOULDER_REHAB,
  KNEE_REHAB,
  STROKE_RECOVERY,
  CUSTOM
}

class Plan {
  final int id;
  final String patient;
  final String method;
  final String protocol;
  final String goal;
  final String indicators;
  final String detail;
  final List<String> tags;

  final String status;
  final String due;
  final bool isArchived;
  final bool isTrashed;
  final DateTime? deletedAt;
  final List<int>? scheduleIds;
  final String? treatmentLocation;
  final String? treatmentTime;
  final String? therapistName;
  final bool hasSchedules;
  final bool isOwned;
  final String? sharedBy;
  final PlanShareStatus shareStatus;
  final List<String>? sharedWith;
  final int? templateId;
  final PlanTemplateType? templateType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Plan({
    required this.id,
    required this.patient,
    required this.method,
    required this.protocol,
    required this.goal,
    required this.indicators,
    required this.detail,
    required this.tags,

    required this.status,
    required this.due,
    this.isArchived = false,
    this.isTrashed = false,
    this.deletedAt,
    this.scheduleIds,
    this.treatmentLocation,
    this.treatmentTime,
    this.therapistName,
    this.hasSchedules = false,
    this.isOwned = true,
    this.sharedBy,
    this.shareStatus = PlanShareStatus.NOT_SHARED,
    this.sharedWith,
    this.templateId,
    this.templateType,
    this.createdAt,
    this.updatedAt,
  });

  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      id: map['id'] as int,
      patient: map['patient'] as String,
      method: map['method'] as String,
      protocol: map['protocol'] as String,
      goal: map['goal'] as String,
      indicators: map['indicators'] as String,
      detail: map['detail'] as String,
      tags: List<String>.from(map['tags'] ?? []),

      status: map['status'] as String,
      due: map['due'] as String,
      isArchived: map['isArchived'] as bool? ?? false,
      isTrashed: map['isTrashed'] as bool? ?? false,
      deletedAt: map['deletedAt'] != null ? DateTime.tryParse(map['deletedAt']) : null,
      scheduleIds: map['scheduleIds'] != null ? List<int>.from(map['scheduleIds']) : null,
      treatmentLocation: map['treatmentLocation'] as String?,
      treatmentTime: map['treatmentTime'] as String?,
      therapistName: map['therapistName'] as String?,
      hasSchedules: map['hasSchedules'] as bool? ?? false,
      isOwned: map['isOwned'] as bool? ?? true,
      sharedBy: map['sharedBy'] as String?,
      shareStatus: PlanShareStatus.values.firstWhere(
        (e) => e.toString() == 'PlanShareStatus.${map['shareStatus'] ?? 'NOT_SHARED'}',
        orElse: () => PlanShareStatus.NOT_SHARED,
      ),
      sharedWith: map['sharedWith'] != null ? List<String>.from(map['sharedWith']) : null,
      templateId: map['templateId'] as int?,
      templateType: map['templateType'] != null 
          ? PlanTemplateType.values.firstWhere(
              (e) => e.toString() == 'PlanTemplateType.${map['templateType']}',
              orElse: () => PlanTemplateType.CUSTOM,
            )
          : null,
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient': patient,
      'method': method,
      'protocol': protocol,
      'goal': goal,
      'indicators': indicators,
      'detail': detail,
      'tags': tags,

      'status': status,
      'due': due,
      'isArchived': isArchived,
      'isTrashed': isTrashed,
      'deletedAt': deletedAt?.toIso8601String(),
      'scheduleIds': scheduleIds,
      'treatmentLocation': treatmentLocation,
      'treatmentTime': treatmentTime,
      'therapistName': therapistName,
      'hasSchedules': hasSchedules,
      'isOwned': isOwned,
      'sharedBy': sharedBy,
      'shareStatus': shareStatus.toString().split('.').last,
      'sharedWith': sharedWith,
      'templateId': templateId,
      'templateType': templateType?.toString().split('.').last,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Plan copyWith({
    int? id,
    String? patient,
    String? method,
    String? protocol,
    String? goal,
    String? indicators,
    String? detail,
    List<String>? tags,

    String? status,
    String? due,
    bool? isArchived,
    bool? isTrashed,
    DateTime? deletedAt,
    List<int>? scheduleIds,
    String? treatmentLocation,
    String? treatmentTime,
    String? therapistName,
    bool? hasSchedules,
    bool? isOwned,
    String? sharedBy,
    PlanShareStatus? shareStatus,
    List<String>? sharedWith,
    int? templateId,
    PlanTemplateType? templateType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Plan(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      method: method ?? this.method,
      protocol: protocol ?? this.protocol,
      goal: goal ?? this.goal,
      indicators: indicators ?? this.indicators,
      detail: detail ?? this.detail,
      tags: tags ?? this.tags,

      status: status ?? this.status,
      due: due ?? this.due,
      isArchived: isArchived ?? this.isArchived,
      isTrashed: isTrashed ?? this.isTrashed,
      deletedAt: deletedAt ?? this.deletedAt,
      scheduleIds: scheduleIds ?? this.scheduleIds,
      treatmentLocation: treatmentLocation ?? this.treatmentLocation,
      treatmentTime: treatmentTime ?? this.treatmentTime,
      therapistName: therapistName ?? this.therapistName,
      hasSchedules: hasSchedules ?? this.hasSchedules,
      isOwned: isOwned ?? this.isOwned,
      sharedBy: sharedBy ?? this.sharedBy,
      shareStatus: shareStatus ?? this.shareStatus,
      sharedWith: sharedWith ?? this.sharedWith,
      templateId: templateId ?? this.templateId,
      templateType: templateType ?? this.templateType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 