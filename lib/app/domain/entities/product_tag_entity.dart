class ProductTagEntity {
  final String id;
  final String name;
  final String slug;
  final int sortOrder;

  ProductTagEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'sort_order': sortOrder,
      };
}
