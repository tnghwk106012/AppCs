import 'package:flutter/foundation.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? details;
  final DateTime timestamp;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ApiException.fromMap(Map<String, dynamic> map) {
    return ApiException(
      message: map['message'] as String? ?? '알 수 없는 오류가 발생했습니다',
      statusCode: map['statusCode'] as int?,
      errorCode: map['errorCode'] as String?,
      details: map['details'] as Map<String, dynamic>?,
      timestamp: map['timestamp'] != null 
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'statusCode': statusCode,
      'errorCode': errorCode,
      'details': details,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ApiException.fromException(dynamic exception) {
    if (exception is ApiException) return exception;
    
    return ApiException(
      message: exception.toString(),
      statusCode: 500,
      errorCode: 'UNKNOWN_ERROR',
    );
  }

  factory ApiException.networkError() {
    return ApiException(
      message: '네트워크 연결을 확인해주세요',
      statusCode: 0,
      errorCode: 'NETWORK_ERROR',
    );
  }

  factory ApiException.timeoutError() {
    return ApiException(
      message: '요청 시간이 초과되었습니다',
      statusCode: 408,
      errorCode: 'TIMEOUT_ERROR',
    );
  }

  factory ApiException.validationError(Map<String, dynamic> validationErrors) {
    return ApiException(
      message: '입력 데이터를 확인해주세요',
      statusCode: 422,
      errorCode: 'VALIDATION_ERROR',
      details: validationErrors,
    );
  }

  factory ApiException.serverError() {
    return ApiException(
      message: '서버 오류가 발생했습니다',
      statusCode: 500,
      errorCode: 'SERVER_ERROR',
    );
  }

  factory ApiException.unauthorized() {
    return ApiException(
      message: '인증이 필요합니다',
      statusCode: 401,
      errorCode: 'UNAUTHORIZED',
    );
  }

  factory ApiException.forbidden() {
    return ApiException(
      message: '접근 권한이 없습니다',
      statusCode: 403,
      errorCode: 'FORBIDDEN',
    );
  }

  factory ApiException.notFound() {
    return ApiException(
      message: '요청한 리소스를 찾을 수 없습니다',
      statusCode: 404,
      errorCode: 'NOT_FOUND',
    );
  }

  factory ApiException.conflict() {
    return ApiException(
      message: '데이터 충돌이 발생했습니다',
      statusCode: 409,
      errorCode: 'CONFLICT',
    );
  }

  factory ApiException.rateLimitExceeded() {
    return ApiException(
      message: '요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: 429,
      errorCode: 'RATE_LIMIT_EXCEEDED',
    );
  }

  factory ApiException.maintenance() {
    return ApiException(
      message: '서비스 점검 중입니다. 잠시 후 다시 시도해주세요.',
      statusCode: 503,
      errorCode: 'MAINTENANCE',
    );
  }

  // 오류 타입 확인
  bool get isNetworkError => errorCode == 'NETWORK_ERROR';
  bool get isTimeout => errorCode == 'TIMEOUT_ERROR';
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isValidationError => errorCode == 'VALIDATION_ERROR';
  bool get isRateLimitExceeded => errorCode == 'RATE_LIMIT_EXCEEDED';
  bool get isMaintenance => errorCode == 'MAINTENANCE';

  // 사용자 친화적 메시지
  String get userFriendlyMessage {
    if (isNetworkError) {
      return '인터넷 연결을 확인해주세요.';
    } else if (isTimeout) {
      return '요청이 시간 초과되었습니다. 다시 시도해주세요.';
    } else if (isUnauthorized) {
      return '로그인이 필요합니다.';
    } else if (isForbidden) {
      return '접근 권한이 없습니다.';
    } else if (isNotFound) {
      return '요청한 정보를 찾을 수 없습니다.';
    } else if (isServerError) {
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    } else if (isValidationError) {
      return '입력 정보를 확인해주세요.';
    } else if (isRateLimitExceeded) {
      return '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
    } else if (isMaintenance) {
      return '서비스 점검 중입니다. 잠시 후 다시 시도해주세요.';
    } else {
      return message;
    }
  }

  // 오류 심각도
  ErrorSeverity get severity {
    if (isNetworkError || isTimeout) {
      return ErrorSeverity.LOW;
    } else if (isUnauthorized || isForbidden) {
      return ErrorSeverity.MEDIUM;
    } else if (isServerError || isMaintenance) {
      return ErrorSeverity.HIGH;
    } else {
      return ErrorSeverity.MEDIUM;
    }
  }

  // 재시도 가능 여부
  bool get isRetryable {
    return isNetworkError || isTimeout || isServerError || isMaintenance;
  }

  // 재시도 지연 시간
  Duration get retryDelay {
    switch (severity) {
      case ErrorSeverity.LOW:
        return const Duration(seconds: 1);
      case ErrorSeverity.MEDIUM:
        return const Duration(seconds: 3);
      case ErrorSeverity.HIGH:
        return const Duration(seconds: 5);
    }
  }

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode, Code: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiException &&
        other.message == message &&
        other.statusCode == statusCode &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode {
    return Object.hash(message, statusCode, errorCode);
  }
}

enum ErrorSeverity { LOW, MEDIUM, HIGH } 