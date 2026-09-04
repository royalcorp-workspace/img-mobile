import 'package:flutter/foundation.dart';
import 'package:img/app/core/network/dio_network.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/models/paginated_model.dart';
import 'package:img/app/data/models/shipping_addresses_model.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/shipping_addresses_entity.dart';

abstract class ShippingAddressesRemoteDatasource {
  Future<PaginatedEntity<ShippingAddressesEntity>> getShippingAddresses({
    int page = 1,
    int itemsPerPage = 10,
  });
}

class ShippingAddressesRemoteDatasourceImpl
    implements ShippingAddressesRemoteDatasource {
  @override
  Future<PaginatedEntity<ShippingAddressesEntity>> getShippingAddresses({
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
        return PaginatedModel<ShippingAddressesEntity>.fromJson(
          data,
          (json) => ShippingAddressesModel.fromJson(json),
        );
      } else {
        throw Exception(
            'Failed to load shipping addresses: status ${response.statusCode}');
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
