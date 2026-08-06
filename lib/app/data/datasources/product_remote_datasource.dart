import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/paginated_model.dart';
import 'package:pos_royal/app/data/models/product_by_id_model.dart';
import 'package:pos_royal/app/data/models/product_model.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';
import 'package:pos_royal/app/domain/entities/product_entity.dart';

abstract class ProductRemoteDataSource {
  Future<PaginatedEntity<ProductEntity>> getProducts({
    int page = 1,
    int itemsPerPage = 10,
  });
  Future<ProductByIdEntity> getProductByID(String productID);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<PaginatedEntity<ProductEntity>> getProducts({
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    logger.info(
        '🔍 [PRODUCT-DS] Fetching products: page=$page, itemsPerPage=$itemsPerPage');
    try {
      final response = await DioNetwork.appAPI.get(
        '/products/',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<ProductEntity>.fromJson(
          data,
          (json) => ProductModel.fromJson(json),
        );
      } else {
        throw Exception(
            'Failed to load products: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [PRODUCT-DS] Error fetching/parsing products: $e');
      if (kDebugMode) {
        print('❌ [PRODUCT-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  @override
  Future<ProductByIdEntity> getProductByID(String productID) async {
    logger.info('🔍 [PRODUCT-ID] Fetching products by ID: $productID');
    try {
      final response = await DioNetwork.appAPI.get(
        '/products/$productID',
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return ProductByIdModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load products: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [PRODUCT-ID] Error fetching/parsing products: $e');
      if (kDebugMode) {
        print('❌ [PRODUCT-ID] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
