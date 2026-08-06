import 'package:pos_royal/app/domain/entities/shipping_addresses_entity.dart';

class ShippingAddressesModel extends ShippingAddressesEntity {
  ShippingAddressesModel({
    required super.createdAt,
    required super.updatedAt,
    required super.courierId,
    required super.subDistrictId,
    required super.type,
    required super.price,
    required super.isActive,
    required super.sortOrder,
    required super.id,
    required super.courier,
  });

  factory ShippingAddressesModel.fromJson(Map<String, dynamic> json) =>
      ShippingAddressesModel(
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        courierId: json["courier_id"],
        subDistrictId: json["sub_district_id"],
        type: json["type"],
        price: json["price"],
        isActive: json["is_active"],
        sortOrder: json["sort_order"],
        id: json["id"],
        courier: CourierModel.fromJson(json["courier"]),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "updated_at": updatedAt,
        "courier_id": courierId,
        "sub_district_id": subDistrictId,
        "type": type,
        "price": price,
        "is_active": isActive,
        "sort_order": sortOrder,
        "id": id,
        "courier": courier.toJson(),
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
        id: json["id"],
        code: json["code"],
        name: json["name"],
        type: json["type"],
        isActive: json["is_active"],
        sortOrder: json["sort_order"],
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
