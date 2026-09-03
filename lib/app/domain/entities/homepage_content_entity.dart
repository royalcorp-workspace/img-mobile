import 'paginated_entity.dart';

class HomepageContentItemEntity {
  final String id;
  final String name;
  final String slug;
  final String? logo;
  final String? bannerWeb;
  final String? bannerMobile;
  final bool isFeatured;
  final bool status;

  const HomepageContentItemEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    this.bannerWeb,
    this.bannerMobile,
    required this.isFeatured,
    required this.status,
  });
}

class HomepageContentSectionEntity {
  final String id;
  final String sectionKey;
  final String title;
  final int sortOrder;
  final bool isVisible;
  final Map<String, dynamic>? meta;
  final PaginatedEntity<HomepageContentItemEntity> items;

  const HomepageContentSectionEntity({
    required this.id,
    required this.sectionKey,
    required this.title,
    required this.sortOrder,
    required this.isVisible,
    this.meta,
    required this.items,
  });
}
