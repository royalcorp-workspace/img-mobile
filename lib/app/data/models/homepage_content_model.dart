import 'package:img/app/domain/entities/homepage_content_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';

class HomepageContentItemModel extends HomepageContentItemEntity {
  const HomepageContentItemModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.title,
    required super.image,
    required super.thumbnail,
    required super.thumbnailUrl,
    required super.basePrice,
    required super.sellPrice,
    required super.discountPercent,
    required super.countingReview,
    required super.reviewsCount,
    required super.reviewCount,
  });

  factory HomepageContentItemModel.fromJson(Map<String, dynamic> json) {
    return HomepageContentItemModel(
      id: json["id"],
      title: json["title"],
      name: json["name"],
      slug: json["slug"],
      image: json["image"],
      thumbnail: json["thumbnail"],
      thumbnailUrl: json["thumbnail_url"],
      basePrice: _parseInt(json["base_price"]),
      sellPrice: _parseInt(json["sell_price"]),
      discountPercent: _parseInt(json["discount_percent"]),
      countingReview: _parseInt(json["counting_review"]),
      reviewsCount: _parseInt(json["reviews_count"]),
      reviewCount: _parseInt(json["review_count"]),
    );
  }
}

class HomepageContentImageModel extends HomepageContentImageEntity {
  const HomepageContentImageModel({
    super.id,
    super.productId,
    required super.image,
    super.altText,
    super.status,
  });

  factory HomepageContentImageModel.fromJson(Map<String, dynamic> json) {
    return HomepageContentImageModel(
      id: _parseString(json['id']),
      productId: _parseString(json['product_id']),
      image: _parseString(json['image'] ?? json['url']),
      altText: _parseNullableString(json['alt_text']),
      status: _parseBool(json['status']),
    );
  }
}

class HomepageContentReferenceModel extends HomepageContentReferenceEntity {
  const HomepageContentReferenceModel({
    required super.id,
    required super.name,
    required super.slug,
  });

  factory HomepageContentReferenceModel.fromJson(Map<String, dynamic> json) {
    return HomepageContentReferenceModel(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
    );
  }
}

class HomepageContentSectionModel extends HomepageContentSectionEntity {
  const HomepageContentSectionModel({
    required super.id,
    required super.sectionKey,
    required super.title,
    required super.sortOrder,
    required super.isVisible,
    super.meta,
    required super.items,
  });

  factory HomepageContentSectionModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .whereType<Map>()
        .map((item) =>
            HomepageContentItemModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    return HomepageContentSectionModel(
      id: _parseString(json['id']),
      sectionKey: _parseString(json['section_key']),
      title: _parseString(json['title']),
      sortOrder: _parseInt(json['sort_order']),
      isVisible: _parseBool(json['is_visible']),
      meta: json['meta'] is Map
          ? Map<String, dynamic>.from(json['meta'] as Map)
          : null,
      items: PaginatedEntity<HomepageContentItemEntity>(
        data: items,
        totalCount: items.length,
        hasMore: false,
        page: 1,
        itemsPerPage: items.length,
      ),
    );
  }
}

String _parseString(dynamic value) => value?.toString() ?? '';

String? _parseNullableString(dynamic value) => value?.toString();

int _parseInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString().toLowerCase() == 'true' || value == '1';
}
