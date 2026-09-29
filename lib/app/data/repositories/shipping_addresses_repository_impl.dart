import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/shipping_addresses_entity.dart';

import '../../domain/repositories/shipping_addresses_repository.dart';
import '../datasources/shipping_addresses_remote_datasource.dart';

class ShippingAddressesRepositoryImpl implements ShippingAddressesRepository {
  final ShippingAddressesRemoteDatasource remoteDataSource;

  ShippingAddressesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedEntity<ShippingAddressesEntity>> getShippingAddresses({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return remoteDataSource.getShippingAddresses(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
