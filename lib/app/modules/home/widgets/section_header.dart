import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    this.onActionTap,
  });

  final String title, actionText;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return RPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTextStyle.largeBlackBold.copyWith(
                fontSize: 10.5.sp,
              )),
          InkWell(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: AppTextStyle.smallBlackBold.copyWith(
                fontSize: 10.5.sp,
                color: AppColors.brownAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
