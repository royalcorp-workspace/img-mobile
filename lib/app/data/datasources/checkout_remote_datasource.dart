import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/checkout_model.dart';
import 'package:pos_royal/app/data/models/checkout_params_model.dart';
import 'package:pos_royal/app/domain/entities/checkout_entity.dart';

abstract class CheckoutRemoteDataSource {
  Future<CheckoutEntity> checkout(CheckoutParamsModel params);
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  @override
  Future<CheckoutEntity> checkout(CheckoutParamsModel params) async {
    print('🔍 [CHECKOUT-DS] CHECKOUT METHOD CALLED - params: $params');
    logger.info('🔍 [CHECKOUT-DS] params checkout: $params');
    try {
      final response = await DioNetwork.appAPI.post(
        '/payment/espay/checkout',
        data: params.toJson(),
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return CheckoutModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to update checkout: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [CHECKOUT-DS] Error updating checkout: $e');
      if (kDebugMode) {
        print('❌ [CHECKOUT-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
