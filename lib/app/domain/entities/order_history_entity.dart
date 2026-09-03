import 'package:pos_royal/app/data/models/customer_model.dart';
import 'package:pos_royal/app/domain/entities/product_entity.dart';
import 'package:pos_royal/app/domain/entities/variant_entity.dart';

class OrderHistoryEntity {
  final String id;
  final String orderNumber;
  final String customerId;
  final int status;
  final String statusLabel;
  final String statusText;
  final String paymentMethod;
  final int paymentStatus;
  final String paymentStatusLabel;
  final String paymentStatusText;
  final bool isVoid;
  final dynamic voidReason;
  final dynamic voidedAt;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final double shippingCost;
  final double voucherNominal;
  final String notes;
  final Map<String, dynamic> meta;
  final String createdAt;
  final String updatedAt;
  final CustomerModel? customer;
  final List<OrderHistoryItemEntity> items;

  OrderHistoryEntity({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.status,
    required this.statusLabel,
    required this.statusText,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentStatusLabel,
    required this.paymentStatusText,
    required this.isVoid,
    this.voidReason,
    this.voidedAt,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.shippingCost,
    required this.voucherNominal,
    required this.notes,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
    this.customer,
    required this.items,
  });
}

class OrderHistoryItemEntity {
  final String productId;
  final String productVariantId;
  final int quantity;
  final double unitPrice;
  final double discountNominal;
  final double discountPercent;
  final double total;
  final String name;
  final dynamic itemNotes;
  final dynamic meta;
  final String id;
  final String orderId;
  final String createdAt;
  final String updatedAt;
  final ProductEntity? product;
  final VariantEntity? variant;

  OrderHistoryItemEntity({
    required this.productId,
    required this.productVariantId,
    required this.quantity,
    required this.unitPrice,
    required this.discountNominal,
    required this.discountPercent,
    required this.total,
    required this.name,
    this.itemNotes,
    this.meta,
    required this.id,
    required this.orderId,
    required this.createdAt,
    required this.updatedAt,
    this.product,
    this.variant,
  });
}
