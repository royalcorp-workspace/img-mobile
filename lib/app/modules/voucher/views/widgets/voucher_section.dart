import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/voucher/views/widgets/voucher_card.dart';

class VoucherSection extends StatelessWidget {
  final String image,
      title,
      description,
      titleVoucher,
      subtitleVoucher,
      codeVoucher;
  final int itemCount;
  final bool isSelected;
  final void Function()? onTap;

  const VoucherSection({
    super.key,
    required this.title,
    required this.image,
    required this.itemCount,
    required this.description,
    required this.titleVoucher,
    required this.subtitleVoucher,
    required this.codeVoucher,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              Helper.getImagePath(image),
              height: 60,
              width: 60,
            ),
            10.horizontalSpace,
            Text(
              title,
              style: AppTextStyle.largeBlackBold,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...List.generate(
          itemCount,
          (index) => VoucherCard(
            titleVoucher: titleVoucher,
            subtitleVoucher: subtitleVoucher,
            title: title,
            description: description,
            codeVoucher: codeVoucher,
            isSelected: isSelected,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
