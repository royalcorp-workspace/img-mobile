import 'package:pos_royal/app/domain/entities/primary_address_entity.dart';

class PrimaryAddressModel extends PrimaryAddressEntity {
  PrimaryAddressModel({
    required super.createdAt,
    required super.updatedAt,
    required super.name,
    required super.email,
    required super.phone,
    required super.meta,
    required super.id,
    required super.userId,
    required super.addresses,
  });

  factory PrimaryAddressModel.fromJson(Map<String, dynamic> json) =>
      PrimaryAddressModel(
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        meta: json["meta"],
        id: json["id"],
        userId: json["user_id"],
        addresses: json["addresses"] == null
            ? []
            : List<dynamic>.from(json["addresses"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "updated_at": updatedAt,
        "name": name,
        "email": email,
        "phone": phone,
        "meta": meta,
        "id": id,
        "user_id": userId,
        "addresses": List<dynamic>.from(addresses.map((x) => x)),
      };
}
