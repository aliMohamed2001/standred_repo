import 'package:dio/dio.dart';
import 'package:new_standred/shared/toast/show_custom_toast.dart';

class ServerException implements Exception {
  ServerException({this.message, this.statusCode});

  ServerException.fromDioException(Object exception) {
    if (exception is DioException) {
      message = switch (exception.type) {
        DioExceptionType.cancel => "",
        DioExceptionType.connectionTimeout => "انتهت المهلة بسبب الاتصال",
        DioExceptionType.sendTimeout => "انتهت المهلة أثناء الإرسال",
        DioExceptionType.receiveTimeout => "انتهت المهلة أثناء الاستلام",
        DioExceptionType.badResponse => _handleError(exception.response),
        _ => exception.message.toString()
      };

      if (exception.type == DioExceptionType.unknown) {
        statusCode = 522;
        message = "لا يوجد اتصال بالإنترنت";
      }
    } else {
      message = "خطأ غير متوقع";
    }
  }

  String? message = "خطأ غير متوقع";
  int? statusCode;

  String _handleError(Response<dynamic>? response) {
    statusCode = response?.statusCode;
    if (statusCode == 422) {
      final responseData = response?.data;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('message')) {
        if(responseData['message'].toString() != "هذا المستخدم غير موجود."){
          showfailureToast(responseData['message'].toString());
        }
      }
    }
    if (statusCode == 400) {
      final responseData = response?.data;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('message')) {
        showfailureToast(responseData['message'].toString());
        return responseData['message'].toString();
      }
    }
    return switch (statusCode) {
      401 => "انتهت الجلسة",
      404 => "المورد غير موجود",
      500 => "خطأ داخلي في الخادم",
      _ => "خطأ غير متوقع"
    };
  }

  @override
  String toString() => message!;
}
