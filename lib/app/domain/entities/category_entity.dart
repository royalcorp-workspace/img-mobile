class CategoryEntity {
  final String name;
  final String slug;
  final dynamic parentId;
  final dynamic description;
  final dynamic image;
  final dynamic logo;
  final dynamic banner;
  final dynamic bannerWeb;
  final dynamic bannerMobile;
  final dynamic tagline;
  final int sortOrder;
  final bool status;
  final String id;

  CategoryEntity({
    required this.name,
    required this.slug,
    required this.parentId,
    required this.description,
    required this.image,
    required this.logo,
    required this.banner,
    required this.bannerWeb,
    required this.bannerMobile,
    required this.tagline,
    required this.sortOrder,
    required this.status,
    required this.id,
  });
}
