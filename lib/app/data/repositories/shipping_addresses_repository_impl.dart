import 'package:pos_royal/app/data/datasources/shipping_addresses_remote_datasource.dart';
import 'package:pos_royal/app/domain/entities/shipping_addresses_entity.dart';
import 'package:pos_royal/app/domain/repositories/shipping_addresses_repository.dart';

class ShippingAddressesRepositoryImpl implements ShippingAddressesRepository {
  final ShippingAddressesRemoteDatasource remoteDataSource;

  ShippingAddressesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ShippingAddressesPaginatedEntity> getShippingAddresses({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return remoteDataSource.getShippingAddresses(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
