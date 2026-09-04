import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class FeaturedItem extends StatelessWidget {
  const FeaturedItem({
    super.key,
    required this.svgPath,
    required this.title,
    this.onTap,
  });

  final String svgPath, title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 88.h,
        width: 86.w,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: AppColors.lightGrey,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Helper.getSvgPath(svgPath),
              height: 35,
              width: 35,
            ),
            10.verticalSpace,
            Text(
              title,
              style: AppTextStyle.smallBlack,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
