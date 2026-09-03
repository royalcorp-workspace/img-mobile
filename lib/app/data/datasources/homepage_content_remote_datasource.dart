import 'package:flutter/foundation.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/models/homepage_content_model.dart';
import 'package:pos_royal/app/data/models/paginated_model.dart';
import 'package:pos_royal/app/domain/entities/homepage_content_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';

abstract class HomepageContentRemoteDataSource {
  Future<PaginatedEntity<HomepageContentSectionEntity>> getHomepageContent();
}

class HomepageContentRemoteDataSourceImpl
    implements HomepageContentRemoteDataSource {
  @override
  Future<PaginatedEntity<HomepageContentSectionEntity>>
      getHomepageContent() async {
    try {
      final response = await DioNetwork.appAPI.get('/content/homepages');
      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<HomepageContentSectionEntity>.fromJson(
          data,
          (json) => HomepageContentSectionModel.fromJson(json),
        );
      }
      throw Exception(
          'Failed to load homepage content: status ${response.statusCode}');
    } catch (e, stackTrace) {
      logger.severe('Failed to fetch homepage content: $e');
      if (kDebugMode) print(stackTrace);
      rethrow;
    }
  }
}
