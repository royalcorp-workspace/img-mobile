import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

class CheckoutItemCard extends StatelessWidget {
  const CheckoutItemCard({
    super.key,
    required this.name,
    required this.attributes,
    required this.promoDesc,
    required this.price,
    required this.qty,
    required this.onTapDecrement,
    required this.onTapIncrement,
  });

  final String name, attributes, promoDesc;
  final int qty, price;
  final void Function()? onTapDecrement, onTapIncrement;

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
            ),
          ),
          width: Get.width,
          child: Row(
            children: [
              Image.asset(
                height: 80,
                width: 80,
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
                      '$name $attributes',
                      style: AppTextStyle.mediumBlackBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      promoDesc,
                      style: AppTextStyle.mediumGrey,
                    ),
                    10.verticalSpace,
                    Text(
                      Helper.formatCurrency(price),
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
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            width: 100.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onTapDecrement,
                  child: Icon(
                    Icons.remove,
                    size: 20,
                    color: AppColors.blackSecondary,
                  ),
                ),
                Text(
                  '$qty',
                  style: AppTextStyle.mediumBlack,
                ),
                InkWell(
                  onTap: onTapIncrement,
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: AppColors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
