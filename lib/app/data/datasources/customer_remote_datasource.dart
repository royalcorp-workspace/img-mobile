import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/customer_model.dart';
import 'package:pos_royal/app/data/models/customer_update_request.dart';
import 'package:pos_royal/app/data/models/primary_address_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerModel> getCustomer(String customerId);
  Future<CustomerModel> updateCustomer(
    String customerId,
    CustomerUpdateRequest request,
  );
  Future<PrimaryAddressModel> setPrimaryAddress(
    String customerId,
    String addressId,
  );
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  @override
  Future<CustomerModel> getCustomer(String customerId) async {
    logger.info('🔍 [CUSTOMER-DS] Fetching customer: $customerId');
    try {
      final response = await DioNetwork.appAPI.get('/customers/$customerId');

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return CustomerModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load customer: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [CUSTOMER-DS] Error fetching customer: $e');
      if (kDebugMode) {
        print('❌ [CUSTOMER-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  @override
  Future<CustomerModel> updateCustomer(
    String customerId,
    CustomerUpdateRequest request,
  ) async {
    logger.info('🔍 [CUSTOMER-DS] Updating customer: $customerId');
    try {
      final response = await DioNetwork.appAPI.put(
        '/customers/$customerId',
        data: request.toJson(),
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return CustomerModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to update customer: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [CUSTOMER-DS] Error updating customer: $e');
      if (kDebugMode) {
        print('❌ [CUSTOMER-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  @override
  Future<PrimaryAddressModel> setPrimaryAddress(
      String customerId, String addressId) async {
    logger.info(
        '🔍 [SET PRIMARY ADDRESS-DS] Updating customer and address id: $customerId & $addressId');
    try {
      final response = await DioNetwork.appAPI.patch(
        '/customers/$customerId/addresses/$addressId/primary',
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PrimaryAddressModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to update customer: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe(
          '❌ [SET PRIMARY ADDRESS-DS] Error updating primary address: $e');
      if (kDebugMode) {
        print('❌ [SET PRIMARY ADDRESS-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
