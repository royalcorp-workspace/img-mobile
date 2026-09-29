import '../../domain/entities/order_tracking_entity.dart';

double _parseDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  if (val is String) {
    return double.tryParse(val) ?? 0.0;
  }
  return 0.0;
}

int _parseInt(dynamic val) {
  if (val == null) return 0;
  if (val is num) return val.toInt();
  if (val is String) {
    return int.tryParse(val) ?? (double.tryParse(val)?.toInt() ?? 0);
  }
  return 0;
}

bool _parseBool(dynamic val) {
  if (val == null) return false;
  if (val is bool) return val;
  if (val is num) return val == 1;
  if (val is String) {
    return val == '1' || val.toLowerCase() == 'true';
  }
  return false;
}

String _parseString(dynamic val) {
  if (val == null) return '';
  return val.toString();
}

Map<String, dynamic>? _parseMap(dynamic val) {
  if (val is Map) return Map<String, dynamic>.from(val);
  return null;
}

class OrderTrackingModel extends OrderTrackingEntity {
  OrderTrackingModel({
    required super.orderId,
    required super.orderNumber,
    required super.status,
    required super.statusLabel,
    required super.currentStatus,
    required super.currentStatusRaw,
    required super.currentStatusIcon,
    super.trackingNumber,
    super.waybillId,
    super.courierCode,
    super.courierName,
    super.courier,
    super.voucher,
    super.voucherCode,
    required super.voucherNominal,
    required super.shippingCost,
    required super.shippingCostSubsidy,
    super.estimatedDeliveryAt,
    super.estimatedDeliveryMin,
    super.estimatedDeliveryMax,
    super.estimatedDeliveryDuration,
    super.etaSource,
    super.etaNotes,
    super.etaLabel,
    required super.items,
    required super.events,
    super.latestPayload,
    super.payload,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      orderId: _parseString(json['order_id']),
      orderNumber: _parseString(json['order_number']),
      status: _parseInt(json['status']),
      statusLabel: _parseString(json['status_label']),
      currentStatus: _parseString(json['current_status']),
      currentStatusRaw: _parseString(json['current_status_raw']),
      currentStatusIcon: _parseString(json['current_status_icon']),
      trackingNumber: json['tracking_number']?.toString(),
      waybillId: json['waybill_id']?.toString(),
      courierCode: json['courier_code']?.toString(),
      courierName: json['courier_name']?.toString(),
      courier: json['courier']?.toString(),
      voucher: json['voucher']?.toString(),
      voucherCode: json['voucher_code']?.toString(),
      voucherNominal: _parseDouble(json['voucher_nominal']),
      shippingCost: _parseDouble(json['shipping_cost']),
      shippingCostSubsidy: _parseDouble(json['shipping_cost_subsidy']),
      estimatedDeliveryAt: json['estimated_delivery_at']?.toString(),
      estimatedDeliveryMin: json['estimated_delivery_min']?.toString(),
      estimatedDeliveryMax: json['estimated_delivery_max']?.toString(),
      estimatedDeliveryDuration: json['estimated_delivery_duration']?.toString(),
      etaSource: json['eta_source']?.toString(),
      etaNotes: json['eta_notes']?.toString(),
      etaLabel: json['eta_label']?.toString(),
      items: (json['items'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => OrderTrackingItemModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      events: (json['events'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => OrderTrackingEventModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      latestPayload: _parseMap(json['latest_payload']),
      payload: _parseMap(json['payload']),
    );
  }
}

class OrderTrackingItemModel extends OrderTrackingItemEntity {
  OrderTrackingItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productVariantId,
    required super.variantName,
    required super.sku,
    required super.quantity,
    required super.basePrice,
    required super.originalPrice,
    required super.sellPrice,
    super.adjustmentType,
    required super.adjustmentValue,
    required super.adjustmentAmount,
    required super.finalPrice,
    required super.unitPrice,
    required super.discountNominal,
    required super.discountPercent,
    required super.hasAdjustment,
    required super.total,
    required super.thumbnail,
    super.itemNotes,
    super.meta,
    super.product,
    super.variant,
  });

  factory OrderTrackingItemModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingItemModel(
      id: _parseString(json['id']),
      productId: _parseString(json['product_id']),
      productName: _parseString(json['product_name']),
      productVariantId: _parseString(json['product_variant_id']),
      variantName: _parseString(json['variant_name']),
      sku: _parseString(json['sku']),
      quantity: _parseInt(json['quantity']),
      basePrice: _parseDouble(json['base_price']),
      originalPrice: _parseDouble(json['original_price']),
      sellPrice: _parseDouble(json['sell_price']),
      adjustmentType: json['adjustment_type']?.toString(),
      adjustmentValue: _parseDouble(json['adjustment_value']),
      adjustmentAmount: _parseDouble(json['adjustment_amount']),
      finalPrice: _parseDouble(json['final_price']),
      unitPrice: _parseDouble(json['unit_price']),
      discountNominal: _parseDouble(json['discount_nominal']),
      discountPercent: _parseDouble(json['discount_percent']),
      hasAdjustment: _parseBool(json['has_adjustment']),
      total: _parseDouble(json['total']),
      thumbnail: _parseString(json['thumbnail']),
      itemNotes: json['item_notes']?.toString(),
      meta: _parseMap(json['meta']),
      product: json['product'] != null && json['product'] is Map
          ? OrderTrackingProductModel.fromJson(Map<String, dynamic>.from(json['product'] as Map))
          : null,
      variant: json['variant'] != null && json['variant'] is Map
          ? OrderTrackingVariantModel.fromJson(Map<String, dynamic>.from(json['variant'] as Map))
          : null,
    );
  }
}

class OrderTrackingProductModel extends OrderTrackingProductEntity {
  OrderTrackingProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.code,
    required super.thumbnail,
  });

  factory OrderTrackingProductModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingProductModel(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      code: _parseString(json['code']),
      thumbnail: _parseString(json['thumbnail']),
    );
  }
}

class OrderTrackingVariantModel extends OrderTrackingVariantEntity {
  OrderTrackingVariantModel({
    required super.id,
    required super.variantName,
    required super.sku,
    required super.basePrice,
    required super.originalPrice,
    required super.sellPrice,
    super.adjustmentType,
    required super.adjustmentValue,
    required super.adjustmentAmount,
    required super.finalPrice,
    required super.hasAdjustment,
  });

  factory OrderTrackingVariantModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingVariantModel(
      id: _parseString(json['id']),
      variantName: _parseString(json['variant_name']),
      sku: _parseString(json['sku']),
      basePrice: _parseDouble(json['base_price']),
      originalPrice: _parseDouble(json['original_price']),
      sellPrice: _parseDouble(json['sell_price']),
      adjustmentType: json['adjustment_type']?.toString(),
      adjustmentValue: _parseDouble(json['adjustment_value']),
      adjustmentAmount: _parseDouble(json['adjustment_amount']),
      finalPrice: _parseDouble(json['final_price']),
      hasAdjustment: _parseBool(json['has_adjustment']),
    );
  }
}

class OrderTrackingEventModel extends OrderTrackingEventEntity {
  OrderTrackingEventModel({
    required super.stage,
    required super.status,
    required super.rawStatus,
    required super.event,
    required super.icon,
    required super.location,
    required super.description,
    required super.createdAt,
    required super.weight,
  });

  factory OrderTrackingEventModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingEventModel(
      stage: _parseString(json['stage']),
      status: _parseString(json['status']),
      rawStatus: _parseString(json['raw_status']),
      event: _parseString(json['event']),
      icon: _parseString(json['icon']),
      location: _parseString(json['location']),
      description: _parseString(json['description']),
      createdAt: _parseString(json['created_at']),
      weight: _parseInt(json['weight']),
    );
  }
}
