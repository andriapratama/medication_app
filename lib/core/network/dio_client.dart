import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'retry_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );

    dio.interceptors.add(RetryInterceptor(dio));

    return dio;
  }
}
