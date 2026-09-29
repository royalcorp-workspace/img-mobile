import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class CategoryBrand extends StatelessWidget {
  const CategoryBrand({
    super.key,
    required this.imagePath,
    this.name = '',
    this.onTap,
  });

  final String? imagePath;
  final String name;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final image = imagePath?.trim() ?? '';
    final hasImage = image.isNotEmpty;
    final isNetworkImage =
        image.startsWith('http://') || image.startsWith('https://');

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 92.w,
        height: 92.w,
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: AppColors.white12,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: hasImage
              ? Image(
                  image: isNetworkImage
                      ? NetworkImage(image)
                      : AssetImage(Helper.getImagePath(image)),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _buildNameFallback(),
                )
              : _buildNameFallback(),
        ),
      ),
    );
  }

  Widget _buildNameFallback() {
    return Container(
      color: AppColors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.all(4.r),
      child: Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTextStyle.mediumBlackBold.copyWith(fontSize: 11.sp),
      ),
    );
  }
}
