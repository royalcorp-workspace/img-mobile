import 'package:img/app/domain/entities/add_to_cart_entity.dart';
import 'package:img/app/domain/entities/product_by_id_entity.dart';

enum CheckoutSource {
  cart,
  product,
}

class CheckoutArguments {
  final CheckoutSource source;
  final List<ItemCart>? cartItems;
  final ProductByIdEntity? product;
  final int? selectedVariantIndex;

  const CheckoutArguments({
    required this.source,
    this.cartItems,
    this.product,
    this.selectedVariantIndex,
  });

  factory CheckoutArguments.fromCart(List<ItemCart> items) {
    return CheckoutArguments(
      source: CheckoutSource.cart,
      cartItems: items,
    );
  }

  factory CheckoutArguments.fromProduct({
    required ProductByIdEntity product,
    required int selectedVariantIndex,
  }) {
    return CheckoutArguments(
      source: CheckoutSource.product,
      product: product,
      selectedVariantIndex: selectedVariantIndex,
    );
  }
}
