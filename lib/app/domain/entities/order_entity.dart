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
  final OrderProductEntity? product;
  final OrderVariantEntity? variant;

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

class OrderProductEntity {
  final String id;
  final String name;
  final String slug;
  final String? categoryId;
  final String? thumbnail;
  final String? altText;
  final String? shortDescription;
  final String? description;
  final double basePrice;
  final bool bestSeller;
  final bool isNew;
  final int sortOrder;
  final int status;
  final String? createdAt;
  final String? updatedAt;

  OrderProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.categoryId,
    this.thumbnail,
    this.altText,
    this.shortDescription,
    this.description,
    required this.basePrice,
    required this.bestSeller,
    required this.isNew,
    required this.sortOrder,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });
}

class OrderVariantEntity {
  final String id;
  final String productId;
  final String sku;
  final String variantName;
  final double price;
  final int stockQty;
  final String? createdAt;
  final String? updatedAt;

  OrderVariantEntity({
    required this.id,
    required this.productId,
    required this.sku,
    required this.variantName,
    required this.price,
    required this.stockQty,
    this.createdAt,
    this.updatedAt,
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
  final List<CreateOrderItemParams> items;

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

class CreateOrderItemParams {
  final String productId;
  final String productVariantId;
  final int quantity;
  final double unitPrice;
  final double discountNominal;
  final double discountPercent;
  final double total;
  final double weight;
  final String name;

  CreateOrderItemParams({
    required this.productId,
    required this.productVariantId,
    required this.quantity,
    required this.unitPrice,
    this.discountNominal = 0,
    this.discountPercent = 0,
    required this.total,
    this.weight = 0,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_variant_id': productVariantId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount_nominal': discountNominal,
      'discount_percent': discountPercent,
      'total': total,
      'weight': weight,
      'name': name,
    };
  }
}
