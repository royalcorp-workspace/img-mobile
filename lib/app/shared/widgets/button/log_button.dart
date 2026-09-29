import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';

class LogButton extends StatelessWidget {
  const LogButton({super.key, required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: 48.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48.h,
          width: 48.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(32.r)),
            color: color,
          ),
          child: Icon(
            Icons.bug_report,
            color: AppColors.black.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
