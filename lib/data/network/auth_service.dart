import 'package:diiket_models/all.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'api_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(apiProvider));
});

class AuthService {
  Dio _dio;

  AuthService(this._dio);

  String _(Object path) => '/auth/$path';

  Future<AuthResponse> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        _('login'),
        data: {
          'email': email,
          'password': password,
          'device_name': 'mobile',
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      if (authResponse.user?.type != UserType.driver) {
        throw CustomException(code: 403, message: 'Kredensial salah');
      }

      return authResponse;
    } on DioError catch (error) {
      print(error);
      throw CustomException.fromDioError(error);
    }
  }

  Future<AuthResponse> loginWithFirebaseToken(String token) async {
    try {
      final response = await _dio.post(
        _('login/firebase'),
        data: {
          'firebase_token': token,
          'device_name': 'mobile',
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      if (authResponse.user?.type != UserType.driver) {
        throw CustomException(code: 403, message: 'Kredensial salah');
      }

      return authResponse;
    } on DioError catch (error) {
      throw CustomException.fromDioError(error);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(_('logout'));
    } on DioError catch (error) {
      throw CustomException.fromDioError(error);
    }
  }

  Future<User> me() async {
    try {
      final response = await _dio.get(_('me'));

      return User.fromJson(response.data['data']);
    } on DioError catch (error) {
      throw CustomException.fromDioError(error);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      data.putIfAbsent('_method', () => 'PATCH');

      await _dio.post(_('me'), data: data);
    } on DioError catch (error) {
      throw CustomException.fromDioError(error);
    }
  }
}
