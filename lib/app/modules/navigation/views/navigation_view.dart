import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/home/controllers/home_controller.dart';
import 'package:pos_royal/app/modules/home/views/home_view.dart';
import 'package:pos_royal/app/modules/order/views/order_view.dart';
import 'package:pos_royal/app/modules/product/views/product_view.dart';
import 'package:pos_royal/app/modules/setting/views/setting_view.dart';

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
          OrderView(),

          /// Setting page
          const SettingView(),
        ][controller.currentPageIndex.value],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.white,
            shadowColor: AppColors.lightGrey,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) => states.contains(WidgetState.selected)
                  ? AppTextStyle.smallBlackBold.copyWith(
                      color: AppColors.secondaryColor,
                    )
                  : AppTextStyle.smallGrey,
            ),
          ),
          child: NavigationBar(
            elevation: 15,
            onDestinationSelected: (int index) {
              if (index == 0) {
                if (Get.isRegistered<HomeController>()) {
                  Get.find<HomeController>().scrollToTop();
                }
              }
              controller.currentPageIndex.value = index;
            },
            indicatorColor: Colors.transparent,
            selectedIndex: controller.currentPageIndex.value,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: Image.asset(
                  width: 35,
                  height: 35,
                  Helper.getImagePath(
                    'img_home.png',
                  ),
                ),
                icon: Image.asset(
                  width: 35,
                  height: 35,
                  Helper.getImagePath(
                    'img_home_disable.png',
                  ),
                ),
                label: 'Beranda',
              ),
              NavigationDestination(
                selectedIcon: Image.asset(
                  width: 35,
                  height: 35,
                  Helper.getImagePath(
                    'img_products.png',
                  ),
                ),
                icon: Image.asset(
                  width: 35,
                  height: 35,
                  Helper.getImagePath(
                    'img_products_disable.png',
                  ),
                ),
                label: 'Produk',
              ),
              NavigationDestination(
                selectedIcon: Image.asset(
                  width: 35,
                  height: 35,
                  Helper.getImagePath(
                    'img_orders.png',
                  ),
                ),
                icon: Image.asset(
                  width: 35,
                  height: 35,
                  Helper.getImagePath(
                    'img_orders_disable.png',
                  ),
                ),
                label: 'Pesanan',
              ),
              NavigationDestination(
                selectedIcon: Image.asset(
                  width: 35,
                  height: 35,
                  Helper.getImagePath(
                    'img_settings.png',
                  ),
                ),
                icon: Image.asset(
                  width: 35,
                  height: 35,
                  Helper.getImagePath(
                    'img_settings_disable.png',
                  ),
                ),
                label: 'Pengaturan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
