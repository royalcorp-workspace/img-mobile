import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: AppTextStyle.mediumBlack,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        suffixIcon: Container(
          padding: const EdgeInsets.all(4),
          margin:
              EdgeInsets.only(left: 15.w, top: 5.h, right: 8.w, bottom: 5.h),
          child: SvgPicture.asset(
            Helper.getSvgPath('ic_search.svg'),
            colorFilter: ColorFilter.mode(
              AppColors.brownAccent,
              BlendMode.srcIn,
            ),
          ),
        ),
        filled: true,
        fillColor: AppColors.greyWhite,
        hintText: 'Cari Produk, brand atau kategori...',
        hintStyle: AppTextStyle.mediumBlackSecondary,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.lightGrey,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.lightGrey,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
