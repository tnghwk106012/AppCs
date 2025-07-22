import 'api_exception.dart';

class ApiResponse<T> {
  final T? data;
  final ApiException? error;
  final bool isSuccess;
  final int? statusCode;
  final Map<String, dynamic>? metadata;

  const ApiResponse._({
    this.data,
    this.error,
    required this.isSuccess,
    this.statusCode,
    this.metadata,
  });

  factory ApiResponse.success(T data, {int? statusCode, Map<String, dynamic>? metadata}) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
      statusCode: statusCode,
      metadata: metadata,
    );
  }

  factory ApiResponse.error(ApiException error) {
    return ApiResponse._(
      error: error,
      isSuccess: false,
      statusCode: error.statusCode,
    );
  }

  factory ApiResponse.loading() {
    return const ApiResponse._(isSuccess: false);
  }

  // 데이터가 있는지 확인
  bool get hasData => data != null;
  
  // 오류가 있는지 확인
  bool get hasError => error != null;
  
  // 로딩 상태인지 확인
  bool get isLoading => !isSuccess && !hasError;

  // 데이터를 안전하게 가져오기
  T? get safeData => isSuccess ? data : null;
  
  // 오류 메시지 가져오기
  String get errorMessage => error?.message ?? '알 수 없는 오류가 발생했습니다.';

  // 데이터 변환
  ApiResponse<R> map<R>(R Function(T data) transform) {
    if (isSuccess && hasData) {
      try {
        final transformedData = transform(data!);
        return ApiResponse.success(transformedData, 
          statusCode: statusCode, 
          metadata: metadata);
      } catch (e) {
        return ApiResponse.error(ApiException(
          message: '데이터 변환 오류: $e',
          statusCode: statusCode,
        ));
      }
    }
    return ApiResponse.error(error ?? ApiException(message: '변환할 데이터가 없습니다.'));
  }

  // 오류 처리
  ApiResponse<T> onError(ApiResponse<T> Function(ApiException error) handler) {
    if (hasError) {
      return handler(error!);
    }
    return this;
  }

  // 성공 처리
  ApiResponse<T> onSuccess(ApiResponse<T> Function(T data) handler) {
    if (isSuccess && hasData) {
      return handler(data!);
    }
    return this;
  }

  // 로딩 처리
  ApiResponse<T> onLoading(ApiResponse<T> Function() handler) {
    if (isLoading) {
      return handler();
    }
    return this;
  }

  // 조건부 처리
  ApiResponse<T> when({
    required ApiResponse<T> Function() loading,
    required ApiResponse<T> Function(T data) success,
    required ApiResponse<T> Function(ApiException error) error,
  }) {
    if (isLoading) {
      return loading();
    } else if (isSuccess && hasData) {
      return success(data!);
    } else if (hasError) {
      return error(this.error!);
    } else {
      return ApiResponse.error(ApiException(message: '알 수 없는 상태'));
    }
  }

  // 데이터를 다른 타입으로 변환
  ApiResponse<R> transform<R>(R Function(T data) transform) {
    return map(transform);
  }

  // 오류를 다른 타입으로 변환
  ApiResponse<T> transformError(ApiException Function(ApiException error) transform) {
    if (hasError) {
      return ApiResponse.error(transform(error!));
    }
    return this;
  }

  // 배치 응답 처리
  static ApiResponse<List<T>> batch<T>(List<ApiResponse<T>> responses) {
    final errors = <ApiException>[];
    final data = <T>[];

    for (final response in responses) {
      if (response.isSuccess && response.hasData) {
        data.add(response.data!);
      } else if (response.hasError) {
        errors.add(response.error!);
      }
    }

    if (errors.isNotEmpty) {
      final errorMessage = errors.map((e) => e.message).join('; ');
      return ApiResponse.error(ApiException(
        message: '배치 처리 중 오류 발생: $errorMessage',
        statusCode: errors.first.statusCode,
      ));
    }

    return ApiResponse.success(data);
  }

  // 성공 응답만 필터링
  static List<T> filterSuccess<T>(List<ApiResponse<T>> responses) {
    return responses
        .where((response) => response.isSuccess && response.hasData)
        .map((response) => response.data!)
        .toList();
  }

  // 오류 응답만 필터링
  static List<ApiException> filterErrors<T>(List<ApiResponse<T>> responses) {
    return responses
        .where((response) => response.hasError)
        .map((response) => response.error!)
        .toList();
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'ApiResponse.success(data: $data, statusCode: $statusCode)';
    } else if (hasError) {
      return 'ApiResponse.error(error: $error)';
    } else {
      return 'ApiResponse.loading()';
    }
  }
} 