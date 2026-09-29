import 'package:img/app/domain/entities/product_tag_entity.dart';

class ProductTagModel extends ProductTagEntity {
  ProductTagModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.sortOrder,
  });

  factory ProductTagModel.fromJson(Map<String, dynamic> json) => ProductTagModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        sortOrder: json['sort_order'] as int? ?? 0,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'sort_order': sortOrder,
      };
}
