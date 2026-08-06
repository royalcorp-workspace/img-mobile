import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/cart/widgets/cart_item_card.dart';
import 'package:pos_royal/app/routes/app_pages.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        title: const Text(
          'Keranjang',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
        actions: [
          RPadding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.WISHLIST),
              child: Icon(
                Icons.favorite_border,
                color: AppColors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [CartItemCard(controller: controller)],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, -8),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: BottomAppBar(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              height: 125.h,
              child: Column(
                children: [
                  15.verticalSpace,
                  InkWell(
                    radius: 12,
                    onTap: () => Get.toNamed(Routes.VOUCHER),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      width: Get.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.discount_outlined,
                                size: 20,
                                color: AppColors.primaryColor,
                              ),
                              15.horizontalSpace,
                              Text(
                                'Lebih hemat pakai voucher',
                                style: AppTextStyle.mediumBlackBold,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 20,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Pembayaran',
                            style: AppTextStyle.mediumBlack,
                          ),
                          Obx(
                            () => Text(
                              controller.selectedCart.value
                                  ? Helper.formatCurrency(
                                      controller.selectedPrice.value *
                                          controller.selectedQty.value)
                                  : '-',
                              style: AppTextStyle.largeBlackBold,
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () => controller.selectedCart.value
                            ? Get.toNamed(Routes.CHECKOUT, arguments: [
                                controller.selectedPrice.value,
                                controller.selectedQty.value,
                              ])
                            : null,
                        child: Obx(
                          () => Container(
                            height: 35.h,
                            width: 148.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: controller.selectedCart.value
                                    ? AppColors.primaryColor
                                    : AppColors.grey,
                              ),
                              color: controller.selectedCart.value
                                  ? AppColors.primaryColor
                                  : AppColors.grey,
                            ),
                            child: Center(
                              child: Text(
                                'Checkout',
                                style: AppTextStyle.largeWhiteBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
