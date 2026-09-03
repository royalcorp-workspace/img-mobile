import 'package:pos_royal/app/data/models/customer_model.dart';
import 'package:pos_royal/app/data/models/customer_update_request.dart';
import 'package:pos_royal/app/domain/repositories/customer_repository.dart';

class AddAddressUsecase {
  final CustomerRepository repository;

  AddAddressUsecase(this.repository);

  Future<CustomerModel> call({
    required String customerId,
    required CustomerUpdateRequest request,
  }) {
    return repository.updateCustomer(
      customerId: customerId,
      request: request,
    );
  }
}
