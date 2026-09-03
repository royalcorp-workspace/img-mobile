import 'package:pos_royal/app/data/models/customer_model.dart';
import 'package:pos_royal/app/domain/repositories/customer_repository.dart';

class GetCustomerUsecase {
  final CustomerRepository repository;

  GetCustomerUsecase(this.repository);

  Future<CustomerModel> call(String customerId) {
    return repository.getCustomer(customerId);
  }
}
