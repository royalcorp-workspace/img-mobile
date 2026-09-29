import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class FilterSortBar extends StatelessWidget {
  const FilterSortBar({
    super.key,
    this.selectedSortOption = 'Terpopuler',
    this.onSortSelected,
    this.onFilterTap,
  });

  final String selectedSortOption;
  final ValueChanged<String>? onSortSelected;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.lightGrey, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Filter Button
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onFilterTap != null ? onFilterTap!() : _showFilterBottomSheet(context),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    bottomLeft: Radius.circular(14.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: 18.sp,
                          color: AppColors.darkBrown,
                        ),
                        6.horizontalSpace,
                        Text(
                          'Filter',
                          style: AppTextStyle.mediumBlack600.copyWith(
                            fontSize: 13.sp,
                          ),
                        ),
                        4.horizontalSpace,
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18.sp,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Middle Divider
            Container(
              width: 1,
              height: 22.h,
              color: AppColors.lightGrey,
            ),

            // Sort Button
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showSortBottomSheet(context),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14.r),
                    bottomRight: Radius.circular(14.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.import_export_rounded,
                          size: 18.sp,
                          color: AppColors.darkBrown,
                        ),
                        6.horizontalSpace,
                        Flexible(
                          child: Text(
                            'Urutkan',
                            style: AppTextStyle.mediumBlack600.copyWith(
                              fontSize: 13.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        4.horizontalSpace,
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18.sp,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    final sortOptions = [
      'Terpopuler',
      'Terbaru',
      'Harga: Rendah ke Tinggi',
      'Harga: Tinggi ke Rendah',
      'Rating Tertinggi',
    ];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.verticalSpace,
            Text(
              'Urutkan Produk',
              style: AppTextStyle.largeBlackBold.copyWith(fontSize: 18.sp),
            ),
            12.verticalSpace,
            ...sortOptions.map(
              (option) {
                final isSelected = selectedSortOption == option;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: isSelected
                        ? AppTextStyle.mediumBlackBold.copyWith(
                            color: AppColors.primaryColor,
                          )
                        : AppTextStyle.mediumBlack,
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primaryColor)
                      : null,
                  onTap: () {
                    Get.back();
                    onSortSelected?.call(option);
                  },
                );
              },
            ),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.verticalSpace,
            Text(
              'Filter Produk',
              style: AppTextStyle.largeBlackBold.copyWith(fontSize: 18.sp),
            ),
            16.verticalSpace,
            Text('Rentang Harga', style: AppTextStyle.mediumBlackBold),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Minimum',
                      prefixText: 'Rp ',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Text('-', style: AppTextStyle.mediumBlackBold),
                12.horizontalSpace,
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Maksimum',
                      prefixText: 'Rp ',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text(
                  'Terapkan Filter',
                  style: AppTextStyle.mediumWhiteBold,
                ),
              ),
            ),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }
}
