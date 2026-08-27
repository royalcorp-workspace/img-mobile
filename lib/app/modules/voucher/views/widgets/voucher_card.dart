import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

class VoucherCard extends StatelessWidget {
  const VoucherCard({
    super.key,
    required this.title,
    required this.description,
    required this.codeVoucher,
    required this.isSelected,
    this.onTap,
  });

  final String title, description, codeVoucher;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.creamGold, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    Helper.getImagePath('img_discount.png'),
                    height: 50.h,
                    width: 50.w,
                  ),
                  8.horizontalSpace,
                  Text(
                    title,
                    style: AppTextStyle.mediumBlackBold,
                  ),
                ],
              ),
              5.verticalSpace,
              Text(
                description,
                style: AppTextStyle.mediumGrey,
              ),
              12.verticalSpace,
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: AppColors.red,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Berakhir 9 jam lagi",
                    style: AppTextStyle.smallBlack
                        .copyWith(color: AppColors.redContrast),
                  )
                ],
              ),
              10.verticalSpace,
              Row(
                children: List.generate(
                  30,
                  (index) => Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
              Container(
                padding: REdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(codeVoucher, style: AppTextStyle.mediumBlack600),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: codeVoucher));

                        Get.snackbar(
                          'Berhasil!',
                          'Copied to clipboard!',
                          backgroundColor: AppColors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Text(
                        "Salin Kode",
                        style: AppTextStyle.smallBlackBold.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
