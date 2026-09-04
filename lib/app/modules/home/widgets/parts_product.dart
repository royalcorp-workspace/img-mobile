import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class PartsProduct extends StatelessWidget {
  const PartsProduct({
    super.key,
    required this.imagePath,
    required this.title,
  });

  final String imagePath, title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50.h,
          width: 50.h,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.warmIvory,
          ),
          child: Image.asset(Helper.getImagePath(imagePath)),
        ),
        4.verticalSpace,
        Text(
          title,
          style: AppTextStyle.smallBlack,
        )
      ],
    );
  }
}
