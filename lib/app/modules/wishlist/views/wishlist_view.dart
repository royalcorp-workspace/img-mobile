import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/cart/controllers/cart_controller.dart';
import 'package:pos_royal/app/modules/home/widgets/icon_badge.dart';
import 'package:pos_royal/app/modules/wishlist/views/widgets/wishlist_card.dart';

import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: GridView.builder(
        padding: const EdgeInsets.all(14),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.64,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return const WishlistCard();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Wishlist',
        style: AppTextStyle.xxLargeWhiteBold,
      ),
      backgroundColor: AppColors.primaryColor,
      elevation: 2,
      centerTitle: true,
      actions: [
        GetBuilder<CartController>(
          builder: (cartController) {
            return AddToCartIcon(
              key: controller.cartKey,
              icon: InkWell(
                onTap: () => Get.back(),
                child: IconBadge(
                  iconPath: 'ic_cart.svg',
                  count: cartController.cartItemCount,
                ),
              ),
              badgeOptions: const BadgeOptions(
                width: 0,
                height: 0,
                fontSize: 0,
                active: false,
              ),
            );
          },
        ),
      ],
    );
  }
}
