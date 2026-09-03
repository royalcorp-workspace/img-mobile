import 'package:pos_royal/app/domain/entities/check_status_entity.dart';
import 'package:pos_royal/app/domain/repositories/check_status_paymentrepository.dart';

class CheckStatusPaymentUsecase {
  final CheckStatusPaymentRepository repository;

  CheckStatusPaymentUsecase(this.repository);

  Future<CheckStatusPaymentEntity> call(String orderID) {
    return repository.checkStatusPayment(orderID);
  }
}
