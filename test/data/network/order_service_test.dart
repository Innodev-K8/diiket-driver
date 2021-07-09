import 'package:diiket_models/all.dart';
import 'package:driver/data/network/api_service.dart';
import 'package:driver/data/network/auth_service.dart';
import 'package:driver/data/network/order_service.dart';
import 'package:driver/data/secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

void main() {
  late Dio dio;

  late AuthService authService;
  late OrderService orderService;

  setUpAll(() async {
    dio = ApiService.create();

    authService = AuthService(dio);
    orderService = OrderService(dio);

    final response =
        await authService.loginWithEmailPassword('pak@eko.com', 'eko123');

    await SecureStorage.setToken(response.token!);
  });

  test('it should get all available orders', () async {
    // act
    final order = await orderService.getAvailableOrders();

    // assert
    expect(order, isA<List<Order>>());
  });

  test('it should not get active order', () async {
    // assert
    expect(
      () async => await orderService.getActiveOrder(),
      throwsA(const TypeMatcher<CustomException>()),
    );
  });

  test('it should get active order', () async {
    // act

    await orderService.getActiveOrder();

    // assert
    expect(
      () async => await orderService.getActiveOrder(),
      throwsA(const TypeMatcher<CustomException>()),
    );
  });
}
