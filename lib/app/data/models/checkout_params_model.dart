import 'package:img/app/domain/entities/checkout_params_entity.dart';

class CheckoutParamsModel extends CheckoutParamsEntity {
  CheckoutParamsModel({
    required super.orderId,
    required super.paymentMethodCode,
  });

  factory CheckoutParamsModel.fromJson(Map<String, dynamic> json) =>
      CheckoutParamsModel(
        orderId: json["order_id"],
        paymentMethodCode: json["payment_method_code"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "payment_method_code": paymentMethodCode,
      };
}
