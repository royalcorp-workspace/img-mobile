import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: AppColors.red,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Berakhir 9 jam lagi",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.red,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(codeVoucher, style: AppTextStyle.mediumBlack600),
                          Text(
                            "Salin Kode",
                            style: AppTextStyle.mediumBlack600.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                          )
                        ],
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
