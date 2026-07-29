import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';
import 'package:pos_royal/app/domain/repositories/payment_method_repository.dart';

class GetPaymentMethodsUsecase {
  final PaymentMethodRepository repository;

  GetPaymentMethodsUsecase(this.repository);

  Future<PaymentMethodPaginatedEntity> call({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getPaymentMethod(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
