import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/voucher_entity.dart';
import 'package:img/app/domain/repositories/voucher_repository.dart';

class GetVoucherUsecase {
  final VoucherRepository repository;

  GetVoucherUsecase(this.repository);

  Future<PaginatedEntity<VoucherEntity>> call({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getVouchers(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
