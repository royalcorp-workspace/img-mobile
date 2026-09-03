import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/cart/widgets/cart_item_card.dart';
import 'package:pos_royal/app/modules/checkout/models/checkout_arguments.dart';
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
      body: Obx(
        () {
          if (controller.isLoading.value && controller.carts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          final items = controller.cartItems;
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'Keranjang kamu kosong',
                style: AppTextStyle.largeBlackBold,
              ),
            );
          }

          return CustomScrollView(
            controller: controller.pageScrollController,
            slivers: [
              SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final itemId = item.id ?? controller.uniqueKeyForItem(item);

                  return Obx(
                    () => CartItemCard(
                      name: item.name ?? item.product?.name ?? '',
                      description: item.product?.slug ?? '',
                      price: Helper.formatCurrency((item.unitPrice).toInt()),
                      quantity: controller.getItemQuantity(itemId),
                      fillColor: WidgetStatePropertyAll(
                        controller.isItemSelected(itemId)
                            ? AppColors.primaryColor
                            : AppColors.lightGrey,
                      ),
                      value: controller.isItemSelected(itemId),
                      onChanged: (e) {
                        controller.toggleItemSelection(itemId, e ?? false);
                      },
                      decrement: () {
                        controller.decrementQty(itemId);
                      },
                      increment: () {
                        controller.incrementQty(itemId);
                      },
                    ),
                  );
                },
              ),
              _buildLoadMoreIndicator()
            ],
          );
        },
      ),
      bottomNavigationBar: Obx(
        () => Container(
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
                height: 68.h,
                child: Column(
                  children: [
                    // 15.verticalSpace,
                    // InkWell(
                    //   radius: 12,
                    //   onTap: () => Get.toNamed(Routes.VOUCHER),
                    //   child: Container(
                    //     padding:
                    //         EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    //     width: Get.width,
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: AppColors.lightGrey),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Icon(
                    //               Icons.discount_outlined,
                    //               size: 20,
                    //               color: AppColors.primaryColor,
                    //             ),
                    //             15.horizontalSpace,
                    //             Text(
                    //               'Lebih hemat pakai voucher',
                    //               style: AppTextStyle.mediumBlackBold,
                    //             ),
                    //           ],
                    //         ),
                    //         Icon(
                    //           Icons.arrow_forward_ios_outlined,
                    //           size: 20,
                    //           color: AppColors.black,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Tagihan',
                              style: AppTextStyle.mediumBlack,
                            ),
                            Text(
                              controller.hasSelectedItems
                                  ? Helper.formatCurrency(
                                      controller.selectedTotalPrice.toInt())
                                  : '-',
                              style: AppTextStyle.largeBlackBold,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            final selectedItems = controller.selectedCartItems;
                            if (selectedItems.isEmpty) return;

                            Get.toNamed(
                              Routes.CHECKOUT,
                              arguments: CheckoutArguments.fromCart(
                                selectedItems,
                              ),
                            );
                          },
                          child: Container(
                            height: 35.h,
                            width: 148.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: controller.hasSelectedItems
                                    ? AppColors.primaryColor
                                    : AppColors.grey,
                              ),
                              color: controller.hasSelectedItems
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
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return !controller.isLoadingMore.value
        ? SliverToBoxAdapter()
        : SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: AppColors.primaryColor, strokeWidth: 2.5),
                ),
              ),
            ),
          );
  }
}
