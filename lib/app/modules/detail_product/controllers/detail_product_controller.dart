import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';

class DetailProductController extends GetxController {
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final GlobalKey widgetKey = GlobalKey();

  late Function(GlobalKey) runAddToCartAnimation;
  var cartQuantityItems = 0.obs;
  RxInt selectedIndex = 0.obs;

  var productByID = ProductByIdEntity().obs;

  /// List Size Product
  List sizeProduct = [
    "100x200",
    "120x200",
    "160x200",
    "180x200",
    "200x200",
  ];

  @override
  void onInit() {
    super.onInit();
    productByID(Get.arguments);
  }

  Future<void> addToCart(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);

    // Update state after animation completes
    cartQuantityItems++;

    // Run the cart badge animation
    await cartKey.currentState!.runCartAnimation(cartQuantityItems.toString());
  }
}
