import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return RPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Container(
          width: Get.width,
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                Helper.getImagePath(imagePath),
              ),
            ),
          ),
        ));
  }
}
