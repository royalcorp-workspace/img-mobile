import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/payment_method_entity.dart';

abstract class PaymentMethodRepository {
  Future<PaginatedEntity<PaymentMethodEntity>> getPaymentMethod({
    int page = 1,
    int itemsPerPage = 10,
  });
}
