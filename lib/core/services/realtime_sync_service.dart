import 'dart:async';
import 'dart:convert';
import '../models/api_response.dart';
import '../models/api_exception.dart';
import '../../features/plans/models/plan.dart';
import '../../features/schedules/models/schedule.dart';
import '../../features/plans/models/plan_share_service.dart';
import '../../features/schedules/models/schedule_service.dart';

enum SyncEventType {
  PLAN_CREATED,
  PLAN_UPDATED,
  PLAN_DELETED,
  SCHEDULE_CREATED,
  SCHEDULE_UPDATED,
  SCHEDULE_DELETED,
  SHARE_CREATED,
  SHARE_UPDATED,
  SHARE_DELETED,
  INTEGRATION_UPDATED,
}

class SyncEvent {
  final SyncEventType type;
  final String entityId;
  final String userId;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  final String? message;

  SyncEvent({
    required this.type,
    required this.entityId,
    required this.userId,
    required this.timestamp,
    required this.data,
    this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'entityId': entityId,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
      'message': message,
    };
  }

  factory SyncEvent.fromMap(Map<String, dynamic> map) {
    return SyncEvent(
      type: SyncEventType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
      ),
      entityId: map['entityId'],
      userId: map['userId'],
      timestamp: DateTime.parse(map['timestamp']),
      data: map['data'],
      message: map['message'],
    );
  }
}

class RealtimeSyncService {
  static final RealtimeSyncService _instance = RealtimeSyncService._internal();
  factory RealtimeSyncService() => _instance;
  RealtimeSyncService._internal();

  final StreamController<SyncEvent> _eventController = StreamController<SyncEvent>.broadcast();
  final Map<String, List<SyncEvent>> _eventHistory = {};
  final Map<String, Timer> _syncTimers = {};
  bool _isConnected = false;

  // 스트림 getter
  Stream<SyncEvent> get eventStream => _eventController.stream;

  // 연결 상태
  bool get isConnected => _isConnected;

  // 이벤트 발생
  void emitEvent(SyncEvent event) {
    _eventController.add(event);
    _storeEvent(event);
    _processEvent(event);
  }

  // 이벤트 저장
  void _storeEvent(SyncEvent event) {
    final key = '${event.type}_${event.entityId}';
    if (!_eventHistory.containsKey(key)) {
      _eventHistory[key] = [];
    }
    _eventHistory[key]!.add(event);
    
    // 최근 100개만 유지
    if (_eventHistory[key]!.length > 100) {
      _eventHistory[key] = _eventHistory[key]!.skip(100).toList();
    }
  }

  // 이벤트 처리
  void _processEvent(SyncEvent event) {
    switch (event.type) {
      case SyncEventType.PLAN_CREATED:
      case SyncEventType.PLAN_UPDATED:
        _handlePlanChange(event);
        break;
      case SyncEventType.SCHEDULE_CREATED:
      case SyncEventType.SCHEDULE_UPDATED:
        _handleScheduleChange(event);
        break;
      case SyncEventType.SHARE_CREATED:
      case SyncEventType.SHARE_UPDATED:
        _handleShareChange(event);
        break;
      case SyncEventType.INTEGRATION_UPDATED:
        _handleIntegrationChange(event);
        break;
      default:
        break;
    }
  }

  // 계획 변경 처리
  void _handlePlanChange(SyncEvent event) {
    final planData = event.data;
    final plan = Plan.fromMap(planData);
    
    // 연관된 일정들 업데이트
    _updateRelatedSchedules(plan);
    
    // 공유 상태 업데이트
    _updateShareStatus(plan);
    
    // 통합 상태 재계산
    _recalculateIntegration(plan.id);
  }

  // 일정 변경 처리
  void _handleScheduleChange(SyncEvent event) {
    final scheduleData = event.data;
    final schedule = Schedule.fromMap(scheduleData);
    
    // 연관된 계획 업데이트
    if (schedule.planId != null) {
      _updateRelatedPlan(schedule);
    }
    
    // 충돌 검사
    _checkConflicts(schedule);
    
    // 통합 상태 재계산
    if (schedule.planId != null) {
      _recalculateIntegration(schedule.planId!);
    }
  }

  // 공유 변경 처리
  void _handleShareChange(SyncEvent event) {
    final shareData = event.data;
    
    // 공유 상태 업데이트
    _updateShareNotifications(shareData);
    
    // 권한 검사
    _validatePermissions(shareData);
  }

  // 통합 변경 처리
  void _handleIntegrationChange(SyncEvent event) {
    final integrationData = event.data;
    
    // 통합 상태 업데이트
    _updateIntegrationStatus(integrationData);
    
    // 알림 발송
    _sendIntegrationNotifications(integrationData);
  }

  // 연관된 일정 업데이트
  void _updateRelatedSchedules(Plan plan) {
    // 실제로는 데이터베이스에서 연관된 일정들을 조회하여 업데이트
    // 여기서는 모의 구현
    print('계획 ${plan.id}와 연관된 일정들을 업데이트합니다.');
  }

  // 연관된 계획 업데이트
  void _updateRelatedPlan(Schedule schedule) {
    // 실제로는 데이터베이스에서 연관된 계획을 조회하여 업데이트
    print('일정 ${schedule.id}와 연관된 계획을 업데이트합니다.');
  }

  // 공유 상태 업데이트
  void _updateShareStatus(Plan plan) {
    // 실제로는 공유 상태를 업데이트
    print('계획 ${plan.id}의 공유 상태를 업데이트합니다.');
  }

  // 충돌 검사
  void _checkConflicts(Schedule schedule) {
    // 실제로는 충돌 검사 로직 실행
    print('일정 ${schedule.id}에 대한 충돌을 검사합니다.');
  }

  // 통합 상태 재계산
  void _recalculateIntegration(int planId) {
    // 실제로는 통합 상태를 재계산
    print('계획 ${planId}의 통합 상태를 재계산합니다.');
  }

  // 공유 알림 업데이트
  void _updateShareNotifications(Map<String, dynamic> shareData) {
    // 실제로는 공유 알림을 업데이트
    print('공유 알림을 업데이트합니다.');
  }

  // 권한 검사
  void _validatePermissions(Map<String, dynamic> shareData) {
    // 실제로는 권한을 검사
    print('공유 권한을 검사합니다.');
  }

  // 통합 상태 업데이트
  void _updateIntegrationStatus(Map<String, dynamic> integrationData) {
    // 실제로는 통합 상태를 업데이트
    print('통합 상태를 업데이트합니다.');
  }

  // 통합 알림 발송
  void _sendIntegrationNotifications(Map<String, dynamic> integrationData) {
    // 실제로는 알림을 발송
    print('통합 알림을 발송합니다.');
  }

  // 실시간 동기화 시작
  Future<void> startSync() async {
    if (_isConnected) return;
    
    _isConnected = true;
    
    // 주기적 동기화 타이머 시작
    _startPeriodicSync();
    
    // 연결 상태 모니터링
    _startConnectionMonitoring();
    
    print('실시간 동기화가 시작되었습니다.');
  }

  // 실시간 동기화 중지
  Future<void> stopSync() async {
    if (!_isConnected) return;
    
    _isConnected = false;
    
    // 모든 타이머 정리
    for (final timer in _syncTimers.values) {
      timer.cancel();
    }
    _syncTimers.clear();
    
    print('실시간 동기화가 중지되었습니다.');
  }

  // 주기적 동기화 시작
  void _startPeriodicSync() {
    // 30초마다 동기화
    _syncTimers['periodic'] = Timer.periodic(const Duration(seconds: 30), (timer) {
      _performPeriodicSync();
    });
  }

  // 연결 상태 모니터링
  void _startConnectionMonitoring() {
    // 10초마다 연결 상태 확인
    _syncTimers['connection'] = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkConnectionStatus();
    });
  }

  // 주기적 동기화 수행
  void _performPeriodicSync() {
    if (!_isConnected) return;
    
    // 미처리된 이벤트들 처리
    _processPendingEvents();
    
    // 데이터 무결성 검사
    _validateDataIntegrity();
    
    // 성능 최적화
    _optimizePerformance();
  }

  // 연결 상태 확인
  void _checkConnectionStatus() {
    if (!_isConnected) return;
    
    // 실제로는 네트워크 연결 상태를 확인
    final isNetworkAvailable = true; // 모의 구현
    
    if (!isNetworkAvailable) {
      print('네트워크 연결이 불안정합니다.');
      _handleConnectionLoss();
    }
  }

  // 미처리된 이벤트들 처리
  void _processPendingEvents() {
    // 실제로는 미처리된 이벤트들을 처리
    print('미처리된 이벤트들을 처리합니다.');
  }

  // 데이터 무결성 검사
  void _validateDataIntegrity() {
    // 실제로는 데이터 무결성을 검사
    print('데이터 무결성을 검사합니다.');
  }

  // 성능 최적화
  void _optimizePerformance() {
    // 실제로는 성능을 최적화
    print('성능을 최적화합니다.');
  }

  // 연결 손실 처리
  void _handleConnectionLoss() {
    // 실제로는 연결 손실을 처리
    print('연결 손실을 처리합니다.');
  }

  // 특정 엔티티의 이벤트 히스토리 조회
  List<SyncEvent> getEventHistory(String entityId, SyncEventType? type) {
    final key = type != null ? '${type}_$entityId' : entityId;
    return _eventHistory[key] ?? [];
  }

  // 최근 이벤트 조회
  List<SyncEvent> getRecentEvents({int limit = 50}) {
    final allEvents = <SyncEvent>[];
    for (final events in _eventHistory.values) {
      allEvents.addAll(events);
    }
    
    allEvents.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return allEvents.take(limit).toList();
  }

  // 특정 사용자의 이벤트 조회
  List<SyncEvent> getUserEvents(String userId, {int limit = 50}) {
    final userEvents = <SyncEvent>[];
    for (final events in _eventHistory.values) {
      userEvents.addAll(events.where((e) => e.userId == userId));
    }
    
    userEvents.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return userEvents.take(limit).toList();
  }

  // 리소스 정리
  void dispose() {
    stopSync();
    _eventController.close();
    _eventHistory.clear();
  }
} 