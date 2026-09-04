import 'package:img/app/domain/entities/check_status_entity.dart';

abstract class CheckStatusPaymentRepository {
  Future<CheckStatusPaymentEntity> checkStatusPayment(String orderID);
}
