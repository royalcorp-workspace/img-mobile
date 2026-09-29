class CategoryEntity {
  final String name;
  final String slug;
  final dynamic parentId;
  final String description;
  final int sortOrder;
  final bool status;
  final String id;

  CategoryEntity({
    required this.name,
    required this.slug,
    required this.parentId,
    required this.description,
    required this.sortOrder,
    required this.status,
    required this.id,
  });
}
