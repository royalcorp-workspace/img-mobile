class ProductEntity {
  final String id;
  final String name;
  final String slug;
  final String? categoryId;
  final String? brandId;
  final String? thumbnail;
  final String? altText;
  final String? shortDescription;
  final String? description;
  final bool bestSeller;
  final bool isNew;
  final int sortOrder;
  final bool status;
  final double basePrice;
  final double finalPrice;
  final String? uom;
  final ProductSegmentsEntity? segments;
  final List<ProductImageEntity> images;
  final List<ProductVariantEntity> variants;
  final List<ProductColorEntity> colors;
  final List<PriceProductSettingEntity> priceProductSettings;
  final List<dynamic> reviews;
  final double avgRating;
  final int totalReviews;

  ProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.categoryId,
    this.brandId,
    this.thumbnail,
    this.altText,
    this.shortDescription,
    this.description,
    required this.bestSeller,
    required this.isNew,
    required this.sortOrder,
    required this.status,
    required this.basePrice,
    required this.finalPrice,
    this.uom,
    this.segments,
    required this.images,
    required this.variants,
    required this.colors,
    required this.priceProductSettings,
    required this.reviews,
    required this.avgRating,
    required this.totalReviews,
  });
}

class ProductImageEntity {
  final String id;
  final String productId;
  final String image;
  final String? altText;
  final bool status;

  ProductImageEntity({
    required this.id,
    required this.productId,
    required this.image,
    this.altText,
    required this.status,
  });
}

class ProductVariantEntity {
  final String id;
  final String productId;
  final String sku;
  final String variantName;
  final double price;
  final double finalPrice;
  final int stockQty;
  final int width;
  final int length;
  final int height;
  final int weight;
  final bool status;
  final List<PriceProductSettingEntity> priceProductSettings;

  ProductVariantEntity({
    required this.id,
    required this.productId,
    required this.sku,
    required this.variantName,
    required this.price,
    required this.finalPrice,
    required this.stockQty,
    required this.width,
    required this.length,
    required this.height,
    required this.weight,
    required this.status,
    required this.priceProductSettings,
  });
}

class ProductColorEntity {
  final String id;
  final String productId;
  final String colorName;
  final String colorCode;
  final bool status;

  ProductColorEntity({
    required this.id,
    required this.productId,
    required this.colorName,
    required this.colorCode,
    required this.status,
  });
}

class PriceProductSettingEntity {
  final String id;
  final String title;
  final String code;
  final String? description;
  final int discountType;
  final double discountValue;
  final double maxDiscount;
  final double minPurchase;
  final bool isActive;
  final bool isFeatured;

  PriceProductSettingEntity({
    required this.id,
    required this.title,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    required this.maxDiscount,
    required this.minPurchase,
    required this.isActive,
    required this.isFeatured,
  });
}

class ProductSegmentsEntity {
  final String uom;
  final String segment1;
  final String segment2;
  final String segment3;
  final String segment4;
  final String segment5;
  final String segment6;
  final String segment7;
  final String segment8;
  final String segment9;
  final String segment10;
  final double basePrice;

  ProductSegmentsEntity({
    required this.uom,
    required this.segment1,
    required this.segment2,
    required this.segment3,
    required this.segment4,
    required this.segment5,
    required this.segment6,
    required this.segment7,
    required this.segment8,
    required this.segment9,
    required this.segment10,
    required this.basePrice,
  });
}
