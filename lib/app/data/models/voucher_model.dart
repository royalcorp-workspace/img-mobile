import 'package:pos_royal/app/domain/entities/voucher_entity.dart';

class VoucherModel extends VoucherEntity {
  VoucherModel({
    required super.code,
    required super.title,
    required super.description,
    required super.type,
    required super.scope,
    required super.allowStacking,
    required super.value,
    required super.minPurchase,
    required super.maxDiscount,
    required super.usageLimit,
    required super.usageLimitPerUser,
    required super.usedCount,
    required super.startDate,
    required super.endDate,
    required super.validForNewCustomer,
    required super.isActive,
    required super.id,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
        code: json["code"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        scope: json["scope"],
        allowStacking: json["allow_stacking"],
        value: json["value"],
        minPurchase: json["min_purchase"],
        maxDiscount: json["max_discount"],
        usageLimit: json["usage_limit"],
        usageLimitPerUser: json["usage_limit_per_user"],
        usedCount: json["used_count"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        validForNewCustomer: json["valid_for_new_customer"],
        isActive: json["is_active"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "title": title,
        "description": description,
        "type": type,
        "scope": scope,
        "allow_stacking": allowStacking,
        "value": value,
        "min_purchase": minPurchase,
        "max_discount": maxDiscount,
        "usage_limit": usageLimit,
        "usage_limit_per_user": usageLimitPerUser,
        "used_count": usedCount,
        "start_date": startDate,
        "end_date": endDate,
        "valid_for_new_customer": validForNewCustomer,
        "is_active": isActive,
        "id": id,
      };
}
