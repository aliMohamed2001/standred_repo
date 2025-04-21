import 'dart:async';

import 'package:http/http.dart' as http;

bool shouldRetry(Exception e) {
  return e is TimeoutException || e is http.ClientException;
}
