class AddressModel {
  final String? label;
  final String? recipientName;
  final String? phone;
  final String? address;
  final String? cityId;
  final String? userId;
  final String? subDistrictId;
  final String? postalCode;
  final bool? isPrimary;
  final String? id;
  final String? customerId;
  final String? cityName;
  final String? subDistrictName;
  final String? districtName;
  final String? provinceId;
  final String? provinceName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressModel({
    this.label,
    this.recipientName,
    this.phone,
    this.address,
    this.cityId,
    this.userId,
    this.subDistrictId,
    this.postalCode,
    this.isPrimary,
    this.id,
    this.customerId,
    this.cityName,
    this.subDistrictName,
    this.districtName,
    this.provinceId,
    this.provinceName,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      label: json["label"],
      recipientName: json["recipient_name"],
      phone: json["phone"],
      address: json["address"],
      cityId: json["city_id"],
      userId: json["user_id"],
      subDistrictId: json["sub_district_id"],
      postalCode: json["postal_code"],
      isPrimary: json["is_primary"],
      id: json["id"],
      customerId: json["customer_id"],
      cityName: json["city_name"],
      subDistrictName: json["sub_district_name"],
      districtName: json["district_name"],
      provinceId: json["province_id"],
      provinceName: json["province_name"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "label": label,
      "recipient_name": recipientName,
      "phone": phone,
      "address": address,
      "city_id": cityId,
      "user_id": userId,
      "sub_district_id": subDistrictId,
      "postal_code": postalCode,
      "is_primary": isPrimary,
      "id": id,
      "customer_id": customerId,
      "city_name": cityName,
      "sub_district_name": subDistrictName,
      "district_name": districtName,
      "province_id": provinceId,
      "province_name": provinceName,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
