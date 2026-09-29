import 'package:img/app/domain/entities/shipping_addresses_entity.dart';

class ShippingAddressesModel extends ShippingAddressesEntity {
  ShippingAddressesModel({
    required super.createdAt,
    required super.updatedAt,
    required super.courierId,
    required super.cityId,
    super.subDistrictId,
    required super.type,
    required super.price,
    required super.isActive,
    required super.sortOrder,
    required super.id,
    super.courier,
  });

  factory ShippingAddressesModel.fromJson(Map<String, dynamic> json) =>
      ShippingAddressesModel(
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        courierId: json["courier_id"] ?? '',
        cityId: json["city_id"],
        subDistrictId: json["sub_district_id"],
        type: json["type"] ?? 0,
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        isActive: json["is_active"] ?? false,
        sortOrder: json["sort_order"] ?? 0,
        id: json["id"] ?? '',
        courier: json["courier"] != null
            ? CourierModel.fromJson(json["courier"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "updated_at": updatedAt,
        "courier_id": courierId,
        "city_id": cityId,
        "sub_district_id": subDistrictId,
        "type": type,
        "price": price,
        "is_active": isActive,
        "sort_order": sortOrder,
        "id": id,
        "courier": courier?.toJson(),
      };
}

class CourierModel extends CourierEntity {
  CourierModel({
    required super.id,
    required super.code,
    required super.name,
    required super.type,
    required super.isActive,
    required super.sortOrder,
  });

  factory CourierModel.fromJson(Map<String, dynamic> json) => CourierModel(
        id: json["id"] ?? '',
        code: json["code"] ?? '',
        name: json["name"] ?? '',
        type: json["type"] ?? 0,
        isActive: json["is_active"] ?? false,
        sortOrder: json["sort_order"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "type": type,
        "is_active": isActive,
        "sort_order": sortOrder,
      };
}
