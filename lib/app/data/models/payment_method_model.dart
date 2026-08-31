import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  PaymentMethodModel({
    super.createdAt,
    super.updatedAt,
    super.code,
    super.name,
    super.type,
    super.provider,
    super.image,
    super.hasCharge,
    super.chargeType,
    super.chargeValue,
    super.chargeBearer,
    super.minimumAmount,
    super.maximumAmount,
    super.sortOrder,
    super.status,
    super.bankInfo,
    super.id,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
      code: json["code"] as String?,
      name: json["name"] as String?,
      type: json["type"] as int?,
      provider: json["provider"] as String?,
      image: json["image"] as String?,
      hasCharge: json["has_charge"] as bool?,
      chargeType: json["charge_type"] as int?,
      chargeValue: json["charge_value"] != null
          ? (json["charge_value"] as num).toDouble()
          : null,
      chargeBearer: json["charge_bearer"] as String?,
      minimumAmount: json["minimum_amount"] != null
          ? (json["minimum_amount"] as num).toDouble()
          : null,
      maximumAmount: json["maximum_amount"] != null
          ? (json["maximum_amount"] as num).toDouble()
          : null,
      sortOrder: json["sort_order"] as int?,
      status: json["status"] as int?,
      bankInfo: json["bank_info"] != null
          ? BankInfoModel.fromJson(
              json["bank_info"] as Map<String, dynamic>,
            )
          : null,
      id: json["id"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "bank_info":
          bankInfo != null ? (bankInfo as BankInfoModel).toJson() : null,
      "id": id,
    };
  }
}

class BankInfoModel extends BankInfoEntity {
  BankInfoModel({
    super.bankCode,
    super.bankName,
    super.accountHolder,
    super.accountNumber,
  });

  factory BankInfoModel.fromJson(Map<String, dynamic> json) {
    return BankInfoModel(
      bankCode: json["bank_code"] as String?,
      bankName: json["bank_name"] as String?,
      accountHolder: json["account_holder"] as String?,
      accountNumber: json["account_number"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bank_code": bankCode,
      "bank_name": bankName,
      "account_holder": accountHolder,
      "account_number": accountNumber,
    };
  }
}
