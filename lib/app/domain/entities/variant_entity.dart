class VariantEntity {
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
  final List<dynamic> priceProductSettings;
  final dynamic attributes;
  final double? basePrice;
  final double? sellPrice;
  final String id;

  VariantEntity({
    required this.productId,
    required this.sku,
    required this.variantName,
    this.price = 0,
    this.finalPrice = 0,
    this.stockQty = 0,
    this.width = 0,
    this.length = 0,
    this.height = 0,
    this.weight = 0,
    this.status = true,
    this.priceProductSettings = const [],
    this.attributes,
    this.basePrice,
    this.sellPrice,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'sku': sku,
        'variant_name': variantName,
        'price': price,
        'final_price': finalPrice,
        'stock_qty': stockQty,
        'width': width,
        'length': length,
        'height': height,
        'weight': weight,
        'status': status,
        'price_product_settings': priceProductSettings,
        'attributes': attributes,
        'base_price': basePrice,
        'sell_price': sellPrice,
      };
}
