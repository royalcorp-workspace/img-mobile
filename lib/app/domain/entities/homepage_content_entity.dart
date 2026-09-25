import 'paginated_entity.dart';

class HomepageContentReferenceEntity {
  final String id;
  final String name;
  final String slug;

  const HomepageContentReferenceEntity({
    required this.id,
    required this.name,
    required this.slug,
  });
}

class HomepageContentImageEntity {
  final String id;
  final String productId;
  final String image;
  final String? altText;
  final bool status;

  const HomepageContentImageEntity({
    this.id = '',
    this.productId = '',
    required this.image,
    this.altText,
    this.status = true,
  });
}

class HomepageContentItemEntity {
  final String id;
  final String title;
  final String name;
  final String slug;
  final String image;
  final String thumbnail;
  final String thumbnailUrl;
  final int basePrice;
  final int sellPrice;
  final int discountPercent;
  final int countingReview;
  final int reviewsCount;
  final int reviewCount;

  int get totalReviews => 0;

  const HomepageContentItemEntity({
    required this.id,
    required this.title,
    required this.name,
    required this.slug,
    required this.image,
    required this.thumbnail,
    required this.thumbnailUrl,
    required this.basePrice,
    required this.sellPrice,
    required this.discountPercent,
    required this.countingReview,
    required this.reviewsCount,
    required this.reviewCount,
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
