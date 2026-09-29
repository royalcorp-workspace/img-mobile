import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/domain/entities/add_to_cart_entity.dart';
import 'package:img/app/domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  CartModel({
    required super.id,
    required super.customerId,
    required super.sessionId,
    super.customerName,
    super.customerEmail,
    super.customerPhone,
    required super.subtotal,
    super.tax,
    super.discount,
    required super.total,
    super.creator,
    super.editor,
    super.createdAt,
    super.updatedAt,
    super.customer,
    required super.items,
  });
  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"]?.toString(),
        customerId: json["customer_id"]?.toString(),
        sessionId: json["session_id"]?.toString(),
        customerName: json["customer_name"]?.toString(),
        customerEmail: json["customer_email"]?.toString(),
        customerPhone: json["customer_phone"]?.toString(),
        subtotal: (json["subtotal"] as num?)?.toDouble() ?? 0.0,
        tax: (json["tax"] as num?)?.toDouble() ?? 0.0,
        discount: (json["discount"] as num?)?.toDouble() ?? 0.0,
        total: (json["total"] as num?)?.toDouble() ?? 0.0,
        creator: json["creator"]?.toString(),
        editor: json["editor"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        customer: json["customer"] != null && json["customer"] is Map
            ? CustomerModel.fromJson(json["customer"] as Map<String, dynamic>)
            : null,
        items: json["items"] is List
            ? List<ItemCart>.from(
                (json["items"] as List).map((x) => ItemCart.fromJson(x as Map<String, dynamic>)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "session_id": sessionId,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "subtotal": subtotal,
        "tax": tax,
        "discount": discount,
        "total": total,
        "creator": creator,
        "editor": editor,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "customer": customer?.toJson(),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class AddToCartModel extends AddToCartEntity {
  AddToCartModel({
    required super.id,
    required super.customerId,
    required super.sessionId,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required super.subtotal,
    required super.tax,
    required super.discount,
    required super.total,
    super.createdAt,
    super.updatedAt,
    super.customer,
    required super.items,
  });

  factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
        id: json["id"]?.toString(),
        customerId: json["customer_id"]?.toString(),
        sessionId: json["session_id"]?.toString(),
        customerName: json["customer_name"]?.toString(),
        customerEmail: json["customer_email"]?.toString(),
        customerPhone: json["customer_phone"]?.toString(),
        subtotal: (json["subtotal"] as num?)?.toDouble() ?? 0.0,
        tax: (json["tax"] as num?)?.toDouble() ?? 0.0,
        discount: (json["discount"] as num?)?.toDouble() ?? 0.0,
        total: (json["total"] as num?)?.toDouble() ?? 0.0,
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        customer: json["customer"] != null && json["customer"] is Map
            ? CustomerModel.fromJson(json["customer"] as Map<String, dynamic>)
            : null,
        items: json["items"] is List
            ? List<ItemCart>.from(
                (json["items"] as List).map((x) => ItemCart.fromJson(x as Map<String, dynamic>)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "session_id": sessionId,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "subtotal": subtotal,
        "tax": tax,
        "discount": discount,
        "total": total,
        "creator": creator,
        "editor": editor,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "customer": customer?.toJson(),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}
