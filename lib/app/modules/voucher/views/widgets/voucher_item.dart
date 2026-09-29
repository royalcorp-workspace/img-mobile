import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/shared/widgets/voucher_clipper.dart';

class VoucherItem extends StatelessWidget {
  const VoucherItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: VoucherClipper(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voucher Bebas Ongkir',
              style: AppTextStyle.mediumBlackBold,
            ),
            Text(
              'Rp 7.000',
              style: AppTextStyle.mediumBlackBold,
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.timer_sharp,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                    8.horizontalSpace,
                    Text(
                      'Berakhir 9 jam lagi',
                      style: AppTextStyle.mediumGreyBold.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Lihat Detail',
                  style: AppTextStyle.mediumBlackBold.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
