class PaymentMethodEntity {
  final String? createdAt;
  final String? updatedAt;
  final String? code;
  final String? name;
  final int? type;
  final String? provider;
  final String? image;
  final bool? hasCharge;
  final int? chargeType;
  final double? chargeValue;
  final String? chargeBearer;
  final double? minimumAmount;
  final double? maximumAmount;
  final int? sortOrder;
  final int? status;
  final BankInfoEntity? bankInfo;
  final String? id;

  PaymentMethodEntity({
    this.createdAt,
    this.updatedAt,
    this.code,
    this.name,
    this.type,
    this.provider,
    this.image,
    this.hasCharge,
    this.chargeType,
    this.chargeValue,
    this.chargeBearer,
    this.minimumAmount,
    this.maximumAmount,
    this.sortOrder,
    this.status,
    this.bankInfo,
    this.id,
  });
}

class BankInfoEntity {
  final String? bankCode;
  final String? bankName;
  final String? accountHolder;
  final String? accountNumber;

  BankInfoEntity({
    this.bankCode,
    this.bankName,
    this.accountHolder,
    this.accountNumber,
  });
}
