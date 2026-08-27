import 'package:pos_royal/app/data/datasources/voucher_remote_datasource.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/entities/voucher_entity.dart';
import 'package:pos_royal/app/domain/repositories/voucher_repository.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDataSource remoteDataSource;

  VoucherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedEntity<VoucherEntity>> getVouchers({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return remoteDataSource.getVouchers(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
