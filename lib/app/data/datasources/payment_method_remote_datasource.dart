import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/payment_method_model.dart';
import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';

abstract class PaymentMethodRemoteDatasource {
  Future<PaymentMethodPaginatedEntity> getPaymentMethod({
    int page = 1,
    int itemsPerPage = 10,
  });
}

class PaymentMethodRemoteDatasourceImpl
    implements PaymentMethodRemoteDatasource {
  @override
  Future<PaymentMethodPaginatedEntity> getPaymentMethod({
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    logger.info(
        '🔍 [PAYMENT METHOD] Fetching products: page=$page, itemsPerPage=$itemsPerPage');
    try {
      final response = await DioNetwork.appAPI.get(
        '/payment-methods/',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaymentMethodPaginatedModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load products: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe(
          '❌ [PAYMENT METHOD] Error fetching/parsing payment method: $e');
      if (kDebugMode) {
        print('❌ [PAYMENT METHOD] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
