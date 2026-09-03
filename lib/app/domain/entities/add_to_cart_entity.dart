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
  final String? productId;
  final String? productVariantId;
  final String? name;
  final int quantity;
  final double unitPrice;
  final double total;
  final double discountNominal;
  final double discountPercent;
  final dynamic itemNotes;
  final dynamic meta;
  final String? addToCartId;
  final Product? product;
  final VariantCart? variant;

  ItemCart({
    this.productId,
    this.productVariantId,
    this.name,
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
  });

  factory ItemCart.fromJson(Map<String, dynamic> json) => ItemCart(
        productId: json["product_id"],
        productVariantId: json["product_variant_id"],
        name: json["name"],
        quantity: json["quantity"],
        unitPrice: json["unit_price"]?.toDouble(),
        total: json["total"]?.toDouble(),
        discountNominal: json["discount_nominal"],
        discountPercent: json["discount_percent"],
        itemNotes: json["item_notes"],
        meta: json["meta"],
        id: json["id"],
        addToCartId: json["add_to_cart_id"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        variant: json["variant"] == null
            ? null
            : VariantCart.fromJson(json["variant"]),
      );

  Map<String, dynamic> toJson() => {
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
        "variant": variant?.toJson(),
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

class VariantCart {
  final String? productId;
  final String? sku;
  final String? variantName;
  final double? width;
  final double? length;
  final double? height;
  final double? weight;
  final double? basePrice;
  final double? sellPrice;
  final double? stockQty;
  final dynamic attributes;
  final String? id;
  final List<dynamic>? priceProductSettings;
  final double? finalPrice;

  VariantCart({
    this.productId,
    this.sku,
    this.variantName,
    this.width,
    this.length,
    this.height,
    this.weight,
    this.basePrice,
    this.sellPrice,
    this.stockQty,
    this.attributes,
    this.id,
    this.priceProductSettings,
    this.finalPrice,
  });

  factory VariantCart.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) {
      if (value == null) return null;

      if (value is num) {
        return value.toDouble();
      }

      return double.tryParse(value.toString());
    }

    return VariantCart(
      productId: json["product_id"]?.toString(),
      sku: json["sku"]?.toString(),
      variantName: json["variant_name"]?.toString(),
      width: toDouble(json["width"]),
      length: toDouble(json["length"]),
      height: toDouble(json["height"]),
      weight: toDouble(json["weight"]),
      basePrice: toDouble(json["base_price"]),
      sellPrice: toDouble(json["sell_price"]),
      stockQty: toDouble(json["stock_qty"]),
      attributes: json["attributes"],
      id: json["id"]?.toString(),
      priceProductSettings: json["price_product_settings"] == null
          ? []
          : List<dynamic>.from(
              json["price_product_settings"].map((x) => x),
            ),
      finalPrice: toDouble(json["final_price"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "sku": sku,
        "variant_name": variantName,
        "width": width,
        "length": length,
        "height": height,
        "weight": weight,
        "base_price": basePrice,
        "sell_price": sellPrice,
        "stock_qty": stockQty,
        "attributes": attributes,
        "id": id,
        "price_product_settings": priceProductSettings == null
            ? []
            : List<dynamic>.from(
                priceProductSettings!.map((x) => x),
              ),
        "final_price": finalPrice,
      };
}
