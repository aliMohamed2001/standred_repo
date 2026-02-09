import 'package:dio/dio.dart';
import 'package:new_standred/core/dio_client/api_keys.dart';
import 'endpoints.dart';
import 'server_exception.dart';

class DioClient {
  DioClient(this._dio, {this.language}) {
    _dio
      ..options.baseUrl = Endpoint.apiBaseUrl
      ..options.connectTimeout = Endpoint.connectionTimeout
      ..options.receiveTimeout = Endpoint.receiveTimeout
      ..options.responseType = ResponseType.json;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers[ApiKeys.acceptLanguage] = language ?? 'ar';
          options.headers[ApiKeys.contentType] = 'application/json';
          options.headers[ApiKeys.accept] = 'application/json';
       
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  String? token;
  String? language;

  void update(String newLanguage) {
    language = newLanguage;
    _dio.options.headers[ApiKeys.acceptLanguage] = newLanguage;
  }

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(headers: {}),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      throw ServerException.fromDioException(e);
    }
  }

  Future<dynamic> post(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        url,
        data: data,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {
                ApiKeys.contentType: 'application/json',
                ApiKeys.accept: 'application/json',
              },
            ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      throw ServerException.fromDioException(e);
    }
  }

  Future<dynamic> put(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(headers: {}),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      throw ServerException.fromDioException(e);
    }
  }

  Future<dynamic> delete(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(headers: {}),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      throw ServerException.fromDioException(e);
    }
  }
}
