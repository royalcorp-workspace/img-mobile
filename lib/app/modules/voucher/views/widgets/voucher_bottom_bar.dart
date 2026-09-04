import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class VoucherBottomBar extends StatelessWidget {
  const VoucherBottomBar({super.key, required this.value, this.onTap});

  final int value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      child: BottomAppBar(
        height: 85.h,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kamu Hemat',
                  style: AppTextStyle.mediumBlack,
                ),
                Text(
                  Helper.formatCurrency(value),
                  style: AppTextStyle.largeBlackBold,
                ),
              ],
            ),
            InkWell(
              onTap: onTap ?? () => Get.back(),
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryColor,
                ),
                child: const Center(
                  child: Text(
                    'Pakai Voucher',
                    style: AppTextStyle.mediumWhiteBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
