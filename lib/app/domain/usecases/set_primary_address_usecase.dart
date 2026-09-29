import 'package:img/app/data/models/primary_address_model.dart';
import 'package:img/app/domain/repositories/customer_repository.dart';

class SetPrimaryAddressUsecase {
  final CustomerRepository repository;

  SetPrimaryAddressUsecase(this.repository);

  Future<PrimaryAddressModel> call(
    String customerId,
    String addressId,
  ) {
    return repository.setPrimaryAddress(customerId, addressId);
  }
}
