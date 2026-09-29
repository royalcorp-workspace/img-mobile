import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/modules/home/views/home_view.dart';
import 'package:img/app/modules/order/views/order_view.dart';
import 'package:img/app/modules/product/views/product_view.dart';
import 'package:img/app/modules/setting/views/setting_view.dart';

import '../controllers/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: [
          /// Home page
          const HomeView(),

          /// Product page
          const ProductView(),

          /// Pesanan page
          const OrderView(),

          /// Setting page
          const SettingView(),
        ][controller.currentPageIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 64.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    label: 'Beranda',
                    activeIconPath: 'img_home.png',
                    inactiveIconPath: 'img_home_disable.png',
                    fallbackIcon: Icons.home_rounded,
                  ),
                  _buildNavItem(
                    index: 1,
                    label: 'Produk',
                    activeIconPath: 'img_products.png',
                    inactiveIconPath: 'img_products_disable.png',
                    fallbackIcon: Icons.grid_view_rounded,
                  ),
                  _buildNavItem(
                    index: 2,
                    label: 'Pesanan',
                    activeIconPath: 'img_orders.png',
                    inactiveIconPath: 'img_orders_disable.png',
                    fallbackIcon: Icons.receipt_long_rounded,
                  ),
                  _buildNavItem(
                    index: 3,
                    label: 'Pengaturan',
                    activeIconPath: 'img_settings.png',
                    inactiveIconPath: 'img_settings_disable.png',
                    fallbackIcon: Icons.settings_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required String activeIconPath,
    required String inactiveIconPath,
    required IconData fallbackIcon,
  }) {
    final isSelected = controller.currentPageIndex.value == index;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => controller.currentPageIndex.value = index,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.asset(
                  Helper.getImagePath(
                    isSelected ? activeIconPath : inactiveIconPath,
                  ),
                  width: 26.w,
                  height: 26.w,
                  errorBuilder: (_, __, ___) => Icon(
                    fallbackIcon,
                    size: 24.sp,
                    color: isSelected ? AppColors.primaryColor : AppColors.grey,
                  ),
                ),
              ),
              3.verticalSpace,
              Text(
                label,
                style: AppTextStyle.smallBlackBold.copyWith(
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.blackSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
