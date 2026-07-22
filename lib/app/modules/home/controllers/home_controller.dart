import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:pos_royal/app/modules/home/views/home_view.dart';
import 'package:pos_royal/app/modules/home/widgets/parts_product.dart';
import 'package:pos_royal/app/shared/widgets/app_banner.dart';

class HomeController extends GetxController {
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var cartQuantityItems = 0.obs;

  /// List Slider
  List<CustomBanner> customBannerListSlider = [
    const CustomBanner(imagePath: 'img_banner.jpeg'),
    const CustomBanner(imagePath: 'img_banner.jpeg'),
    const CustomBanner(imagePath: 'img_banner.jpeg'),
  ];

  /// List Parts Product
  List<PartsProduct> customPartsProduct = [
    const PartsProduct(imagePath: 'img_bed_home.png', title: 'Kasur'),
    const PartsProduct(imagePath: 'img_pillow_home.png', title: 'Bantal'),
    const PartsProduct(imagePath: 'img_rolls_home.png', title: 'Guling'),
    const PartsProduct(imagePath: 'img_acc_home.png', title: 'Aksesoris'),
  ];

  /// List Brands
  List<CategoryBrand> customBrand = [
    const CategoryBrand(imagePath: 'img_brand1.png'),
    const CategoryBrand(imagePath: 'img_brand2.png'),
    const CategoryBrand(imagePath: 'img_brand3.png'),
    const CategoryBrand(imagePath: 'img_brand4.png'),
    const CategoryBrand(imagePath: 'img_brand5.png'),
    const CategoryBrand(imagePath: 'img_brand6.png'),
  ];

  Future<void> addToCart(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);

    // Update state after animation completes
    cartQuantityItems++;

    // Run the cart badge animation
    await cartKey.currentState!.runCartAnimation(cartQuantityItems.toString());
  }
}
