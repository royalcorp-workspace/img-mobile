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
        id: json["id"],
        customerId: json["customer_id"],
        sessionId: json["session_id"],
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        subtotal: json["subtotal"],
        tax: json["tax"],
        discount: json["discount"],
        total: json["total"],
        creator: json["creator"],
        editor: json["editor"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        customer: json["customer"] == null
            ? null
            : CustomerModel.fromJson(json["customer"]),
        items: json["items"] == null
            ? []
            : List<ItemCart>.from(
                json["items"]!.map((x) => ItemCart.fromJson(x))),
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
        id: json["id"],
        customerId: json["customer_id"],
        sessionId: json["session_id"],
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        subtotal: json["subtotal"],
        tax: json["tax"],
        discount: json["discount"],
        total: json["total"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        customer: json["customer"] == null
            ? null
            : CustomerModel.fromJson(json["customer"]),
        items: json["items"] == null
            ? []
            : List<ItemCart>.from(
                json["items"]!.map((x) => ItemCart.fromJson(x))),
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
