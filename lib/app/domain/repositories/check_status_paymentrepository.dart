import 'package:pos_royal/app/domain/entities/check_status_entity.dart';

abstract class CheckStatusPaymentRepository {
  Future<CheckStatusPaymentEntity> checkStatusPayment(String orderID);
}
