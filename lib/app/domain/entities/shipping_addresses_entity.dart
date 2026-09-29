import 'package:img/app/data/models/shipping_addresses_model.dart';

class ShippingAddressesEntity {
  final String createdAt;
  final String updatedAt;
  final String courierId;
  final dynamic cityId;
  final String? subDistrictId;
  final int type;
  final double price;
  final double additionalPricePerKg;
  final bool isActive;
  final int sortOrder;
  final String id;
  final CourierModel? courier;

  ShippingAddressesEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.courierId,
    required this.cityId,
    this.subDistrictId,
    required this.type,
    required this.price,
    this.additionalPricePerKg = 0.0,
    required this.isActive,
    required this.sortOrder,
    required this.id,
    this.courier,
  });
}

class CourierEntity {
  final String id;
  final String code;
  final String name;
  final int type;
  final bool isActive;
  final int sortOrder;

  CourierEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.isActive,
    required this.sortOrder,
  });
}
