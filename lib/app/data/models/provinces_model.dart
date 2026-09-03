import 'package:pos_royal/app/domain/entities/provincy_entity.dart';

class ProvincesModel extends ProvincyEntity {
  ProvincesModel({
    required super.id,
    required super.name,
    required super.code,
    required super.isActive,
    required super.sortOrder,
  });

  factory ProvincesModel.fromJson(Map<String, dynamic> json) => ProvincesModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        isActive: json["is_active"],
        sortOrder: json["sort_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "is_active": isActive,
        "sort_order": sortOrder,
      };
}
