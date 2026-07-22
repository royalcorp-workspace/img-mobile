import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/modules/home/widgets/parts_product.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/modules/home/widgets/icon_badge.dart';
import 'package:pos_royal/app/modules/home/widgets/product_card.dart';
import 'package:pos_royal/app/modules/home/widgets/section_header.dart';
import 'package:pos_royal/app/routes/app_pages.dart';
import 'package:pos_royal/app/shared/widgets/app_banner.dart';
import 'package:pos_royal/app/shared/widgets/app_search_field.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            5.verticalSpace,
            CarouselSlider(
              items: controller.customBannerListSlider
                  .map(
                    (e) => CustomBanner(imagePath: e.imagePath),
                  )
                  .toList(),
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1,
                height: 122.h,
              ),
            ),
            20.verticalSpace,
            SizedBox(
              height: 68.h,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: controller.customPartsProduct
                    .map(
                      (e) => PartsProduct(
                        imagePath: e.imagePath,
                        title: e.title,
                      ),
                    )
                    .toList(),
              ),
            ),
            20.verticalSpace,
            const SectionHeader(
              title: 'Brand Pilihan',
              actionText: 'Lihat Semua',
            ),
            12.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 55.h,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 6,
                  crossAxisSpacing: 5.w,
                  childAspectRatio: 0.95,
                  shrinkWrap: true,
                  children: controller.customBrand
                      .map(
                        (e) => CategoryBrand(
                          imagePath: e.imagePath,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            15.verticalSpace,
            const SectionHeader(
              title: 'Promo Spesial Untukmu',
              actionText: 'Lihat Semua',
            ),
            12.verticalSpace,
            _buildPromoList(),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 70.h,
      automaticallyImplyLeading: false,
      leadingWidth: 50,
      leading: Image.asset(
        Helper.getImagePath('img_logo.webp'),
      ),
      title: const AppSearchField(),
      // backgroundColor: AppColors.primaryColor,
      actions: [
        const IconBadge(
          iconPath: 'ic_notification.svg',
          count: 0,
        ),
        2.horizontalSpace,
        AddToCartIcon(
          key: controller.cartKey,
          icon: InkWell(
            onTap: () => Get.toNamed(Routes.CART),
            child: IconBadge(
              iconPath: 'ic_cart.svg',
              count: 1,
            ),
          ),
          badgeOptions: const BadgeOptions(
            width: 0,
            height: 0,
            fontSize: 0,
            active: false,
          ),
        ),
        7.horizontalSpace,
      ],
    );
  }

  Widget _buildPromoList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(2, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index == 1 ? 0 : 10),
            child: ProductsCard(
              onTap: (p0) => Get.toNamed(Routes.DETAIL_PRODUCT),
            ),
          );
        }),
      ),
    );
  }
}

class CategoryBrand extends StatelessWidget {
  const CategoryBrand({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 50.h,
      width: 50.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.08),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lightGrey),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              Helper.getImagePath(imagePath),
            ),
          ),
        ),
      ),
    );
  }
}
