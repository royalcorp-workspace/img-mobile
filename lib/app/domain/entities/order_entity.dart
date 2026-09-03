import 'package:pos_royal/app/domain/entities/product_entity.dart';
import 'package:pos_royal/app/domain/entities/variant_entity.dart';

class OrderEntity {
  final String id;
  final String customerId;
  final int status;
  final String paymentMethod;
  final String paymentStatus;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final OrderCustomerEntity? customer;
  final List<OrderItemEntity> items;

  OrderEntity({
    required this.id,
    required this.customerId,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.customer,
    required this.items,
  });
}

class OrderCustomerEntity {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;

  OrderCustomerEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });
}

class OrderItemEntity {
  final String id;
  final String orderId;
  final String productId;
  final String productVariantId;
  final int quantity;
  final double unitPrice;
  final double discountNominal;
  final double discountPercent;
  final double total;
  final double weight;
  final String name;
  final String? createdAt;
  final String? updatedAt;
  final ProductEntity? product;
  final VariantEntity? variant;

  OrderItemEntity({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productVariantId,
    required this.quantity,
    required this.unitPrice,
    required this.discountNominal,
    required this.discountPercent,
    required this.total,
    required this.weight,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.variant,
  });
}

class CreateOrderParams {
  final String customerId;
  final int status;
  final String paymentMethod;
  final int paymentStatus;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String notes;
  final Map<String, dynamic> meta;
  final List<ItemParams> items;

  CreateOrderParams({
    required this.customerId,
    this.status = 0,
    required this.paymentMethod,
    this.paymentStatus = 0,
    required this.subtotal,
    this.tax = 0,
    this.discount = 0,
    required this.total,
    this.notes = '',
    this.meta = const {},
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'status': status,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
      'notes': notes,
      'meta': meta,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class ItemParams {
  final String productId;
  final String productVariantId;
  final String name;
  final int quantity;
  final double unitPrice;
  final double total;
  final double discountNominal;
  final double discountPercent;
  final dynamic itemNotes;
  final dynamic meta;
  final String? id;
  final String? addToCartId;
  final ProductEntity? product;
  final dynamic variant;
  final double weight;

  ItemParams({
    required this.productId,
    required this.productVariantId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.discountNominal = 0,
    this.discountPercent = 0,
    this.itemNotes,
    this.meta,
    this.id,
    this.addToCartId,
    this.product,
    this.variant,
    this.weight = 0,
  });

  Map<String, dynamic> toJson() {
    dynamic serializedVariant;
    if (variant == null) {
      serializedVariant = null;
    } else if (variant is Map) {
      serializedVariant = variant;
    } else if (variant is VariantEntity) {
      serializedVariant = (variant as VariantEntity).toJson();
    }

    return {
      "product_id": productId,
      "product_variant_id": productVariantId,
      "name": name,
      "quantity": quantity,
      "unit_price": unitPrice,
      "total": total,
      "discount_nominal": discountNominal,
      "discount_percent": discountPercent,
      "item_notes": itemNotes,
      "meta": meta,
      "id": id,
      "add_to_cart_id": addToCartId,
      "product": product?.toJson(),
      "variant": serializedVariant,
    };
  }
}
