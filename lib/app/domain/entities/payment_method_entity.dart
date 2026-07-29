import 'package:pos_royal/app/data/models/payment_method_model.dart';

class PaymentMethodPaginatedEntity {
  final List<PaymentMethodModel> data;
  final int totalCount;
  final bool hasMore;
  final int page;
  final int itemsPerPage;

  PaymentMethodPaginatedEntity({
    required this.data,
    required this.totalCount,
    required this.hasMore,
    required this.page,
    required this.itemsPerPage,
  });
}

class PaymentMethodEntity {
  final String createdAt;
  final String updatedAt;
  final String code;
  final String name;
  final int type;
  final String provider;
  final String? image;
  final bool hasCharge;
  final int? chargeType;
  final double? chargeValue;
  final dynamic chargeBearer;
  final double minimumAmount;
  final dynamic maximumAmount;
  final int sortOrder;
  final int status;
  final List<BankInfoModel>? bankInfo;
  final String id;

  PaymentMethodEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.code,
    required this.name,
    required this.type,
    required this.provider,
    required this.image,
    required this.hasCharge,
    required this.chargeType,
    required this.chargeValue,
    required this.chargeBearer,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.sortOrder,
    required this.status,
    required this.bankInfo,
    required this.id,
  });
}

class BankInfoEntity {
  final String bankName;
  final String accountHolder;
  final String accountNumber;

  BankInfoEntity({
    required this.bankName,
    required this.accountHolder,
    required this.accountNumber,
  });
}
