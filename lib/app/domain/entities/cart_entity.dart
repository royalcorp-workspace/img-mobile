import 'package:pos_royal/app/data/models/customer_model.dart';
import 'package:pos_royal/app/domain/entities/add_to_cart_entity.dart';

class CartEntity {
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

  CartEntity({
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
