import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';

class DetailProductCard extends StatelessWidget {
  const DetailProductCard({super.key, required this.widgetKey});

  final GlobalKey widgetKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widgetKey,
      height: 200.h,
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        fit: BoxFit.cover,
        Helper.getImagePath('img_product1.jpg'),
      ),
    );
  }
}
