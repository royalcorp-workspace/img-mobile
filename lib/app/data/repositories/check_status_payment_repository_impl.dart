import 'package:img/app/data/datasources/check_status_payment_remote_datasource.dart';
import 'package:img/app/domain/entities/check_status_entity.dart';
import 'package:img/app/domain/repositories/check_status_paymentrepository.dart';

class CheckStatusPaymentRepositoryImpl implements CheckStatusPaymentRepository {
  final CheckStatusPaymentRemoteDataSource remoteDataSource;

  CheckStatusPaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CheckStatusPaymentEntity> checkStatusPayment(String orderID) {
    return remoteDataSource.checkStatusPayment(orderID);
  }
}
