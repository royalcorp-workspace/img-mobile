import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';

abstract class PaymentMethodRepository {
  Future<PaymentMethodPaginatedEntity> getPaymentMethod({
    int page = 1,
    int itemsPerPage = 10,
  });
}
