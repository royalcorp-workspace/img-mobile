import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/domain/repositories/customer_repository.dart';

class GetCustomerProfileUsecase {
  final CustomerRepository repository;

  GetCustomerProfileUsecase(this.repository);

  Future<CustomerModel> call() {
    return repository.getCustomerProfile();
  }
}
