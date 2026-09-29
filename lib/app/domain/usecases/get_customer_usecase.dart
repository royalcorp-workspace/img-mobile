import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/domain/repositories/customer_repository.dart';

class GetCustomerUsecase {
  final CustomerRepository repository;

  GetCustomerUsecase(this.repository);

  Future<CustomerModel> call(String customerId) {
    return repository.getCustomer(customerId);
  }
}
