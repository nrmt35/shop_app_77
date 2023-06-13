import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AuthInterceptor extends Interceptor {
  final String? Function(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) tokenProvider;

  AuthInterceptor({required this.tokenProvider});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.headers[HttpHeaders.authorizationHeader] != null) {
      handler.next(options);
      return;
    }

    final authorization = tokenProvider(options, handler);
    if (authorization != null) {
      options.headers[HttpHeaders.authorizationHeader] = authorization;
    }
    handler.next(options);
  }
}

class LoggerInterceptor extends PrettyDioLogger {
  LoggerInterceptor({
    super.request = true,
    super.requestHeader = true,
    super.requestBody = true,
    super.responseHeader = true,
    super.responseBody = true,
    super.error = true,
    super.maxWidth = 100,
    super.compact = true,
    super.logPrint = defaultLogPrint,
  });

  static void defaultLogPrint(Object obj) => log(obj.toString());
}
