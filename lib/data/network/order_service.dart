import 'package:diiket_models/all.dart';
import 'package:dio/dio.dart';

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
      throw CustomException.fromDioError(error);
    }
  }

  Future<Order> getActiveOrder() async {
    try {
      final response = await _dio.get(_('active'));

      return Order.fromJson(response.data);
    } on DioError catch (error) {
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
