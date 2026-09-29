import 'package:img/app/domain/entities/paginated_entity.dart';

class PaginatedModel<T> extends PaginatedEntity<T> {
  PaginatedModel({
    required super.data,
    required super.totalCount,
    required super.hasMore,
    required super.page,
    required super.itemsPerPage,
  });

  factory PaginatedModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    final rawList = json["data"] as List<dynamic>? ?? [];
    final List<T> parsedItems = rawList.map((x) {
      if (x is Map<String, dynamic>) {
        return fromJsonT(x);
      } else if (x is Map) {
        return fromJsonT(Map<String, dynamic>.from(x));
      } else {
        return x as T;
      }
    }).toList();

    return PaginatedModel<T>(
      data: parsedItems,
      totalCount: _parseInt(json['total_count']),
      hasMore: _parseBool(json['has_more']),
      page: _parseInt(json['page']),
      itemsPerPage: _parseInt(json['items_per_page']),
    );
  }
}

bool _parseBool(dynamic val) {
  if (val == null) return false;
  if (val is bool) return val;
  if (val is num) return val == 1;
  if (val is String) {
    return val == '1' || val.toLowerCase() == 'true';
  }
  return false;
}

int _parseInt(dynamic val) {
  if (val == null) return 0;
  if (val is num) return val.toInt();
  if (val is String) {
    return int.tryParse(val) ?? (double.tryParse(val)?.toInt() ?? 0);
  }
  return 0;
}
