import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/data/models/customer_update_request.dart';
import 'package:img/app/domain/repositories/customer_repository.dart';

class UpdateCustomerProfileUsecase {
  final CustomerRepository repository;

  UpdateCustomerProfileUsecase(this.repository);

  Future<CustomerModel> call(CustomerUpdateRequest request) {
    return repository.updateCustomerProfile(request);
  }
}
