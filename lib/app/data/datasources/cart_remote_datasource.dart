import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/cart_model.dart';
import 'package:pos_royal/app/data/models/paginated_model.dart';
import 'package:pos_royal/app/domain/entities/add_to_cart_entity.dart';
import 'package:pos_royal/app/domain/entities/cart_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';

abstract class CartRemoteDataSource {
  Future<AddToCartEntity> addToCart(Map<String, dynamic> body);
  Future<PaginatedEntity<CartEntity>> getCart({
    int page = 1,
    int itemsPerPage = 10,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  @override
  Future<AddToCartEntity> addToCart(Map<String, dynamic> body) async {
    logger.info('🔍 [ADD-TO-CART-DS] Add to Cart...');
    if (kDebugMode) {
      print('🔍 [ADD-TO-CART-DS] Request Body: $body');
    }

    try {
      final response = await DioNetwork.appAPI.post(
        '/add-to-cart/',
        data: body,
      );

      logger
          .info('🔍 [ADD-TO-CART-DS] Response status: ${response.statusCode}');
      if (kDebugMode) {
        print('🔍 [ADD-TO-CART-DS] Response data: ${response.data}');
      }

      if (response.statusCode != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final Map<String, dynamic> data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return AddToCartModel.fromJson(data);
      } else {
        throw Exception('Failed to Add To Cart: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [ADD-TO-CART] Error adding to cart: $e');
      if (kDebugMode) {
        print('❌ [ADD-TO-CART-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedEntity<CartEntity>> getCart(
      {int page = 1, int itemsPerPage = 10}) async {
    logger.info(
        '🔍 [CART-DS] Fetching cart: page=$page, itemsPerPage=$itemsPerPage');
    try {
      final response = await DioNetwork.appAPI.get(
        '/add-to-cart/',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<CartEntity>.fromJson(
          data,
          (json) => CartModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to load cart: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [CART-DS] Error fetching/parsing cart: $e');
      if (kDebugMode) {
        print('❌ [CART-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
