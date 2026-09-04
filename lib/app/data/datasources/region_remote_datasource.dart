import 'package:flutter/foundation.dart';
import 'package:img/app/core/network/dio_network.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/models/city_model.dart';
import 'package:img/app/data/models/paginated_model.dart';
import 'package:img/app/data/models/provinces_model.dart';
import 'package:img/app/data/models/sub_district_model.dart';
import 'package:img/app/domain/entities/city_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/provincy_entity.dart';
import 'package:img/app/domain/entities/sub_district_entity.dart';

abstract class RegionRemoteDatasource {
  Future<PaginatedEntity<ProvincyEntity>> getProvinces({
    int page = 1,
    int itemsPerPage = 10,
  });
  Future<PaginatedEntity<CityEntity>> getCity({
    int page = 1,
    int itemsPerPage = 10,
    required String provincyID,
  });
  Future<PaginatedEntity<SubDistrictEntity>> getSubDistrict({
    int page = 1,
    int itemsPerPage = 10,
    required String cityID,
  });
}

class RegionRemoteDataSourceImpl implements RegionRemoteDatasource {
  @override
  Future<PaginatedEntity<ProvincyEntity>> getProvinces(
      {int page = 1, int itemsPerPage = 10}) async {
    logger.info(
        '🔍 [PROVINCES-DS] Fetching provinces: page=$page, itemsPerPage=$itemsPerPage');
    try {
      final response = await DioNetwork.appAPI.get(
        '/regions/provinces/',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<ProvincyEntity>.fromJson(
          data,
          (json) => ProvincesModel.fromJson(json),
        );
      } else {
        throw Exception(
            'Failed to load provinces: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [PROVINCES-DS] Error fetching/parsing provincy: $e');
      if (kDebugMode) {
        print('❌ [PROVINCES-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedEntity<CityEntity>> getCity(
      {required String provincyID, int page = 1, int itemsPerPage = 10}) async {
    logger.info('🔍 [CITY-DS] Fetching city by provincy ID: $provincyID');
    try {
      final response = await DioNetwork.appAPI.get(
        '/regions/cities',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
          'province_id': provincyID,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<CityEntity>.fromJson(
          data,
          (json) => CityModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to load City: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [CITY-DS] Error fetching/parsing City: $e');
      if (kDebugMode) {
        print('❌ [CITY-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedEntity<SubDistrictEntity>> getSubDistrict(
      {int page = 1, int itemsPerPage = 10, required String cityID}) async {
    logger.info('🔍 [DISTRICT-DS] Fetching sub district by city ID: $cityID');
    try {
      final response = await DioNetwork.appAPI.get(
        '/regions/sub-districts',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
          'city_id': cityID,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<SubDistrictEntity>.fromJson(
          data,
          (json) => SubDistrictModel.fromJson(json),
        );
      } else {
        throw Exception(
            'Failed to load Sub District: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [DISTRICT-DS] Error fetching/parsing sub district: $e');
      if (kDebugMode) {
        print('❌ [DISTRICT-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
