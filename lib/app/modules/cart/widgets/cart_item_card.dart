import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/cart/controllers/cart_controller.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.controller,
  });

  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(
              color: AppColors.lightGrey,
            ),
            bottom: BorderSide(
              color: AppColors.lightGrey,
            ),
          )),
          width: Get.width,
          child: Row(
            children: [
              Obx(
                () => Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  side: BorderSide(color: AppColors.lightGrey),
                  fillColor: WidgetStatePropertyAll(
                    controller.selectedCart.value
                        ? AppColors.primaryColor
                        : AppColors.lightGrey,
                  ),
                  value: controller.selectedCart.value,
                  checkColor: AppColors.white,
                  onChanged: (e) {
                    controller.selectedCart.value = e ?? false;
                  },
                ),
              ),
              Image.asset(
                height: 85.h,
                width: 85.w,
                Helper.getImagePath(
                  'img_product1.jpg',
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Elite Springbed Kasur Pocket Emporium New Edition",
                      style: AppTextStyle.mediumBlackBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Promo kemerdekaan + Gratis Ongkir',
                      style: AppTextStyle.mediumGrey,
                    ),
                    25.verticalSpace,
                    Text(
                      'Rp 1.087.210',
                      style: AppTextStyle.mediumBlackBold,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 12,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            width: 98,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: controller.selectedQty.value == 1
                        ? controller.showDeleteConfirmationDialog
                        : controller.decrementQty,
                    child: Icon(
                      controller.selectedQty.value == 1
                          ? Icons.delete_outline
                          : Icons.remove,
                      color: controller.selectedQty.value == 1
                          ? AppColors.red
                          : AppColors.blackSecondary,
                    ),
                  ),
                  Text(
                    '${controller.selectedQty}',
                    style: AppTextStyle.largeBlackBold,
                  ),
                  InkWell(
                    onTap: controller.incrementQty,
                    child: Icon(
                      Icons.add,
                      color: AppColors.blackSecondary,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
