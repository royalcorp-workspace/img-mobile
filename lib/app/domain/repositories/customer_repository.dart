import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/data/models/customer_update_request.dart';
import 'package:img/app/data/models/primary_address_model.dart';

abstract class CustomerRepository {
  Future<CustomerModel> getCustomer(String customerId);
  Future<CustomerModel> updateCustomer({
    required String customerId,
    required CustomerUpdateRequest request,
  });
  Future<PrimaryAddressModel> setPrimaryAddress(
      String customerId, String addressId);
}
