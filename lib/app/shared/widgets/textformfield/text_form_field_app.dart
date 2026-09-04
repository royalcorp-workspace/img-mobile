import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class TextFormfieldApp extends StatelessWidget {
  const TextFormfieldApp({
    super.key,
    this.controller,
    this.keyboardType,
    this.title,
    this.prefix,
    this.hintText,
    this.maxLines = 1,
  });

  final String? title, hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: AppTextStyle.mediumBlackBold,
        ),
        5.verticalSpace,
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.02),
                offset: const Offset(0, -4),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyle.mediumBlack,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyle.mediumGrey,
              fillColor: AppColors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.lightGrey),
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(14),
              ),
              prefix: prefix,
            ),
          ),
        ),
      ],
    );
  }
}
