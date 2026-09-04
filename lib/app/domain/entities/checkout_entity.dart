import 'package:img/app/data/models/checkout_model.dart';

class CheckoutEntity {
  final bool? success;
  final PaymentModel? payment;
  final String? redirectUrl;
  final String? vaNumber;
  final String? vaExpired;

  CheckoutEntity({
    this.success,
    this.payment,
    this.redirectUrl,
    this.vaNumber,
    this.vaExpired,
  });
}

class PaymentEntity {
  final String rqUuid;
  final String rsDatetime;
  final String errorCode;
  final String errorMessage;
  final String vaNumber;
  final String expired;
  final String description;
  final String totalAmount;
  final double amount;
  final String fee;
  final String bankCode;
  final String orderId;
  final String orderNumber;
  final String paymentMethod;
  final String bankName;
  final int type;
  final String typeName;
  final String status;
  final String reference;
  final String paymentUrl;
  final List<String> caraBayar;
  final PaymentMethodDetailModel paymentMethodDetail;

  PaymentEntity({
    required this.rqUuid,
    required this.rsDatetime,
    required this.errorCode,
    required this.errorMessage,
    required this.vaNumber,
    required this.expired,
    required this.description,
    required this.totalAmount,
    required this.amount,
    required this.fee,
    required this.bankCode,
    required this.orderId,
    required this.orderNumber,
    required this.paymentMethod,
    required this.bankName,
    required this.type,
    required this.typeName,
    required this.status,
    required this.reference,
    required this.paymentUrl,
    required this.caraBayar,
    required this.paymentMethodDetail,
  });
}

class PaymentMethodDetailEntity {
  final String id;
  final String code;
  final String name;
  final int type;
  final String typeName;
  final String bankName;
  final String provider;
  final dynamic image;
  final bool hasCharge;
  final int chargeType;
  final double chargeValue;
  final dynamic chargeBearer;
  final dynamic minimumAmount;
  final dynamic maximumAmount;
  final BankInfoModel bankInfo;
  final dynamic instructions;
  final List<String> caraBayar;

  PaymentMethodDetailEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.typeName,
    required this.bankName,
    required this.provider,
    required this.image,
    required this.hasCharge,
    required this.chargeType,
    required this.chargeValue,
    required this.chargeBearer,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.bankInfo,
    required this.instructions,
    required this.caraBayar,
  });
}

class BankInfoEntity {
  final String bankCode;

  BankInfoEntity({
    required this.bankCode,
  });
}
