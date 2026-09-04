import 'package:img/app/data/models/product_model.dart';
import 'package:img/app/data/models/variant_model.dart';
import 'package:img/app/domain/entities/product_by_id_entity.dart';

double _parseDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  if (val is String) {
    return double.tryParse(val) ?? 0.0;
  }
  return 0.0;
}

int _parseInt(dynamic val) {
  if (val == null) return 0;
  if (val is num) return val.toInt();
  if (val is String) {
    return int.tryParse(val) ?? (double.tryParse(val)?.toInt() ?? 0);
  }
  return 0;
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

String _parseString(dynamic val) {
  if (val == null) return '';
  return val.toString();
}

class ProductByIdModel extends ProductByIdEntity {
  ProductByIdModel({
    super.name,
    super.slug,
    super.categoryId,
    super.brandId,
    super.thumbnail,
    super.altText,
    super.shortDescription,
    super.description,
    super.bestSeller,
    super.isNew,
    super.sortOrder,
    super.status,
    super.basePrice,
    super.uom,
    super.segments,
    super.id,
    super.images,
    super.variants,
    super.colors,
    super.priceProductSettings,
    super.reviews,
    super.avgRating,
    super.totalReviews,
    super.finalPrice,
  });

  factory ProductByIdModel.fromJson(Map<String, dynamic> json) =>
      ProductByIdModel(
        name: _parseString(json["name"]),
        slug: _parseString(json["slug"]),
        categoryId: _parseString(json["category_id"]),
        brandId: json['brand_id']?.toString(),
        thumbnail: json['thumbnail']?.toString(),
        altText: json['alt_text']?.toString(),
        shortDescription: json['short_description']?.toString(),
        description: json['description']?.toString(),
        bestSeller: _parseBool(json['best_seller']),
        isNew: _parseBool(json['is_new']),
        sortOrder: _parseInt(json['sort_order']),
        status: _parseInt(json['status']),
        basePrice: _parseString(json['base_price']),
        uom: json['uom']?.toString(),
        segments: json['segments'] != null && json['segments'] is Map
            ? ProductSegmentsModel.fromJson(
                json['segments'] as Map<String, dynamic>)
            : null,
        id: _parseString(json['id']),
        images: (json['images'] as List<dynamic>?)
                ?.map((e) =>
                    ProductImageModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        variants: (json['variants'] as List<dynamic>?)
                ?.map((e) =>
                    ProductVariantModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        colors: (json['colors'] as List<dynamic>?)
                ?.map((e) =>
                    ProductColorModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        priceProductSettings: (json['price_product_settings'] as List<dynamic>?)
                ?.map((e) => PriceProductSettingModel.fromJson(
                    e as Map<String, dynamic>))
                .toList() ??
            [],
        reviews: json['reviews'] as List<dynamic>? ?? [],
        avgRating: _parseInt(json['avg_rating']),
        totalReviews: _parseInt(json['total_reviews']),
        finalPrice: _parseInt(json['final_price']),
      );
}
