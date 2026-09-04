import 'package:img/app/domain/entities/variant_entity.dart';

class VariantModel extends VariantEntity {
  VariantModel({
    super.productId = '',
    super.sku = '',
    super.variantName = '',
    super.price = 0,
    super.finalPrice = 0,
    super.stockQty = 0,
    super.width = 0,
    super.length = 0,
    super.height = 0,
    super.weight = 0,
    super.status = true,
    super.priceProductSettings = const [],
    super.attributes,
    super.basePrice,
    super.sellPrice,
    super.id = '',
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    num toNum(dynamic value) =>
        value is num ? value : num.tryParse(value?.toString() ?? '') ?? 0;
    int toInt(dynamic value) => toNum(value).toInt();
    return VariantModel(
      productId: json['product_id']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      variantName: json['variant_name']?.toString() ?? '',
      price: toNum(json['price']).toDouble(),
      finalPrice: toNum(json['final_price']).toDouble(),
      stockQty: toInt(json['stock_qty']),
      width: toInt(json['width'] ?? (json['attributes'] as Map?)?['width']),
      length: toInt(json['length'] ?? (json['attributes'] as Map?)?['length']),
      height: toInt(json['height'] ?? (json['attributes'] as Map?)?['height']),
      weight: toInt(json['weight'] ?? (json['attributes'] as Map?)?['weight']),
      status: json['status'] is bool ? json['status'] as bool : true,
      priceProductSettings:
          json['price_product_settings'] as List<dynamic>? ?? [],
      attributes: json['attributes'],
      basePrice: toNum(json['base_price']).toDouble(),
      sellPrice: toNum(json['sell_price']).toDouble(),
      id: json['id']?.toString() ?? '',
    );
  }
}

typedef ProductVariantModel = VariantModel;
