import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class AddNotesWidget extends StatelessWidget {
  const AddNotesWidget({
    super.key,
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tambahkan Pesan',
          style: AppTextStyle.mediumBlackBold,
        ),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.lightGrey,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: controller,
            decoration: InputDecoration.collapsed(
              hintText: '(Optional) Tinggalkan pesan untuk penjual',
              hintStyle: AppTextStyle.mediumGrey,
            ),
            cursorColor: AppColors.primaryColor,
            style: AppTextStyle.mediumBlack,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
