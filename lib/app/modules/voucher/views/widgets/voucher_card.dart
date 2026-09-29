import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class VoucherCard extends StatelessWidget {
  const VoucherCard({
    super.key,
    required this.title,
    required this.titleVoucher,
    required this.subtitleVoucher,
    required this.description,
    required this.codeVoucher,
    required this.isSelected,
    this.onTap,
  });

  final String title, titleVoucher, subtitleVoucher, description, codeVoucher;
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
        child: Row(
          children: [
            RPadding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(14)),
                    child: Text(
                      titleVoucher,
                      style: AppTextStyle.mediumWhiteBold,
                    ),
                  ),
                  SizedBox(height: 4),
                  titleVoucher == 'DISKON BELANJA'
                      ? Text(
                          subtitleVoucher,
                          style: AppTextStyle.xxxLargeWhiteBold.copyWith(
                            fontSize: 50,
                            color: AppColors.orange,
                          ),
                        )
                      : Icon(
                          Icons.local_shipping_outlined,
                          color: AppColors.orange,
                          size: 75,
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
                          '',
                          '',
                          titleText: Text('Berhasil',
                              style: AppTextStyle.largeWhiteBold),
                          messageText: Text('Tersalin ke clipboard!',
                              style: AppTextStyle.mediumWhite),
                          backgroundColor: AppColors.green,
                          colorText: AppColors.white,
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
            )
          ],
        ),
      ),
    );
  }
}
