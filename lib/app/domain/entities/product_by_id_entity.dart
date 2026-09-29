import 'package:img/app/domain/entities/product_entity.dart';

class ProductByIdEntity {
  final String? name;
  final String? slug;
  final String? categoryId;
  final dynamic brandId;
  final String? thumbnail;
  final String? altText;
  final String? shortDescription;
  final String? description;
  final bool? bestSeller;
  final bool? isNew;
  final int? sortOrder;
  final int? status;
  final String? basePrice;
  final dynamic uom;
  final dynamic segments;
  final String? id;
  final List<dynamic>? images;
  final List<ProductVariantEntity>? variants;
  final List<dynamic>? colors;
  final List<PriceProductSettingEntity>? priceProductSettings;
  final List<dynamic>? reviews;
  final int? avgRating;
  final int? totalReviews;
  final int? finalPrice;

  ProductByIdEntity({
    this.name,
    this.slug,
    this.categoryId,
    this.brandId,
    this.thumbnail,
    this.altText,
    this.shortDescription,
    this.description,
    this.bestSeller,
    this.isNew,
    this.sortOrder,
    this.status,
    this.basePrice,
    this.uom,
    this.segments,
    this.id,
    this.images,
    this.variants,
    this.colors,
    this.priceProductSettings,
    this.reviews,
    this.avgRating,
    this.totalReviews,
    this.finalPrice,
  });
}
