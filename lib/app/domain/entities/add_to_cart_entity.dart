import 'package:pos_royal/app/data/models/customer_model.dart';
import 'package:pos_royal/app/domain/entities/order_entity.dart';

class AddToCartEntityParams {
  final String? customerId;
  final String? sessionId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final double subtotal;
  final int? tax;
  final int? discount;
  final double total;
  final Map<String, dynamic> meta;
  final List<ItemParams> items;

  AddToCartEntityParams({
    required this.customerId,
    required this.sessionId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.subtotal,
    this.tax = 0,
    this.discount = 0,
    required this.total,
    this.meta = const {},
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'session_id': sessionId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
      'meta': meta,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class AddToCartEntity {
  final String? id;
  final String? customerId;
  final String? sessionId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final double? subtotal;
  final double? tax;
  final double? discount;
  final double? total;
  final String? creator;
  final String? editor;
  final String? createdAt;
  final String? updatedAt;
  final CustomerModel? customer;
  final List<ItemCart>? items;

  AddToCartEntity({
    this.id,
    this.customerId,
    this.sessionId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.subtotal,
    this.tax,
    this.discount,
    this.total,
    this.creator,
    this.editor,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.items,
  });
}

class ItemCart {
  final String? id;
  final String? addToCartId;
  final String? productId;
  final String? name;
  final int? quantity;
  final int? unitPrice;
  final int? total;
  final int? discountNominal;
  final int? discountPercent;
  final String? createdAt;
  final String? updatedAt;
  final Product? product;

  ItemCart({
    this.id,
    this.addToCartId,
    this.productId,
    this.name,
    this.quantity,
    this.unitPrice,
    this.total,
    this.discountNominal,
    this.discountPercent,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory ItemCart.fromJson(Map<String, dynamic> json) => ItemCart(
        id: json["id"],
        addToCartId: json["add_to_cart_id"],
        productId: json["product_id"],
        name: json["name"],
        quantity: json["quantity"],
        unitPrice: json["unit_price"],
        total: json["total"],
        discountNominal: json["discount_nominal"],
        discountPercent: json["discount_percent"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "add_to_cart_id": addToCartId,
        "product_id": productId,
        "name": name,
        "quantity": quantity,
        "unit_price": unitPrice,
        "total": total,
        "discount_nominal": discountNominal,
        "discount_percent": discountPercent,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "product": product?.toJson(),
      };
}

class Product {
  final String? id;
  final String? name;
  final String? slug;
  final String? basePrice;

  Product({
    this.id,
    this.name,
    this.slug,
    this.basePrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        basePrice: json["base_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "base_price": basePrice,
      };
}
