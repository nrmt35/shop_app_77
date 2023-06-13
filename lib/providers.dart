import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'build_config.dart';
import 'data/api_client.dart';
import 'data/basket.dart';
import 'data/database.dart';
import 'data/interceptors.dart';
import 'data/json_http_client.dart';

final dbProvider = Provider<DB>((ref) => DB());
final basketProvider = StateNotifierProvider<BasketStateNotifier, BasketState>(
  (ref) {
    final db = ref.watch(dbProvider);
    return BasketStateNotifier(db);
  },
);

final unauthorizedInterceptorsProvider = Provider(
  (ref) => [
    if (BuildConfig.isDebugBuild && BuildConfig.kDebugLogHttp) LoggerInterceptor(),
  ],
);

final interceptorsProvider = Provider(
  (ref) => [
    if (BuildConfig.isDebugBuild && BuildConfig.kDebugLogHttp) LoggerInterceptor(),
  ],
);

final httpClientProvider = Provider(
  (ref) {
    final httpClient = JsonHttpClient();
    ref.onDispose(httpClient.close);

    ref.listen<List<Interceptor>>(
      interceptorsProvider,
      (previous, next) {
        final registeredInterceptors = httpClient.dio.interceptors;
        if (previous != null) previous.forEach(registeredInterceptors.remove);
        registeredInterceptors.addAll(next);
      },
      fireImmediately: true,
    );

    return httpClient;
  },
  dependencies: [interceptorsProvider],
);

final apiClientProvider = Provider(
  (ref) => ApiClient(
    ref.watch(httpClientProvider),
  ),
  dependencies: [
    httpClientProvider,
  ],
);
