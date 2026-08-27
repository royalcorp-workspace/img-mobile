import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/entities/voucher_entity.dart';

abstract class VoucherRepository {
  Future<PaginatedEntity<VoucherEntity>> getVouchers({
    int page = 1,
    int itemsPerPage = 10,
  });
}
