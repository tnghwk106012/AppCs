import 'plan.dart';

enum PlanShareStatus { PENDING, ACCEPTED, REJECTED, EXPIRED }
enum PlanShareType { TEAM_WIDE, USER_SPECIFIC, DATE_RANGE }

class PlanShare {
  final int id;
  final Plan plan;
  final String sharedBy;
  final List<String> sharedWith;
  final PlanShareStatus status;
  final PlanShareType type;
  final DateTime sharedAt;
  final DateTime? expiresAt;
  final String? message;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final String? acceptedBy;
  final String? rejectedBy;
  final DateTime? startDate;
  final DateTime? endDate;

  PlanShare({
    required this.id,
    required this.plan,
    required this.sharedBy,
    required this.sharedWith,
    required this.status,
    required this.type,
    required this.sharedAt,
    this.expiresAt,
    this.message,
    this.acceptedAt,
    this.rejectedAt,
    this.acceptedBy,
    this.rejectedBy,
    this.startDate,
    this.endDate,
  });

  factory PlanShare.fromMap(Map<String, dynamic> map) {
    return PlanShare(
      id: map['id'] as int,
      plan: Plan.fromMap(map['plan'] as Map<String, dynamic>),
      sharedBy: map['sharedBy'] as String,
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      status: PlanShareStatus.values.firstWhere(
        (e) => e.toString() == 'PlanShareStatus.${map['status'] ?? 'PENDING'}',
        orElse: () => PlanShareStatus.PENDING,
      ),
      type: PlanShareType.values.firstWhere(
        (e) => e.toString() == 'PlanShareType.${map['type'] ?? 'TEAM_WIDE'}',
        orElse: () => PlanShareType.TEAM_WIDE,
      ),
      sharedAt: DateTime.parse(map['sharedAt'] as String),
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      message: map['message'] as String?,
      acceptedAt: map['acceptedAt'] != null ? DateTime.parse(map['acceptedAt']) : null,
      rejectedAt: map['rejectedAt'] != null ? DateTime.parse(map['rejectedAt']) : null,
      acceptedBy: map['acceptedBy'] as String?,
      rejectedBy: map['rejectedBy'] as String?,
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plan': plan.toMap(),
      'sharedBy': sharedBy,
      'sharedWith': sharedWith,
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'sharedAt': sharedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'message': message,
      'acceptedAt': acceptedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'acceptedBy': acceptedBy,
      'rejectedBy': rejectedBy,
      'isDateRangeSpecific': isDateRangeSpecific,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  PlanShare copyWith({
    int? id,
    Plan? plan,
    String? sharedBy,
    List<String>? sharedWith,
    PlanShareStatus? status,
    PlanShareType? type,
    DateTime? sharedAt,
    DateTime? expiresAt,
    String? message,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    String? acceptedBy,
    String? rejectedBy,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return PlanShare(
      id: id ?? this.id,
      plan: plan ?? this.plan,
      sharedBy: sharedBy ?? this.sharedBy,
      sharedWith: sharedWith ?? this.sharedWith,
      status: status ?? this.status,
      type: type ?? this.type,
      sharedAt: sharedAt ?? this.sharedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      message: message ?? this.message,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      rejectedBy: rejectedBy ?? this.rejectedBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  bool get isPending => status == PlanShareStatus.PENDING;
  bool get isAccepted => status == PlanShareStatus.ACCEPTED;
  bool get isRejected => status == PlanShareStatus.REJECTED;
  bool get isExpired => status == PlanShareStatus.EXPIRED;
  bool get isTeamWide => type == PlanShareType.TEAM_WIDE;
  bool get isUserSpecific => type == PlanShareType.USER_SPECIFIC;
  bool get isDateRangeSpecific => type == PlanShareType.DATE_RANGE;
}

class PlanShareService {
  // 팀 전체에 계획 배포 (날짜 중복 없이)
  static PlanShare distributeToTeam(
    Plan plan,
    String sharedBy,
    List<String> teamMembers,
    {String? message, DateTime? expiresAt}
  ) {
    return PlanShare(
      id: DateTime.now().millisecondsSinceEpoch,
      plan: plan,
      sharedBy: sharedBy,
      sharedWith: teamMembers,
      status: PlanShareStatus.PENDING,
      type: PlanShareType.TEAM_WIDE,
      sharedAt: DateTime.now(),
      expiresAt: expiresAt,
      message: message,
    );
  }

  // 특정 사용자들에게 계획 공유
  static PlanShare shareWithUsers(
    Plan plan,
    String sharedBy,
    List<String> users,
    {String? message, DateTime? expiresAt}
  ) {
    return PlanShare(
      id: DateTime.now().millisecondsSinceEpoch,
      plan: plan,
      sharedBy: sharedBy,
      sharedWith: users,
      status: PlanShareStatus.PENDING,
      type: PlanShareType.USER_SPECIFIC,
      sharedAt: DateTime.now(),
      expiresAt: expiresAt,
      message: message,
    );
  }

  // 날짜 범위로 계획 공유
  static PlanShare shareWithDateRange(
    Plan plan,
    String sharedBy,
    List<String> users,
    DateTime startDate,
    DateTime endDate,
    {String? message, DateTime? expiresAt}
  ) {
    return PlanShare(
      id: DateTime.now().millisecondsSinceEpoch,
      plan: plan,
      sharedBy: sharedBy,
      sharedWith: users,
      status: PlanShareStatus.PENDING,
      type: PlanShareType.DATE_RANGE,
      sharedAt: DateTime.now(),
      expiresAt: expiresAt,
      message: message,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // 공유 수락
  static PlanShare acceptShare(PlanShare share, String acceptedBy) {
    return share.copyWith(
      status: PlanShareStatus.ACCEPTED,
      acceptedAt: DateTime.now(),
      acceptedBy: acceptedBy,
    );
  }

  // 공유 거절
  static PlanShare rejectShare(PlanShare share, String rejectedBy) {
    return share.copyWith(
      status: PlanShareStatus.REJECTED,
      rejectedAt: DateTime.now(),
      rejectedBy: rejectedBy,
    );
  }

  // 공유 만료 처리
  static PlanShare expireShare(PlanShare share) {
    return share.copyWith(
      status: PlanShareStatus.EXPIRED,
    );
  }

  // 공유 삭제
  static bool deleteShare(PlanShare share) {
    // 실제로는 데이터베이스에서 삭제
    return true;
  }

  // 사용자별 공유 목록 조회
  static List<PlanShare> getSharesForUser(List<PlanShare> shares, String userId) {
    return shares.where((share) => 
      share.sharedWith.contains(userId) || share.sharedBy == userId
    ).toList();
  }

  // 팀별 공유 목록 조회
  static List<PlanShare> getTeamShares(List<PlanShare> shares) {
    return shares.where((share) => share.isTeamWide).toList();
  }

  // 상태별 공유 목록 조회
  static List<PlanShare> getSharesByStatus(List<PlanShare> shares, PlanShareStatus status) {
    return shares.where((share) => share.status == status).toList();
  }

  // 날짜 범위별 공유 목록 조회
  static List<PlanShare> getSharesByDateRange(
    List<PlanShare> shares,
    DateTime startDate,
    DateTime endDate
  ) {
    return shares.where((share) {
      if (!share.isDateRangeSpecific) return false;
      return share.startDate != null && 
             share.endDate != null &&
             share.startDate!.isBefore(endDate) &&
             share.endDate!.isAfter(startDate);
    }).toList();
  }

  // 공유 통계
  static Map<String, dynamic> getShareStats(List<PlanShare> shares) {
    return {
      'total': shares.length,
      'pending': shares.where((s) => s.isPending).length,
      'accepted': shares.where((s) => s.isAccepted).length,
      'rejected': shares.where((s) => s.isRejected).length,
      'expired': shares.where((s) => s.isExpired).length,
      'teamWide': shares.where((s) => s.isTeamWide).length,
      'userSpecific': shares.where((s) => s.isUserSpecific).length,
      'dateRange': shares.where((s) => s.isDateRangeSpecific).length,
    };
  }

  // 날짜 중복 확인
  static bool hasDateConflict(Plan plan, List<PlanShare> existingShares, DateTime startDate, DateTime endDate) {
    for (final share in existingShares) {
      if (share.plan.id == plan.id) continue;
      
      if (share.isDateRangeSpecific && 
          share.startDate != null && 
          share.endDate != null) {
        // 날짜 범위가 겹치는지 확인
        if (startDate.isBefore(share.endDate!) && endDate.isAfter(share.startDate!)) {
          return true;
        }
      }
    }
    return false;
  }

  // 만료된 공유 처리
  static List<PlanShare> processExpiredShares(List<PlanShare> shares) {
    final now = DateTime.now();
    return shares.map((share) {
      if (share.expiresAt != null && share.expiresAt!.isBefore(now) && share.isPending) {
        return expireShare(share);
      }
      return share;
    }).toList();
  }
} 