import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/entities/shipping_addresses_entity.dart';
import 'package:pos_royal/app/domain/repositories/shipping_addresses_repository.dart';

class GetShippingAddressesUsecase {
  final ShippingAddressesRepository repository;

  GetShippingAddressesUsecase(this.repository);

  Future<PaginatedEntity<ShippingAddressesEntity>> call({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getShippingAddresses(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
