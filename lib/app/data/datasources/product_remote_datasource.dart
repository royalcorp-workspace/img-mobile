import 'package:flutter/foundation.dart';
import 'package:img/app/core/network/dio_network.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/models/paginated_model.dart';
import 'package:img/app/data/models/product_by_id_model.dart';
import 'package:img/app/data/models/product_model.dart';
import 'package:img/app/data/models/product_tag_model.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/product_by_id_entity.dart';
import 'package:img/app/domain/entities/product_entity.dart';
import 'package:img/app/domain/entities/product_tag_entity.dart';

abstract class ProductRemoteDataSource {
  Future<PaginatedEntity<ProductEntity>> getProducts({
    int page = 1,
    int itemsPerPage = 10,
    String? categoryId,
    String? search,
    String? tagId,
  });
  Future<List<ProductTagEntity>> getProductTags();
  Future<ProductByIdEntity> getProductByID(String productID);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<PaginatedEntity<ProductEntity>> getProducts({
    int page = 1,
    int itemsPerPage = 10,
    String? categoryId,
    String? search,
    String? tagId,
  }) async {
    logger.info(
        '🔍 [PRODUCT-DS] Fetching products: page=$page, itemsPerPage=$itemsPerPage, categoryId=$categoryId, search=$search, tagId=$tagId');
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'items_per_page': itemsPerPage,
      };
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParameters['category_id'] = categoryId;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (tagId != null && tagId.isNotEmpty) {
        queryParameters['tag_id'] = tagId;
      }

      final response = await DioNetwork.appAPI.get(
        '/products/',
        queryParameters: queryParameters,
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
  Future<List<ProductTagEntity>> getProductTags() async {
    logger.info('🔍 [PRODUCT-DS] Fetching product tags');
    try {
      final response = await DioNetwork.appAPI.get('/products/tags');

      if (response.statusCode != null && response.statusCode! < 300) {
        final List listData = response.data is List
            ? response.data as List
            : (response.data is Map && response.data['data'] is List
                ? response.data['data'] as List
                : []);
        return listData
            .map((json) =>
                ProductTagModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load product tags: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [PRODUCT-DS] Error fetching/parsing product tags: $e');
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
