import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/payment_method_entity.dart';

import '../../domain/repositories/payment_method_repository.dart';
import '../datasources/payment_method_remote_datasource.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodRemoteDatasource remoteDataSource;

  PaymentMethodRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedEntity<PaymentMethodEntity>> getPaymentMethod({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return remoteDataSource.getPaymentMethod(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
