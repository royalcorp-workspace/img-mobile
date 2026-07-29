import 'package:pos_royal/app/domain/entities/shipping_addresses_entity.dart';

abstract class ShippingAddressesRepository {
  Future<ShippingAddressesPaginatedEntity> getShippingAddresses({
    int page = 1,
    int itemsPerPage = 10,
  });
}
