import '../../domain/entities/product_entity.dart';

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

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    super.categoryId,
    super.brandId,
    super.thumbnail,
    super.altText,
    super.shortDescription,
    super.description,
    required super.bestSeller,
    required super.isNew,
    required super.sortOrder,
    required super.status,
    required super.basePrice,
    required super.finalPrice,
    super.uom,
    super.segments,
    required super.images,
    required super.variants,
    required super.colors,
    required super.priceProductSettings,
    required super.reviews,
    required super.avgRating,
    required super.totalReviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      categoryId: json['category_id']?.toString(),
      brandId: json['brand_id']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      altText: json['alt_text']?.toString(),
      shortDescription: json['short_description']?.toString(),
      description: json['description']?.toString(),
      bestSeller: _parseBool(json['best_seller']),
      isNew: _parseBool(json['is_new']),
      sortOrder: _parseInt(json['sort_order']),
      status: _parseBool(json['status']),
      basePrice: _parseDouble(json['base_price']),
      finalPrice: _parseDouble(json['final_price']),
      uom: json['uom']?.toString(),
      segments: json['segments'] != null && json['segments'] is Map
          ? ProductSegmentsModel.fromJson(
              json['segments'] as Map<String, dynamic>)
          : null,
      images: (json['images'] as List<dynamic>?)
              ?.map(
                  (e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) =>
                  ProductVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      colors: (json['colors'] as List<dynamic>?)
              ?.map(
                  (e) => ProductColorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      priceProductSettings: (json['price_product_settings'] as List<dynamic>?)
              ?.map((e) =>
                  PriceProductSettingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: json['reviews'] as List<dynamic>? ?? [],
      avgRating: _parseDouble(json['avg_rating']),
      totalReviews: _parseInt(json['total_reviews']),
    );
  }
}

class ProductImageModel extends ProductImageEntity {
  ProductImageModel({
    required super.id,
    required super.productId,
    required super.image,
    super.altText,
    required super.status,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: _parseString(json['id']),
      productId: _parseString(json['product_id']),
      image: _parseString(json['image']),
      altText: json['alt_text']?.toString(),
      status: _parseBool(json['status']),
    );
  }
}

class ProductVariantModel extends ProductVariantEntity {
  ProductVariantModel({
    required super.id,
    required super.productId,
    required super.sku,
    required super.variantName,
    required super.price,
    required super.finalPrice,
    required super.stockQty,
    required super.width,
    required super.length,
    required super.height,
    required super.weight,
    required super.status,
    required super.priceProductSettings,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] as Map<String, dynamic>?;
    return ProductVariantModel(
      id: _parseString(json['id']),
      productId: _parseString(json['product_id']),
      sku: _parseString(json['sku']),
      variantName: _parseString(json['variant_name']),
      price: _parseDouble(json['price']),
      finalPrice: _parseDouble(json['final_price']),
      stockQty: _parseInt(json['stock_qty']),
      width: _parseInt(attrs?['width'] ?? json['width']),
      length: _parseInt(attrs?['length'] ?? json['length']),
      height: _parseInt(attrs?['height'] ?? json['height']),
      weight: _parseInt(attrs?['weight'] ?? json['weight']),
      status: _parseBool(json['status']),
      priceProductSettings: (json['price_product_settings'] as List<dynamic>?)
              ?.map((e) =>
                  PriceProductSettingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ProductColorModel extends ProductColorEntity {
  ProductColorModel({
    required super.id,
    required super.productId,
    required super.colorName,
    required super.colorCode,
    required super.status,
  });

  factory ProductColorModel.fromJson(Map<String, dynamic> json) {
    return ProductColorModel(
      id: _parseString(json['id']),
      productId: _parseString(json['product_id']),
      colorName: _parseString(json['color_name']),
      colorCode: _parseString(json['color_code']),
      status: _parseBool(json['status']),
    );
  }
}

class PriceProductSettingModel extends PriceProductSettingEntity {
  PriceProductSettingModel({
    required super.id,
    required super.title,
    required super.code,
    super.description,
    required super.discountType,
    required super.discountValue,
    required super.maxDiscount,
    required super.minPurchase,
    required super.isActive,
    required super.isFeatured,
  });

  factory PriceProductSettingModel.fromJson(Map<String, dynamic> json) {
    return PriceProductSettingModel(
      id: _parseString(json['id']),
      title: _parseString(json['title']),
      code: _parseString(json['code']),
      description: json['description']?.toString(),
      discountType: _parseInt(json['discount_type'] ?? json['type']),
      discountValue: _parseDouble(json['discount_value']),
      maxDiscount: _parseDouble(json['max_discount']),
      minPurchase: _parseDouble(json['min_purchase']),
      isActive: _parseBool(json['is_active']),
      isFeatured: _parseBool(json['is_featured']),
    );
  }
}

class ProductSegmentsModel extends ProductSegmentsEntity {
  ProductSegmentsModel({
    required super.uom,
    required super.segment1,
    required super.segment2,
    required super.segment3,
    required super.segment4,
    required super.segment5,
    required super.segment6,
    required super.segment7,
    required super.segment8,
    required super.segment9,
    required super.segment10,
    required super.basePrice,
  });

  factory ProductSegmentsModel.fromJson(Map<String, dynamic> json) {
    return ProductSegmentsModel(
      uom: _parseString(json['uom']),
      segment1: _parseString(json['segment1']),
      segment2: _parseString(json['segment2']),
      segment3: _parseString(json['segment3']),
      segment4: _parseString(json['segment4']),
      segment5: _parseString(json['segment5']),
      segment6: _parseString(json['segment6']),
      segment7: _parseString(json['segment7']),
      segment8: _parseString(json['segment8']),
      segment9: _parseString(json['segment9']),
      segment10: _parseString(json['segment10']),
      basePrice: _parseDouble(json['base_price']),
    );
  }
}
