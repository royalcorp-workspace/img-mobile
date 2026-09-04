import 'package:flutter/foundation.dart';
import 'package:img/app/core/network/dio_network.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/models/order_history_model.dart';
import 'package:img/app/data/models/paginated_model.dart';
import 'package:img/app/domain/entities/order_history_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(Map<String, dynamic> body);
  Future<PaginatedEntity<OrderHistoryEntity>> getOrderHistory({
    required String customerId,
    int page = 1,
    int itemsPerPage = 10,
  });
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

  @override
  Future<PaginatedEntity<OrderHistoryEntity>> getOrderHistory({
    required String customerId,
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    logger.info(
        '🔍 [ORDER HISTORY-DS] Fetching order history: page=$page, itemsPerPage=$itemsPerPage, customerId: $customerId');
    try {
      final response = await DioNetwork.appAPI.get(
        '/orders/history',
        queryParameters: {
          'customer_id': customerId,
          'page': page,
          'items_per_page': itemsPerPage,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<OrderHistoryEntity>.fromJson(
          data,
          (json) => OrderHistoryModel.fromJson(json),
        );
      } else {
        throw Exception(
            'Failed to load order history: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe(
          '❌ [ORDER HISTORY-DS] Error fetching/parsing order history: $e');
      if (kDebugMode) {
        print('❌ [ORDER HISTORY-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
