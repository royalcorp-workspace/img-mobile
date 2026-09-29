class OrderTrackingEntity {
  final String orderId;
  final String orderNumber;
  final int status;
  final String statusLabel;
  final String currentStatus;
  final String currentStatusRaw;
  final String currentStatusIcon;
  final String? trackingNumber;
  final String? waybillId;
  final String? courierCode;
  final String? courierName;
  final String? courier;
  final String? voucher;
  final String? voucherCode;
  final double voucherNominal;
  final double shippingCost;
  final double shippingCostSubsidy;
  final String? estimatedDeliveryAt;
  final String? estimatedDeliveryMin;
  final String? estimatedDeliveryMax;
  final String? estimatedDeliveryDuration;
  final String? etaSource;
  final String? etaNotes;
  final String? etaLabel;
  final List<OrderTrackingItemEntity> items;
  final List<OrderTrackingEventEntity> events;
  final Map<String, dynamic>? latestPayload;
  final Map<String, dynamic>? payload;

  OrderTrackingEntity({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.currentStatus,
    required this.currentStatusRaw,
    required this.currentStatusIcon,
    this.trackingNumber,
    this.waybillId,
    this.courierCode,
    this.courierName,
    this.courier,
    this.voucher,
    this.voucherCode,
    required this.voucherNominal,
    required this.shippingCost,
    required this.shippingCostSubsidy,
    this.estimatedDeliveryAt,
    this.estimatedDeliveryMin,
    this.estimatedDeliveryMax,
    this.estimatedDeliveryDuration,
    this.etaSource,
    this.etaNotes,
    this.etaLabel,
    required this.items,
    required this.events,
    this.latestPayload,
    this.payload,
  });
}

class OrderTrackingItemEntity {
  final String id;
  final String productId;
  final String productName;
  final String productVariantId;
  final String variantName;
  final String sku;
  final int quantity;
  final double basePrice;
  final double originalPrice;
  final double sellPrice;
  final String? adjustmentType;
  final double adjustmentValue;
  final double adjustmentAmount;
  final double finalPrice;
  final double unitPrice;
  final double discountNominal;
  final double discountPercent;
  final bool hasAdjustment;
  final double total;
  final String thumbnail;
  final String? itemNotes;
  final Map<String, dynamic>? meta;
  final OrderTrackingProductEntity? product;
  final OrderTrackingVariantEntity? variant;

  OrderTrackingItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productVariantId,
    required this.variantName,
    required this.sku,
    required this.quantity,
    required this.basePrice,
    required this.originalPrice,
    required this.sellPrice,
    this.adjustmentType,
    required this.adjustmentValue,
    required this.adjustmentAmount,
    required this.finalPrice,
    required this.unitPrice,
    required this.discountNominal,
    required this.discountPercent,
    required this.hasAdjustment,
    required this.total,
    required this.thumbnail,
    this.itemNotes,
    this.meta,
    this.product,
    this.variant,
  });
}

class OrderTrackingProductEntity {
  final String id;
  final String name;
  final String slug;
  final String code;
  final String thumbnail;

  OrderTrackingProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.code,
    required this.thumbnail,
  });
}

class OrderTrackingVariantEntity {
  final String id;
  final String variantName;
  final String sku;
  final double basePrice;
  final double originalPrice;
  final double sellPrice;
  final String? adjustmentType;
  final double adjustmentValue;
  final double adjustmentAmount;
  final double finalPrice;
  final bool hasAdjustment;

  OrderTrackingVariantEntity({
    required this.id,
    required this.variantName,
    required this.sku,
    required this.basePrice,
    required this.originalPrice,
    required this.sellPrice,
    this.adjustmentType,
    required this.adjustmentValue,
    required this.adjustmentAmount,
    required this.finalPrice,
    required this.hasAdjustment,
  });
}

class OrderTrackingEventEntity {
  final String stage;
  final String status;
  final String rawStatus;
  final String event;
  final String icon;
  final String location;
  final String description;
  final String createdAt;
  final int weight;

  OrderTrackingEventEntity({
    required this.stage,
    required this.status,
    required this.rawStatus,
    required this.event,
    required this.icon,
    required this.location,
    required this.description,
    required this.createdAt,
    required this.weight,
  });
}
