import 'package:img/app/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.name,
    required super.slug,
    required super.parentId,
    required super.description,
    required super.image,
    required super.logo,
    required super.banner,
    required super.bannerWeb,
    required super.bannerMobile,
    required super.tagline,
    required super.sortOrder,
    required super.status,
    required super.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
        slug: json["slug"],
        parentId: json["parent_id"],
        description: json["description"],
        image: json["image"] as String? ?? '',
        logo: json["logo"] as String? ?? '',
        banner: json["banner"],
        bannerWeb: json["banner_web"],
        bannerMobile: json["banner_mobile"],
        tagline: json["tagline"],
        sortOrder: json["sort_order"],
        status: json["status"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "parent_id": parentId,
        "description": description,
        "image": image,
        "logo": logo,
        "banner": banner,
        "banner_web": bannerWeb,
        "banner_mobile": bannerMobile,
        "tagline": tagline,
        "sort_order": sortOrder,
        "status": status,
        "id": id,
      };
}
