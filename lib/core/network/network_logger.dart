import 'dart:developer';
import 'package:http/http.dart';

class NetworkLogger {
  static bool isLoggingEnabled = true;

  static void logRequest(String method, Uri uri, Map<String, String>? headers) {
    if (!isLoggingEnabled) return;
    final timestamp = DateTime.now().toIso8601String();
    log('[$timestamp] Network Request: $method $uri');
    if (headers != null && headers.isNotEmpty) {
      log('Headers: $headers');
    }
  }

  static void logResponse(Response response, {int? duration}) {
    if (!isLoggingEnabled) return;
    final timestamp = DateTime.now().toIso8601String();
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    final statusType = isSuccess ? 'Success' : 'Failure';

    log('[$timestamp] Response Status: ${response.statusCode} ($statusType)');
    log('Response Body: ${response.body}');

    if (duration != null) {
      log('Response Time: $duration ms');
    }
  }

  static void logError(String operation, dynamic error) {
    if (!isLoggingEnabled) return;
    final timestamp = DateTime.now().toIso8601String();
    log('[$timestamp] Error during $operation: $error');
  }
}
