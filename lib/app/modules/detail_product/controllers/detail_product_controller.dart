import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final GlobalKey widgetKey = GlobalKey();

  late Function(GlobalKey) runAddToCartAnimation;
  var cartQuantityItems = 0.obs;
  RxInt selectedIndex = 0.obs;

  /// List Size Product
  List sizeProduct = [
    "100x200",
    "120x200",
    "160x200",
    "180x200",
    "200x200",
  ];

  Future<void> addToCart(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);

    // Update state after animation completes
    cartQuantityItems++;

    // Run the cart badge animation
    await cartKey.currentState!.runCartAnimation(cartQuantityItems.toString());
  }
}
