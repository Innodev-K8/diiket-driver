import 'package:diiket_models/all.dart';
import 'package:dio/dio.dart';
import 'package:driver/data/network/api_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService(ref.read(apiProvider));
});

class OrderService {
  Dio _dio;

  OrderService(this._dio);

  String _(Object path) => '/driver/orders/$path';

  Future<List<Order>> getAvailableOrders() async {
    try {
      final response = await _dio.get(_(''));

      List<dynamic> results = response.data['data'];

      return results.map((json) => Order.fromJson(json)).toList();
    } on DioError catch (error) {
      throw CustomException.fromDioError(error);
    }
  }

  Future<void> claimOrder(int orderId) async {
    try {
      await _dio.post(_('$orderId/claim'));
    } on DioError catch (error) {
      if (error.response?.statusCode == 422) {
        throw CustomException(
          message: error.response?.data['message'],
          code: 422,
        );
      }

      throw CustomException.fromDioError(error);
    }
  }

  Future<Order?> getActiveOrder() async {
    try {
      final response = await _dio.get(_('active'));

      return Order.fromJson(response.data['data']);
    } on DioError catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }

      throw CustomException.fromDioError(error);
    }
  }

  Future<void> deliverOrder() async {
    try {
      await _dio.post(_('active/deliver'));
    } on DioError catch (error) {
      throw CustomException.fromDioError(error);
    }
  }

  Future<void> completeOrder() async {
    try {
      await _dio.post(_('active/complete'));
    } on DioError catch (error) {
      throw CustomException.fromDioError(error);
    }
  }
}
