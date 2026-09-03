import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/check_status_payment_model.dart';
import 'package:pos_royal/app/domain/entities/check_status_entity.dart';

abstract class CheckStatusPaymentRemoteDataSource {
  Future<CheckStatusPaymentEntity> checkStatusPayment(String orderID);
}

class CheckStatusPaymentRemoteDataSourceImpl
    implements CheckStatusPaymentRemoteDataSource {
  @override
  Future<CheckStatusPaymentEntity> checkStatusPayment(String orderID) async {
    logger.info(
        '🔍 [CHECK STATUS PAYMENT-DS] Fetching check status payment by orderID: $orderID');
    try {
      final response = await DioNetwork.appAPI.get(
        '/payment/espay/status/$orderID',
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return CheckStatusPaymentModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load CHECK-STATUS-PAYMENTs: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe(
          '❌ [CHECK-STATUS-PAYMENT-DS] Error fetching/parsing CHECK-STATUS-PAYMENTs: $e');
      if (kDebugMode) {
        print('❌ [CHECK-STATUS-PAYMENT-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
