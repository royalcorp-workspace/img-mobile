import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/data/models/customer_update_request.dart';
import 'package:img/app/domain/repositories/customer_repository.dart';

class ChangePasswordUsecase {
  final CustomerRepository repository;

  ChangePasswordUsecase(this.repository);

  Future<CustomerModel> call({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    final request = CustomerUpdateRequest(
      currentPassword: currentPassword,
      oldPassword: currentPassword,
      password: newPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
      passwordConfirmation: confirmPassword,
    );
    return repository.updateCustomerProfile(request);
  }
}
