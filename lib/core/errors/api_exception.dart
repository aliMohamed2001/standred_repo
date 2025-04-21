class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() {
    return 'ApiException: $message (Status code: $statusCode) Details: $details';
  }
}
