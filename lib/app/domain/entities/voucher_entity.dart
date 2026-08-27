class VoucherEntity {
  final String code;
  final String title;
  final String description;
  final String type;
  final String scope;
  final bool allowStacking;
  final double value;
  final double minPurchase;
  final double? maxDiscount;
  final int usageLimit;
  final int usageLimitPerUser;
  final int usedCount;
  final String startDate;
  final String endDate;
  final bool validForNewCustomer;
  final bool isActive;
  final String id;

  VoucherEntity({
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.scope,
    required this.allowStacking,
    required this.value,
    required this.minPurchase,
    required this.maxDiscount,
    required this.usageLimit,
    required this.usageLimitPerUser,
    required this.usedCount,
    required this.startDate,
    required this.endDate,
    required this.validForNewCustomer,
    required this.isActive,
    required this.id,
  });
}
