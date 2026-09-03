import 'package:pos_royal/app/data/datasources/customer_remote_datasource.dart';
import 'package:pos_royal/app/data/models/customer_model.dart';
import 'package:pos_royal/app/data/models/customer_update_request.dart';
import 'package:pos_royal/app/data/models/primary_address_model.dart';
import 'package:pos_royal/app/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerModel> getCustomer(String customerId) {
    return remoteDataSource.getCustomer(customerId);
  }

  @override
  Future<CustomerModel> updateCustomer({
    required String customerId,
    required CustomerUpdateRequest request,
  }) {
    return remoteDataSource.updateCustomer(customerId, request);
  }

  @override
  Future<PrimaryAddressModel> setPrimaryAddress(
      String customerId, String addressId) {
    return remoteDataSource.setPrimaryAddress(customerId, addressId);
  }
}
