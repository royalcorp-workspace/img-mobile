import 'package:img/app/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.name,
    required super.slug,
    required super.parentId,
    required super.description,
    required super.sortOrder,
    required super.status,
    required super.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
        slug: json["slug"],
        parentId: json["parent_id"],
        description: json["description"],
        sortOrder: json["sort_order"],
        status: json["status"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "parent_id": parentId,
        "description": description,
        "sort_order": sortOrder,
        "status": status,
        "id": id,
      };
}
