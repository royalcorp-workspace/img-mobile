import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/shipping_addresses_entity.dart';

abstract class ShippingAddressesRepository {
  Future<PaginatedEntity<ShippingAddressesEntity>> getShippingAddresses({
    int page = 1,
    int itemsPerPage = 10,
  });
}
