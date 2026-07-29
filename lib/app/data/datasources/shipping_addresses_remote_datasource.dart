import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/shipping_addresses_model.dart';

abstract class ShippingAddressesRemoteDatasource {
  Future<ShippingAddressesPaginatedModel> getShippingAddresses({
    int page = 1,
    int itemsPerPage = 10,
  });
}

class ShippingAddressesRemoteDatasourceImpl
    implements ShippingAddressesRemoteDatasource {
  @override
  Future<ShippingAddressesPaginatedModel> getShippingAddresses({
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    logger.info(
        '🔍 [SHIPPING-AD] Fetching shipping: page=$page, itemsPerPage=$itemsPerPage');
    try {
      final response = await DioNetwork.appAPI.get(
        '/couriers/shipping-addresses/',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return ShippingAddressesPaginatedModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load products: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [SHIPPING-AD] Error fetching/parsing shipping: $e');
      if (kDebugMode) {
        print('❌ [SHIPPING-AD] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
