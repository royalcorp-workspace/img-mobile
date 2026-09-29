import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(Map<String, dynamic> body);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  @override
  Future<OrderModel> createOrder(Map<String, dynamic> body) async {
    logger.info('🔍 [ORDER-DS] Creating order...');
    if (kDebugMode) {
      print('🔍 [ORDER-DS] Request Body: $body');
    }

    try {
      final response = await DioNetwork.appAPI.post(
        '/orders/',
        data: body,
      );

      logger.info('🔍 [ORDER-DS] Response status: ${response.statusCode}');
      if (kDebugMode) {
        print('🔍 [ORDER-DS] Response data: ${response.data}');
      }

      if (response.statusCode != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final Map<String, dynamic> data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return OrderModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to create order: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [ORDER-DS] Error creating order: $e');
      if (kDebugMode) {
        print('❌ [ORDER-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
