import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({
    super.key,
    this.imagePath,
    this.height,
    this.borderRadius,
  });

  final String? imagePath;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final String path = (imagePath != null && imagePath!.trim().isNotEmpty)
        ? imagePath!
        : 'assets/images/img_banner.jpeg';

    final bool isNetwork =
        path.startsWith('http://') || path.startsWith('https://');

    return Container(
      width: Get.width,
      height: height ?? 150.h,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        child: isNetwork
            ? Image.network(
                path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  Helper.getImagePath('img_banner.jpeg'),
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                Helper.getImagePath(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  Helper.getImagePath('img_banner.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
