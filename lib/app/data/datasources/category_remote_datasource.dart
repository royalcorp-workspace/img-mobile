import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/category_model.dart';
import 'package:pos_royal/app/data/models/paginated_model.dart';
import 'package:pos_royal/app/domain/entities/category_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';

abstract class CategoryRemoteDataSource {
  Future<PaginatedEntity<CategoryEntity>> getCategory({
    int page = 1,
    int itemsPerPage = 10,
  });
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  @override
  Future<PaginatedEntity<CategoryEntity>> getCategory({
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    logger.info(
        '🔍 [CATEGORY] Fetching categories: page=$page, itemsPerPage=$itemsPerPage');
    try {
      final response = await DioNetwork.appAPI.get(
        '/categories/',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<CategoryEntity>.fromJson(
          data,
          (json) => CategoryModel.fromJson(json),
        );
      } else {
        throw Exception(
            'Failed to load categories: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [CATEGORY METHOD] Error fetching/parsing category: $e');
      if (kDebugMode) {
        print('❌ [CATEGORY METHOD] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
