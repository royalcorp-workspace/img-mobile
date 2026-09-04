import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/data/models/product_model.dart';
import 'package:img/app/data/models/variant_model.dart';
import 'package:img/app/domain/entities/order_history_entity.dart';

class OrderHistoryModel extends OrderHistoryEntity {
  OrderHistoryModel({
    required super.id,
    required super.orderNumber,
    required super.customerId,
    required super.status,
    required super.statusLabel,
    required super.statusText,
    required super.paymentMethod,
    required super.paymentStatus,
    required super.paymentStatusLabel,
    required super.paymentStatusText,
    required super.isVoid,
    super.voidReason,
    super.voidedAt,
    required super.subtotal,
    required super.tax,
    required super.discount,
    required super.total,
    required super.shippingCost,
    required super.voucherNominal,
    required super.notes,
    required super.meta,
    required super.createdAt,
    required super.updatedAt,
    super.customer,
    required super.items,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      id: _string(json['id']),
      orderNumber: _string(json['order_number']),
      customerId: _string(json['customer_id']),
      status: _int(json['status']),
      statusLabel: _string(json['status_label']),
      statusText: _string(json['status_text']),
      paymentMethod: _string(json['payment_method']),
      paymentStatus: _int(json['payment_status']),
      paymentStatusLabel: _string(json['payment_status_label']),
      paymentStatusText: _string(json['payment_status_text']),
      isVoid: _bool(json['is_void']),
      voidReason: json['void_reason'],
      voidedAt: json['voided_at'],
      subtotal: _double(json['subtotal']),
      tax: _double(json['tax']),
      discount: _double(json['discount']),
      total: _double(json['total']),
      shippingCost: _double(json['shipping_cost']),
      voucherNominal: _double(json['voucher_nominal']),
      notes: _string(json['notes']),
      meta: _map(json['meta']),
      createdAt: _string(json['created_at']),
      updatedAt: _string(json['updated_at']),
      customer: _object(json['customer'], CustomerModel.fromJson),
      items: (json['items'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((item) =>
              OrderHistoryItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}

class OrderHistoryItemModel extends OrderHistoryItemEntity {
  OrderHistoryItemModel({
    required super.productId,
    required super.productVariantId,
    required super.quantity,
    required super.unitPrice,
    required super.discountNominal,
    required super.discountPercent,
    required super.total,
    required super.name,
    super.itemNotes,
    super.meta,
    required super.id,
    required super.orderId,
    required super.createdAt,
    required super.updatedAt,
    super.product,
    super.variant,
  });

  factory OrderHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryItemModel(
      productId: _string(json['product_id']),
      productVariantId: _string(json['product_variant_id']),
      quantity: _int(json['quantity']),
      unitPrice: _double(json['unit_price']),
      discountNominal: _double(json['discount_nominal']),
      discountPercent: _double(json['discount_percent']),
      total: _double(json['total']),
      name: _string(json['name']),
      itemNotes: json['item_notes'],
      meta: json['meta'],
      id: _string(json['id']),
      orderId: _string(json['order_id']),
      createdAt: _string(json['created_at']),
      updatedAt: _string(json['updated_at']),
      product: _object(json['product'], ProductModel.fromJson),
      variant: _object(json['variant'], VariantModel.fromJson),
    );
  }
}

String _string(dynamic value) => value?.toString() ?? '';

double _double(dynamic value) => value is num
    ? value.toDouble()
    : double.tryParse(value?.toString() ?? '') ?? 0;

int _int(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

bool _bool(dynamic value) => value is bool
    ? value
    : value == 1 || value?.toString().toLowerCase() == 'true';

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

T? _object<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
  if (value is! Map) return null;
  return fromJson(Map<String, dynamic>.from(value));
}
