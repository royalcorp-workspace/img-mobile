// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';

class DetailProductCard extends StatelessWidget {
  const DetailProductCard({
    super.key,
    required this.widgetKey,
    required this.imageUrls,
    this.pageController,
  });

  final GlobalKey widgetKey;
  final List<String> imageUrls;
  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    final images = imageUrls.where((url) => url.isNotEmpty).toList();
    final galleryHeight = MediaQuery.sizeOf(context).width * 1;

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
