import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/modules/home/widgets/icon_badge.dart';
import 'package:img/app/modules/product/widgets/countdown_container.dart';
import 'package:img/app/modules/product/widgets/product_promotion_card.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/shared/widgets/app_banner.dart';
import 'package:img/app/shared/widgets/app_divider.dart';
import 'package:img/app/shared/widgets/app_search_field.dart';

import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor, // same as top container
        statusBarIconBrightness: Brightness.light, // white icons
      ),
    );
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            15.verticalSpace,
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                padding: const EdgeInsets.only(left: 8, bottom: 5, right: 8),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) => Obx(
                  () => InkWell(
                    onTap: () => controller.selectedIndex.value = index,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: controller.selectedIndex.value == index
                              ? AppColors.primaryColor
                              : AppColors.lightGrey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          index == 0
                              ? 'Semua'
                              : index == 1
                                  ? 'Harga Terendah'
                                  : index == 2
                                      ? 'Promo'
                                      : 'Bebas Ongkir',
                          style: controller.selectedIndex.value == index
                              ? AppTextStyle.mediumBlack
                                  .copyWith(color: AppColors.primaryColor)
                              : AppTextStyle.mediumBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            15.verticalSpace,
            const CustomBanner(imagePath: 'img_banner5.png'),
            15.verticalSpace,
            Visibility(
              visible: controller.start.value != 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RPadding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Promo Diskon Hingga 78%',
                          style: AppTextStyle.largeBlackBold,
                        ),
                        Obx(
                          () => CountdownContainer(
                            text: controller.formattedTime,
                          ),
                        )
                      ],
                    ),
                  ),
                  15.verticalSpace,
                  RPadding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductPromotionCard(),
                        ProductPromotionCard(),
                        ProductPromotionCard(),
                        ProductPromotionCard(),
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  const AppDivider(),
                  20.verticalSpace,
                ],
              ),
            ),
            _buildHomepageContent(),

            // RPadding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: GridView.builder(
            //     physics: const NeverScrollableScrollPhysics(),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 10,
            //       childAspectRatio: 0.64,
            //     ),
            //     shrinkWrap: true,
            //     itemCount: 8,
            //     itemBuilder: (context, index) => ProductCard(
            //       onTap: (e) {},
            //     ),
            //   ),
            // ),

            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildHomepageContent() {
    return Obx(() {
      final sections = controller.homepageContent
          .where((section) => section.items.data.isNotEmpty)
          .toList();
      if (sections.isEmpty) return const SizedBox();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.map((section) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  section.title,
                  style: AppTextStyle.largeBlackBold,
                ),
              ),
              10.verticalSpace,
              SizedBox(
                height: 92.h,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: section.items.data.length,
                  separatorBuilder: (_, __) => 10.horizontalSpace,
                  itemBuilder: (context, index) {
                    final item = section.items.data[index];
                    return SizedBox(
                      width: 82.w,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: AppColors.greyWhite,
                            backgroundImage: item.logo == null
                                ? null
                                : NetworkImage(item.logo!),
                            child: item.logo == null
                                ? Text(
                                    item.name.isEmpty
                                        ? '?'
                                        : item.name[0].toUpperCase(),
                                    style: AppTextStyle.mediumBlackBold,
                                  )
                                : null,
                          ),
                          5.verticalSpace,
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.mediumBlack,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              15.verticalSpace,
            ],
          );
        }).toList(),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 70.h,
      automaticallyImplyLeading: false,
      title: SizedBox(
        width: 260.w,
        child: SearchAnchor(
          viewBackgroundColor: AppColors.white,
          searchController: controller.searchAnchorController,
          viewLeading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: Get.back,
          ),
          viewTrailing: [
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.black),
              onPressed: controller.searchAnchorController.clear,
            ),
          ],
          builder: (context, searchController) => InkWell(
            onTap: searchController.openView,
            child: const IgnorePointer(child: AppSearchField()),
          ),
          suggestionsBuilder: (context, searchController) {
            final keyword = searchController.text.trim();
            if (keyword.isEmpty) return const <Widget>[];
            return [
              ListTile(
                leading:
                    const Icon(Icons.search, color: AppColors.primaryColor),
                title: Text('Cari "$keyword"',
                    style: AppTextStyle.mediumBlackBold),
                onTap: () => searchController.closeView(keyword),
              ),
            ];
          },
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      actions: [
        const IconBadge(
          iconPath: 'ic_notification.svg',
          count: 3,
        ),
        2.horizontalSpace,
        GetBuilder<CartController>(
          builder: (cartController) {
            return AddToCartIcon(
              key: controller.cartKey,
              icon: InkWell(
                onTap: () => Get.toNamed(Routes.CART),
                child: IconBadge(
                  iconPath: 'ic_cart.svg',
                  count: cartController.cartItemCount,
                ),
              ),
              badgeOptions: const BadgeOptions(
                width: 0,
                height: 0,
                fontSize: 0,
                active: false,
              ),
            );
          },
        ),
        7.horizontalSpace,
      ],
    );
  }
}
