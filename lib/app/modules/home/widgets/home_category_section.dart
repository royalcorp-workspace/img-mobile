import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/domain/entities/category_entity.dart';

class CategoryItemData {
  final String id;
  final String name;
  final IconData icon;
  final String? imagePath;

  const CategoryItemData({
    required this.id,
    required this.name,
    required this.icon,
    this.imagePath,
  });
}

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onSelectCategory,
    this.isLoadingMore = false,
    this.categoryScrollController,
    this.showTitle = false,
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<CategoryEntity?>? onSelectCategory;
  final bool isLoadingMore;
  final ScrollController? categoryScrollController;
  final bool showTitle;

  // static IconData _getIconForCategoryName(String name) {
  //   final lower = name.toLowerCase();
  //   if (lower.contains('kasur') ||
  //       lower.contains('bed') ||
  //       lower.contains('mattress')) {
  //     return Icons.bed_rounded;
  //   } else if (lower.contains('bantal') || lower.contains('pillow')) {
  //     return Icons.single_bed_rounded;
  //   } else if (lower.contains('sprei') || lower.contains('sheet')) {
  //     return Icons.texture_rounded;
  //   } else if (lower.contains('bedcover') ||
  //       lower.contains('cover') ||
  //       lower.contains('blanket')) {
  //     return Icons.dry_cleaning_rounded;
  //   } else if (lower.contains('aksesoris') ||
  //       lower.contains('accessory') ||
  //       lower.contains('aksesori')) {
  //     return Icons.card_giftcard_rounded;
  //   } else if (lower.contains('semua') || lower.contains('all')) {
  //     return Icons.widgets_rounded;
  //   }
  //   return Icons.category_rounded;
  // }

  @override
  Widget build(BuildContext context) {
    // Build category list with "Semua" as the first item
    final List<_CategoryDisplayItem> items = [];

    // Dynamic categories from API or default fallback categories
    if (categories.isNotEmpty) {
      for (final cat in categories) {
        items.add(_CategoryDisplayItem(
          id: cat.id,
          name: cat.name,
          icon: Icons.category_rounded,
          imagePath: cat.image,
          entity: cat,
        ));
      }
    }
    // else {
    //   // Default fallback items matching Reference Image structure
    //   items.addAll([
    //     _CategoryDisplayItem(
    //         id: 'kasur', name: 'Kasur', icon: Icons.bed_rounded),
    //     _CategoryDisplayItem(
    //         id: 'bantal', name: 'Bantal', icon: Icons.single_bed_rounded),
    //     _CategoryDisplayItem(
    //         id: 'sprei', name: 'Sprei', icon: Icons.texture_rounded),
    //     _CategoryDisplayItem(
    //         id: 'bedcover', name: 'Bedcover', icon: Icons.dry_cleaning_rounded),
    //     _CategoryDisplayItem(
    //         id: 'aksesoris',
    //         name: 'Aksesoris',
    //         icon: Icons.card_giftcard_rounded),
    //   ]);
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTitle)
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              'Kategori Produk',
              style: AppTextStyle.mediumBlackBold.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(
          height: 80.h,
          child: ListView.separated(
            controller: categoryScrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: items.length + (isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return SizedBox(
                  width: 30.w,
                  child: const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                );
              }

              final item = items[index];
              final isSelected = selectedCategoryId == item.id ||
                  (selectedCategoryId == null && item.id == null);

              // Styling specific for "Semua" or selected items as seen in reference image
              final bool isAllCategory = item.id == null;
              final Color circleBgColor = isSelected
                  ? (isAllCategory
                      ? const Color(0xFF1B2A4A)
                      : AppColors.primaryColor)
                  : (isAllCategory
                      ? const Color(0xFF1B2A4A)
                      : const Color(0xFFF3F4F6));

              final Color iconColor = (isAllCategory || isSelected)
                  ? Colors.white
                  : AppColors.darkBrown;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelectCategory?.call(item.entity),
                  borderRadius: BorderRadius.circular(16.r),
                  child: SizedBox(
                    width: 50.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: circleBgColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? (isAllCategory
                                      ? const Color(0xFF1B2A4A)
                                      : AppColors.primaryColor)
                                  : AppColors.lightGrey.withOpacity(0.5),
                              width: 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: (isAllCategory
                                              ? const Color(0xFF1B2A4A)
                                              : AppColors.primaryColor)
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            item.icon,
                            size: 24.sp,
                            color: iconColor,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.smallBlack.copyWith(
                            fontSize: 10.sp,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryDisplayItem {
  final String? id;
  final String name;
  final IconData icon;
  final String? imagePath;
  final CategoryEntity? entity;

  _CategoryDisplayItem({
    required this.id,
    required this.name,
    required this.icon,
    this.imagePath,
    this.entity,
  });
}
