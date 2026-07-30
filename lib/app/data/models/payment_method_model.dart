import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  PaymentMethodModel({
    required super.createdAt,
    required super.updatedAt,
    required super.code,
    required super.name,
    required super.type,
    required super.provider,
    required super.image,
    required super.hasCharge,
    required super.chargeType,
    required super.chargeValue,
    required super.chargeBearer,
    required super.minimumAmount,
    required super.maximumAmount,
    required super.sortOrder,
    required super.status,
    required super.bankInfo,
    required super.id,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        code: json["code"],
        name: json["name"],
        type: json["type"],
        provider: json["provider"],
        image: json["image"],
        hasCharge: json["has_charge"],
        chargeType: json["charge_type"],
        chargeValue: json["charge_value"]?.toDouble(),
        chargeBearer: json["charge_bearer"],
        minimumAmount: json["minimum_amount"],
        maximumAmount: json["maximum_amount"],
        sortOrder: json["sort_order"],
        status: json["status"],
        bankInfo: json["bank_info"] == null
            ? []
            : List<BankInfoModel>.from(
                json["bank_info"]!.map((x) => BankInfoModel.fromJson(x))),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "updated_at": updatedAt,
        "code": code,
        "name": name,
        "type": type,
        "provider": provider,
        "image": image,
        "has_charge": hasCharge,
        "charge_type": chargeType,
        "charge_value": chargeValue,
        "charge_bearer": chargeBearer,
        "minimum_amount": minimumAmount,
        "maximum_amount": maximumAmount,
        "sort_order": sortOrder,
        "status": status,
        "bank_info": bankInfo == null
            ? []
            : List<dynamic>.from(bankInfo!.map((x) => x.toJson())),
        "id": id,
      };
}

class BankInfoModel extends BankInfoEntity {
  BankInfoModel(
      {required super.bankName,
      required super.accountHolder,
      required super.accountNumber});

  factory BankInfoModel.fromJson(Map<String, dynamic> json) => BankInfoModel(
        bankName: json["bank_name"],
        accountHolder: json["account_holder"],
        accountNumber: json["account_number"],
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "account_holder": accountHolder,
        "account_number": accountNumber,
      };
}
