import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'interceptors/auth_interceptor.dart';

final apiProvider = Provider<Dio>((ref) {
  return ApiService.create();
});

class ApiService {
  static final productionUrl = 'https://diiket.rejoin.id/api/v1';
  static final debuggingUrl = 'http://localhost:8000/api/v1';

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        // baseUrl: kReleaseMode ? productionUrl : debuggingUrl,
        baseUrl: productionUrl,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      // LoggingInterceptors(),
    ]);

    return dio;
  }
}
