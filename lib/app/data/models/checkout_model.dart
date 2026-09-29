import 'package:img/app/domain/entities/checkout_entity.dart';

class CheckoutModel extends CheckoutEntity {
  CheckoutModel({
    required super.success,
    required super.payment,
    required super.redirectUrl,
    required super.vaNumber,
    required super.vaExpired,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
        success: json["success"],
        payment: json["payment"] == null
            ? null
            : PaymentModel.fromJson(json["payment"]),
        redirectUrl: json["redirect_url"],
        vaNumber: json["va_number"],
        vaExpired: json["va_expired"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "payment": payment?.toJson(),
        "redirect_url": redirectUrl,
        "va_number": vaNumber,
        "va_expired": vaExpired,
      };
}

class PaymentModel extends PaymentEntity {
  PaymentModel({
    required super.rqUuid,
    required super.rsDatetime,
    required super.errorCode,
    required super.errorMessage,
    required super.vaNumber,
    required super.expired,
    required super.description,
    required super.totalAmount,
    required super.amount,
    required super.fee,
    required super.bankCode,
    required super.orderId,
    required super.orderNumber,
    required super.paymentMethod,
    required super.bankName,
    required super.type,
    required super.typeName,
    required super.status,
    required super.reference,
    required super.paymentUrl,
    required super.caraBayar,
    required super.paymentMethodDetail,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        rqUuid: json["rq_uuid"]?.toString() ?? '',
        rsDatetime: json["rs_datetime"]?.toString() ?? '',
        errorCode: json["error_code"]?.toString() ?? '',
        errorMessage: json["error_message"]?.toString() ?? '',
        vaNumber: json["va_number"]?.toString() ?? '',
        expired: json["expired"]?.toString() ?? '',
        description: json["description"]?.toString() ?? '',
        totalAmount: json["total_amount"]?.toString() ?? '',
        amount: (json["amount"] as num?)?.toDouble() ?? 0.0,
        fee: json["fee"]?.toString() ?? '0.00',
        bankCode: json["bank_code"]?.toString() ?? '',
        orderId: json["order_id"]?.toString() ?? '',
        orderNumber: json["order_number"]?.toString() ?? '',
        paymentMethod: json["payment_method"]?.toString() ?? '',
        bankName: json["bank_name"]?.toString() ?? '',
        type: (json["type"] as num?)?.toInt() ?? 0,
        typeName: json["type_name"]?.toString() ?? '',
        status: json["status"]?.toString() ?? '',
        reference: json["reference"]?.toString() ?? '',
        paymentUrl: json["payment_url"]?.toString() ?? '',
        caraBayar: json["cara_bayar"] == null
            ? <String>[]
            : List<String>.from(json["cara_bayar"].map((x) => x.toString())),
        paymentMethodDetail: json["payment_method_detail"] == null
            ? PaymentMethodDetailModel(
                id: '',
                code: '',
                name: '',
                type: 0,
                typeName: '',
                bankName: '',
                provider: '',
                image: null,
                hasCharge: false,
                chargeType: 0,
                chargeValue: 0,
                chargeBearer: null,
                minimumAmount: null,
                maximumAmount: null,
                bankInfo: BankInfoModel(bankCode: ''),
                instructions: null,
                caraBayar: const [],
              )
            : PaymentMethodDetailModel.fromJson(json["payment_method_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "rq_uuid": rqUuid,
        "rs_datetime": rsDatetime,
        "error_code": errorCode,
        "error_message": errorMessage,
        "va_number": vaNumber,
        "expired": expired,
        "description": description,
        "total_amount": totalAmount,
        "amount": amount,
        "fee": fee,
        "bank_code": bankCode,
        "order_id": orderId,
        "order_number": orderNumber,
        "payment_method": paymentMethod,
        "bank_name": bankName,
        "type": type,
        "type_name": typeName,
        "status": status,
        "reference": reference,
        "payment_url": paymentUrl,
        "cara_bayar": List<dynamic>.from(caraBayar.map((x) => x)),
        "payment_method_detail": paymentMethodDetail.toJson(),
      };
}

class PaymentMethodDetailModel extends PaymentMethodDetailEntity {
  PaymentMethodDetailModel({
    required super.id,
    required super.code,
    required super.name,
    required super.type,
    required super.typeName,
    required super.bankName,
    required super.provider,
    required super.image,
    required super.hasCharge,
    required super.chargeType,
    required super.chargeValue,
    required super.chargeBearer,
    required super.minimumAmount,
    required super.maximumAmount,
    required super.bankInfo,
    required super.instructions,
    required super.caraBayar,
  });

  factory PaymentMethodDetailModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDetailModel(
        id: json["id"]?.toString() ?? '',
        code: json["code"]?.toString() ?? '',
        name: json["name"]?.toString() ?? '',
        type: (json["type"] as num?)?.toInt() ?? 0,
        typeName: json["type_name"]?.toString() ?? '',
        bankName: json["bank_name"]?.toString() ?? '',
        provider: json["provider"]?.toString() ?? '',
        image: json["image"],
        hasCharge: json["has_charge"] ?? false,
        chargeType: (json["charge_type"] as num?)?.toInt() ?? 0,
        chargeValue: (json["charge_value"] as num?)?.toDouble() ?? 0.0,
        chargeBearer: json["charge_bearer"],
        minimumAmount: json["minimum_amount"],
        maximumAmount: json["maximum_amount"],
        bankInfo: json["bank_info"] == null
            ? BankInfoModel(bankCode: '')
            : BankInfoModel.fromJson(json["bank_info"]),
        instructions: json["instructions"],
        caraBayar: json["cara_bayar"] == null
            ? <String>[]
            : List<String>.from(json["cara_bayar"].map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "type": type,
        "type_name": typeName,
        "bank_name": bankName,
        "provider": provider,
        "image": image,
        "has_charge": hasCharge,
        "charge_type": chargeType,
        "charge_value": chargeValue,
        "charge_bearer": chargeBearer,
        "minimum_amount": minimumAmount,
        "maximum_amount": maximumAmount,
        "bank_info": bankInfo.toJson(),
        "instructions": instructions,
        "cara_bayar": List<dynamic>.from(caraBayar.map((x) => x)),
      };
}

class BankInfoModel extends BankInfoEntity {
  BankInfoModel({required super.bankCode});

  factory BankInfoModel.fromJson(Map<String, dynamic> json) => BankInfoModel(
        bankCode: json["bank_code"],
      );

  Map<String, dynamic> toJson() => {
        "bank_code": bankCode,
      };
}
