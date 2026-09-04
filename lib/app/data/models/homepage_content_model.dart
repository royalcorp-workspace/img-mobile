import 'package:img/app/domain/entities/homepage_content_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';

class HomepageContentItemModel extends HomepageContentItemEntity {
  const HomepageContentItemModel({
    required super.id,
    required super.name,
    required super.slug,
    super.logo,
    super.bannerWeb,
    super.bannerMobile,
    required super.isFeatured,
    required super.status,
  });

  factory HomepageContentItemModel.fromJson(Map<String, dynamic> json) {
    return HomepageContentItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      logo: json['logo']?.toString(),
      bannerWeb: json['banner_web']?.toString(),
      bannerMobile: json['banner_mobile']?.toString(),
      isFeatured: _parseBool(json['is_featured']),
      status: _parseBool(json['status']),
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
        .map((item) => HomepageContentItemModel.fromJson(
            Map<String, dynamic>.from(item as Map)))
        .toList();

    return HomepageContentSectionModel(
      id: json['id']?.toString() ?? '',
      sectionKey: json['section_key']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
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

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString().toLowerCase() == 'true' || value == '1';
}

int _parseInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
