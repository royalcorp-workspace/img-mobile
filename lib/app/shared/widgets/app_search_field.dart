import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

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
        suffixIcon: Container(
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.only(left: 5, top: 5, right: 15, bottom: 5),
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
