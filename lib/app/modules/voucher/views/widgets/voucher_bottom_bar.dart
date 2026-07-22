import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

class VoucherBottomBar extends StatelessWidget {
  const VoucherBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      child: BottomAppBar(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Kamu Hemat',
                  style: AppTextStyle.mediumBlack,
                ),
                Text(
                  'Rp. 7.000',
                  style: AppTextStyle.largeBlackBold,
                ),
              ],
            ),
            InkWell(
              onTap: () => Get.back(),
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
                    style: AppTextStyle.largeWhiteBold,
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
