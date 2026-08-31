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
      body: CustomScrollView(
        controller: controller.pageScrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                5.verticalSpace,
                CarouselSlider(
                  items: controller.customBannerListSlider
                      .map((e) => CustomBanner(imagePath: e.imagePath))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 1,
                    height: 122.h,
                  ),
                ),
                20.verticalSpace,
                SizedBox(
                  height: 70.h,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    children: controller.customPartsProduct
                        .map((e) => PartsProduct(
                            imagePath: e.imagePath, title: e.title))
                        .toList(),
                  ),
                ),
                18.verticalSpace,
                const SectionHeader(title: 'Kategori Pilihan', actionText: ''),
                12.verticalSpace,
                RPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: 55.h,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 6,
                      crossAxisSpacing: 5.w,
                      childAspectRatio: 0.95,
                      shrinkWrap: true,
                      children: controller.customBrand
                          .map((e) => CategoryBrand(imagePath: e.imagePath))
                          .toList(),
                    ),
                  ),
                ),
                15.verticalSpace,
                const SectionHeader(
                    title: 'Promo Spesial Untukmu', actionText: ''),
                12.verticalSpace,
              ],
            ),
          ),
          _buildProductGrid(),
          _buildLoadMoreIndicator()
        ],
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
        IconBadge(
          iconPath: 'ic_notification.svg',
          count: 1,
        ),
        2.horizontalSpace,
        AddToCartIcon(
          key: controller.cartKey,
          icon: InkWell(
            onTap: () => Get.toNamed(Routes.CART),
            child: Obx(
              () => IconBadge(
                iconPath: 'ic_cart.svg',
                count: controller.carts.length,
              ),
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

  Widget _buildProductGrid() {
    return Obx(() {
      if (controller.isLoadingProducts.value && controller.products.isEmpty) {
        return const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final product = controller.products[index];
              final title = product?.name ?? "-";

              if (product != null) {
                controller.priceVal = product!.finalPrice > 0
                    ? product!.finalPrice
                    : (product!.basePrice > 0
                        ? product!.basePrice
                        : (product!.variants.isNotEmpty
                            ? (product!.variants.first.finalPrice > 0
                                ? product!.variants.first.finalPrice
                                : product!.variants.first.price)
                            : 0.0));
                if (product!.basePrice > controller.priceVal) {
                  controller.originalPriceVal = product!.basePrice;
                }
              }
              controller.formattedPrice = product != null
                  ? Helper.formatCurrency(controller.priceVal.toInt())
                  : Helper.formatCurrency(0);
              controller.formattedOriginalPrice = controller.originalPriceVal >
                      0
                  ? Helper.formatCurrency(controller.originalPriceVal.toInt())
                  : '';
              controller.imageUrl = product?.thumbnail ??
                  (product?.images.isNotEmpty == true
                      ? product!.images.first.image
                      : '');
              final String rating =
                  (product?.avgRating ?? 4.2).toStringAsFixed(1);
              final String review = '(${product?.totalReviews ?? 128})';

              ImageProvider imageProvider;
              if (controller.imageUrl.startsWith('http://') ||
                  controller.imageUrl.startsWith('https://')) {
                imageProvider = NetworkImage(controller.imageUrl);
              } else {
                imageProvider = AssetImage(
                  Helper.getImagePath('img_product1.jpg'),
                );
              }

              return ProductsCard(
                formattedOriginalPrice: controller.formattedOriginalPrice,
                formattedPrice: controller.formattedPrice,
                imageProvider: imageProvider,
                rating: rating,
                review: review,
                title: title,
                onTap: (_) => controller.fetchProductByID(product.id),
              );
            },
            childCount: controller.products.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio:
                controller.formattedOriginalPrice.isEmpty ? .73 : .65,
          ),
        ),
      );
    });
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (!controller.isLoadingMore.value) return const SliverToBoxAdapter();
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: AppColors.primaryColor, strokeWidth: 2.5),
            ),
          ),
        ),
      );
    });
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
