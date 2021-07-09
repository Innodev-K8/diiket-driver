import 'package:diiket_models/all.dart';
import 'package:driver/data/network/api_service.dart';
import 'package:driver/data/network/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('it should be able to login', () async {
    // arrange
    final dio = ApiService.create();
    final service = AuthService(dio);

    // act
    final result =
        await service.loginWithEmailPassword('pak@eko.com', 'eko123');

    print(result);

    // assert
    expect(result, isA<AuthResponse>());
  });
}
