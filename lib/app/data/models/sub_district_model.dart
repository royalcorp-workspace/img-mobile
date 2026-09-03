import 'package:pos_royal/app/domain/entities/sub_district_entity.dart';

class SubDistrictModel extends SubDistrictEntity {
  SubDistrictModel({
    required super.id,
    required super.province,
    required super.provinceId,
    required super.cityId,
    required super.district,
    required super.subDistrict,
    required super.postalCode,
    required super.isActive,
    required super.sortOrder,
  });

  factory SubDistrictModel.fromJson(Map<String, dynamic> json) =>
      SubDistrictModel(
        id: json["id"],
        province: json["province"],
        provinceId: json["province_id"],
        cityId: json["city_id"],
        district: json["district"],
        subDistrict: json["sub_district"],
        postalCode: json["postal_code"],
        isActive: json["is_active"],
        sortOrder: json["sort_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province": province,
        "province_id": provinceId,
        "city_id": cityId,
        "district": district,
        "sub_district": subDistrict,
        "postal_code": postalCode,
        "is_active": isActive,
        "sort_order": sortOrder,
      };
}
