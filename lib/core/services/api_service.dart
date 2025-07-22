import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/api_exception.dart';

class ApiService {
  static const String _baseUrl = 'https://api.caresync.com/v1';
  static const Duration _timeout = Duration(seconds: 30);
  
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 인증 토큰 관리
  static String? _authToken;
  
  static void setAuthToken(String token) {
    _authToken = token;
    _headers['Authorization'] = 'Bearer $token';
  }

  static void clearAuthToken() {
    _authToken = null;
    _headers.remove('Authorization');
  }

  // GET 요청
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint').replace(
        queryParameters: queryParameters?.map((key, value) => MapEntry(key, value.toString())),
      );

      final response = await http.get(uri, headers: _headers).timeout(_timeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(ApiException.fromException(e));
    }
  }

  // POST 요청
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(_timeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(ApiException.fromException(e));
    }
  }

  // PUT 요청
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http.put(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(_timeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(ApiException.fromException(e));
    }
  }

  // DELETE 요청
  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http.delete(uri, headers: _headers).timeout(_timeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(ApiException.fromException(e));
    }
  }

  // PATCH 요청
  static Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http.patch(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(_timeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(ApiException.fromException(e));
    }
  }

  // 응답 처리
  static ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      if (fromJson != null && body != null) {
        try {
          final data = fromJson(body);
          return ApiResponse.success(data);
        } catch (e) {
          return ApiResponse.error(ApiException(
            message: '데이터 파싱 오류: $e',
            statusCode: statusCode,
          ));
        }
      } else {
        return ApiResponse.success(body as T);
      }
    } else {
      return ApiResponse.error(ApiException(
        message: body?['message'] ?? '서버 오류',
        statusCode: statusCode,
        data: body,
      ));
    }
  }

  // 파일 업로드
  static Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    File file, {
    Map<String, String>? fields,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);
      
      // 헤더 추가
      request.headers.addAll(_headers);
      
      // 파일 추가
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      
      // 필드 추가
      if (fields != null) {
        request.fields.addAll(fields);
      }
      
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(ApiException.fromException(e));
    }
  }

  // 배치 요청
  static Future<List<ApiResponse<T>>> batch<T>(
    List<ApiRequest> requests, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final results = <ApiResponse<T>>[];
    
    for (final request in requests) {
      ApiResponse<T> result;
      
      switch (request.method) {
        case 'GET':
          result = await get<T>(request.endpoint, 
            queryParameters: request.queryParameters, 
            fromJson: fromJson);
          break;
        case 'POST':
          result = await post<T>(request.endpoint, 
            body: request.body, 
            fromJson: fromJson);
          break;
        case 'PUT':
          result = await put<T>(request.endpoint, 
            body: request.body, 
            fromJson: fromJson);
          break;
        case 'DELETE':
          result = await delete<T>(request.endpoint, fromJson: fromJson);
          break;
        default:
          result = ApiResponse.error(ApiException(message: '지원하지 않는 HTTP 메서드'));
      }
      
      results.add(result);
    }
    
    return results;
  }

  // 재시도 로직
  static Future<ApiResponse<T>> retry<T>(
    Future<ApiResponse<T>> Function() request,
    {int maxRetries = 3, Duration delay = const Duration(seconds: 1)},
  ) async {
    for (int i = 0; i < maxRetries; i++) {
      final response = await request();
      
      if (response.isSuccess) {
        return response;
      }
      
      if (i < maxRetries - 1) {
        await Future.delayed(delay * (i + 1));
      }
    }
    
    return await request();
  }

  // 연결 상태 확인
  static Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: _headers,
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class ApiRequest {
  final String method;
  final String endpoint;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? queryParameters;

  ApiRequest({
    required this.method,
    required this.endpoint,
    this.body,
    this.queryParameters,
  });
} 