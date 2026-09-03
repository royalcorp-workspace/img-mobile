import 'package:pos_royal/app/domain/entities/check_status_entity.dart';

class CheckStatusPaymentModel extends CheckStatusPaymentEntity {
  CheckStatusPaymentModel({
    required super.orderId,
    required super.paymentStatus,
    required super.status,
    required super.isPaid,
  });

  factory CheckStatusPaymentModel.fromJson(Map<String, dynamic> json) =>
      CheckStatusPaymentModel(
        orderId: json["order_id"],
        paymentStatus: json["payment_status"],
        status: json["status"],
        isPaid: json["is_paid"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "payment_status": paymentStatus,
        "status": status,
        "is_paid": isPaid,
      };
}
