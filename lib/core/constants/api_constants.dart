class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.fda.gov/drug/label.json';

  static const int defaultLimit = 20;

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const int rateLimitStatusCode = 429;

  static const int maxRetries = 3;

  static const Duration initialRetryDelay = Duration(seconds: 1);
}
