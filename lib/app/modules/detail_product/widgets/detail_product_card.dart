import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';

class DetailProductCard extends StatelessWidget {
  const DetailProductCard({super.key, required this.widgetKey});

  final GlobalKey widgetKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widgetKey,
      height: 250,
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
