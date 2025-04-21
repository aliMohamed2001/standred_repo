import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import '../errors/api_exception.dart';
import '../errors/network_exception.dart';
import 'network_logger.dart';
import 'response_wrapper.dart';
import 'retry_strategy.dart';

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required this.baseUrl,
    this.defaultHeaders = const {},
  });

  Future<ApiResponse<T>> get<T>(String endpoint, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final startTime = DateTime.now();
      NetworkLogger.logRequest('GET', uri, headers);
      
      final response = await retry(
        () => http.get(
              uri,
              headers: {...defaultHeaders, if (headers != null) ...headers},
            ).timeout(const Duration(seconds: 10)),
        retryIf: shouldRetry,
        maxAttempts: 3,
      );
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      NetworkLogger.logResponse(response, duration: duration);
      return ApiResponse(data: _processResponse(response) as T);
    } catch (error) {
      NetworkLogger.logError('GET $endpoint', error);
      return ApiResponse(error: error.toString());
    }
  }

  Future<ApiResponse<T>> post<T>(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final startTime = DateTime.now();
      NetworkLogger.logRequest('POST', uri, headers);
      
      final response = await retry(
        () => http.post(
              uri,
              headers: {
                ...defaultHeaders,
                'Content-Type': 'application/json',
                if (headers != null) ...headers,
              },
              body: jsonEncode(body),
            ).timeout(const Duration(seconds: 10)),
        retryIf: shouldRetry,
        maxAttempts: 3,
      );
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      NetworkLogger.logResponse(response, duration: duration);
      return ApiResponse(data: _processResponse(response) as T);
    } catch (error) {
      NetworkLogger.logError('POST $endpoint', error);
      return ApiResponse(error: error.toString());
    }
  }

  Future<ApiResponse<T>> put<T>(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final startTime = DateTime.now();
      NetworkLogger.logRequest('PUT', uri, headers);
      
      final response = await retry(
        () => http.put(
              uri,
              headers: {
                ...defaultHeaders,
                'Content-Type': 'application/json',
                if (headers != null) ...headers,
              },
              body: jsonEncode(body),
            ).timeout(const Duration(seconds: 10)),
        retryIf: shouldRetry,
        maxAttempts: 3,
      );
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      NetworkLogger.logResponse(response, duration: duration);
      return ApiResponse(data: _processResponse(response) as T);
    } catch (error) {
      NetworkLogger.logError('PUT $endpoint', error);
      return ApiResponse(error: error.toString());
    }
  }

  Future<ApiResponse<T>> delete<T>(String endpoint, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final startTime = DateTime.now();
      NetworkLogger.logRequest('DELETE', uri, headers);
      
      final response = await retry(
        () => http.delete(
              uri,
              headers: {...defaultHeaders, if (headers != null) ...headers},
            ).timeout(const Duration(seconds: 10)),
        retryIf: shouldRetry,
        maxAttempts: 3,
      );
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      NetworkLogger.logResponse(response, duration: duration);
      return ApiResponse(data: _processResponse(response) as T);
    } catch (error) {
      NetworkLogger.logError('DELETE $endpoint', error);
      return ApiResponse(error: error.toString());
    }
  }


Future<ApiResponse<T>> patch<T>(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
  try {
    final uri = Uri.parse('$baseUrl$endpoint');
    final startTime = DateTime.now();
    NetworkLogger.logRequest('PATCH', uri, headers);
    
    final response = await retry(
      () => http.patch(
            uri,
            headers: {
              ...defaultHeaders,
              'Content-Type': 'application/json',
              if (headers != null) ...headers,
            },
            body: jsonEncode(body),
          ).timeout(const Duration(seconds: 10)),
      retryIf: shouldRetry,
      maxAttempts: 3,
    );
    
    final duration = DateTime.now().difference(startTime).inMilliseconds;
    NetworkLogger.logResponse(response, duration: duration);
    return ApiResponse(data: _processResponse(response) as T);
  } catch (error) {
    NetworkLogger.logError('PATCH $endpoint', error);
    return ApiResponse(error: error.toString());
  }
}


Future<ApiResponse<String>> uploadFile(String endpoint, File file, {Map<String, String>? headers}) async {
  try {
    final uri = Uri.parse('$baseUrl$endpoint');
    NetworkLogger.logRequest('UPLOAD', uri, headers);

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({...defaultHeaders, if (headers != null) ...headers})
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    NetworkLogger.logResponse(http.Response(responseBody, response.statusCode));

    return ApiResponse(data: responseBody);
  } catch (error) {
    NetworkLogger.logError('UPLOAD $endpoint', error);
    return ApiResponse(error: error.toString());
  }
}
Future<ApiResponse<File>> downloadFile(String endpoint, String savePath, {Map<String, String>? headers}) async {
  try {
    final uri = Uri.parse('$baseUrl$endpoint');
    NetworkLogger.logRequest('DOWNLOAD', uri, headers);

    final response = await retry(
      () => http.get(uri, headers: {...defaultHeaders, if (headers != null) ...headers}),
      retryIf: shouldRetry,
      maxAttempts: 3,
    );

    NetworkLogger.logResponse(response);
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      return ApiResponse(data: file);
    } else {
      throw ApiException('Failed to download file', statusCode: response.statusCode);
    }
  } catch (error) {
    NetworkLogger.logError('DOWNLOAD $endpoint', error);
    return ApiResponse(error: error.toString());
  }
}

  dynamic _processResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
    case 201:
      return jsonDecode(response.body);
    case 400:
      throw ApiException('Bad Request', statusCode: response.statusCode, details: response.body);
    case 401:
      throw NetworkException('Unauthorized', response.statusCode);
    case 403:
      throw NetworkException('Forbidden', response.statusCode);
    case 404:
      throw ApiException('Not Found', statusCode: response.statusCode);
    case 500:
      throw ApiException('Internal Server Error', statusCode: response.statusCode);
    default:
      throw ApiException('Unknown error', statusCode: response.statusCode, details: response.body);
  }
}

}
