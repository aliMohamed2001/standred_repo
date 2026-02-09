import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_standred/shared/widgets/toast/custom_toast.dart';

class ServerException implements Exception {
  ServerException({this.message, this.statusCode});

  ServerException.fromDioException(Object exception, {BuildContext? context}) {
    if (exception is DioException) {
      message = switch (exception.type) {
        DioExceptionType.cancel => "",
        DioExceptionType.connectionTimeout => "connectionTimeout".tr(),
        DioExceptionType.sendTimeout => "sendTimeout".tr(),
        DioExceptionType.receiveTimeout => "receiveTimeout".tr(),
        DioExceptionType.badResponse => _handleError(
          exception.response,
          context,
        ),
        _ => exception.message.toString(),
      };

      if (exception.type == DioExceptionType.unknown) {
        statusCode = 522;
        message = "noInternetConnection".tr();
      }
      if (statusCode == 301 || statusCode == 302) {
       showfailureToast( "pleaseCheckYourUrl".tr());
      }
    } else {
      message = "unexpectedError".tr();
    }
  }

  String? message = "unexpectedError".tr();
  int? statusCode;

  String _handleError(Response<dynamic>? response, BuildContext? context) {
    statusCode = response?.statusCode;

    final responseData = response?.data;
    final bodyCode =
        (responseData is Map<String, dynamic>) ? responseData['code'] : null;

    if (statusCode == 401 || bodyCode == 401 || statusCode == 404) {
      if (context != null) {
       showfailureToast( "sessionExpired".tr());
      }
      return "sessionExpired".tr();
    }

    if (statusCode == 400 &&
        responseData is Map<String, dynamic> &&
        responseData.containsKey('message')) {
      if (context != null) {
       showfailureToast(responseData['message']);
      }
      return responseData['message'];
    }

    if (statusCode == 422 &&
        responseData is Map<String, dynamic> &&
        responseData.containsKey('message')) {
      showfailureToast( responseData['message']);
      return responseData['message'];
    }

    return switch (statusCode) {
      404 => "resourceNotFound".tr(),
      500 => "internalServerError".tr(),
      _ => "unexpectedError".tr(),
    };
  }

  @override
  String toString() => message!;
}
