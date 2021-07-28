import 'package:dio/dio.dart';
import 'package:driver/data/credentials.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'interceptors/auth_interceptor.dart';

final apiProvider = Provider<Dio>((ref) {
  return ApiService.create();
});

class ApiService {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Credentials.apiHost,
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
