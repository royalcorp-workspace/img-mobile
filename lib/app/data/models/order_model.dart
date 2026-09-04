import 'package:img/app/data/models/product_model.dart';
import 'package:img/app/data/models/variant_model.dart';

import '../../domain/entities/order_entity.dart';

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

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.customerId,
    required super.status,
    required super.paymentMethod,
    required super.paymentStatus,
    required super.subtotal,
    required super.tax,
    required super.discount,
    required super.total,
    super.notes,
    super.createdAt,
    super.updatedAt,
    super.customer,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: _parseString(json['id']),
      customerId: _parseString(json['customer_id']),
      status: _parseInt(json['status']),
      paymentMethod: _parseString(json['payment_method']),
      paymentStatus: _parseString(json['payment_status']),
      subtotal: _parseDouble(json['subtotal']),
      tax: _parseDouble(json['tax']),
      discount: _parseDouble(json['discount']),
      total: _parseDouble(json['total']),
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      customer: json['customer'] != null && json['customer'] is Map
          ? OrderCustomerModel.fromJson(
              json['customer'] as Map<String, dynamic>)
          : null,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class OrderCustomerModel extends OrderCustomerEntity {
  OrderCustomerModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.userId,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) {
    return OrderCustomerModel(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
      email: _parseString(json['email']),
      phone: json['phone']?.toString(),
      userId: json['user_id']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    required super.id,
    required super.orderId,
    required super.productId,
    required super.productVariantId,
    required super.quantity,
    required super.unitPrice,
    required super.discountNominal,
    required super.discountPercent,
    required super.total,
    required super.weight,
    required super.name,
    super.createdAt,
    super.updatedAt,
    super.product,
    super.variant,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: _parseString(json['id']),
      orderId: _parseString(json['order_id']),
      productId: _parseString(json['product_id']),
      productVariantId: _parseString(json['product_variant_id']),
      quantity: _parseInt(json['quantity']),
      unitPrice: _parseDouble(json['unit_price']),
      discountNominal: _parseDouble(json['discount_nominal']),
      discountPercent: _parseDouble(json['discount_percent']),
      total: _parseDouble(json['total']),
      weight: _parseDouble(json['weight']),
      name: _parseString(json['name']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      product: json['product'] != null && json['product'] is Map
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      variant: json['variant'] != null && json['variant'] is Map
          ? VariantModel.fromJson(json['variant'] as Map<String, dynamic>)
          : null,
    );
  }
}
