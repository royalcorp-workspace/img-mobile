import 'package:flutter/foundation.dart';
import 'package:img/app/core/network/dio_network.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/models/paginated_model.dart';
import 'package:img/app/data/models/voucher_model.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/voucher_entity.dart';

abstract class VoucherRemoteDataSource {
  Future<PaginatedEntity<VoucherEntity>> getVouchers({
    int page = 1,
    int itemsPerPage = 10,
  });
}

class VoucherRemoteDataSourceImpl implements VoucherRemoteDataSource {
  @override
  Future<PaginatedEntity<VoucherEntity>> getVouchers(
      {int page = 1, int itemsPerPage = 10}) async {
    logger.info(
        '🔍 [Voucher-DS] Fetching Vouchers: page=$page, itemsPerPage=$itemsPerPage');
    try {
      final response = await DioNetwork.appAPI.get(
        '/vouchers/',
        queryParameters: {
          'page': page,
          'items_per_page': itemsPerPage,
        },
      );

      if (response.statusCode != null && response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PaginatedModel<VoucherEntity>.fromJson(
          data,
          (json) => VoucherModel.fromJson(json),
        );
      } else {
        throw Exception(
            'Failed to load Vouchers: status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [Voucher-DS] Error fetching/parsing Vouchers: $e');
      if (kDebugMode) {
        print('❌ [Voucher-DS] Error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }
}
