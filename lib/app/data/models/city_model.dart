import 'package:img/app/domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  CityModel({
    required super.id,
    required super.province,
    required super.provinceId,
    required super.name,
    required super.isActive,
    required super.sortOrder,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"],
        province: json["province"],
        provinceId: json["province_id"],
        name: json["name"],
        isActive: json["is_active"],
        sortOrder: json["sort_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province": province,
        "province_id": provinceId,
        "name": name,
        "is_active": isActive,
        "sort_order": sortOrder,
      };
}
