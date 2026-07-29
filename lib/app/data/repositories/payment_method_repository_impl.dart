import 'package:pos_royal/app/data/datasources/payment_method_remote_datasource.dart';
import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';
import 'package:pos_royal/app/domain/repositories/payment_method_repository.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodRemoteDatasource remoteDataSource;

  PaymentMethodRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaymentMethodPaginatedEntity> getPaymentMethod(
      {int page = 1, int itemsPerPage = 10}) {
    return remoteDataSource.getPaymentMethod(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
