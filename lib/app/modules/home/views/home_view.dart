import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';

import 'package:get/get.dart';
import 'package:img/app/modules/home/widgets/category_brand.dart';
import 'package:img/app/modules/home/widgets/icon_badge.dart';
import 'package:img/app/modules/home/widgets/product_card.dart';
import 'package:img/app/modules/home/widgets/section_header.dart';
import 'package:img/app/modules/product/widgets/countdown_container.dart';
import 'package:img/app/modules/product/widgets/product_promotion_card.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/shared/widgets/app_banner.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/domain/entities/category_entity.dart';
import 'package:img/app/shared/widgets/app_divider.dart';
import 'package:img/app/shared/widgets/app_search_field.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          CustomScrollView(
            controller: controller.pageScrollController,
            slivers: [
              _buildEventsActive(),
              _buildCarousel(),
              _buildCategory(),
              _buildActiveFilterHeader(),
              _buildProductGrid(),
              _buildLoadMoreIndicator()
            ],
          ),
          Obx(
            () => AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                bottom: controller.showScrollToTop.value ? 24 : -70,
                right: 20,
                child: GestureDetector(
                  onTap: () => controller.scrollToTop(),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(
                      Icons.arrow_upward_outlined,
                      size: 18,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsActive() {
    return SliverToBoxAdapter(
      child: Obx(
        () => Visibility(
          visible: controller.searchQuery.value.trim().isEmpty &&
              controller.selectedCategoryId.value == null,
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return SliverToBoxAdapter(
      child: Obx(
        () => Visibility(
          visible: controller.searchQuery.value.trim().isEmpty &&
              controller.selectedCategoryId.value == null,
          child: Column(
            children: [
              5.verticalSpace,
              CarouselSlider(
                items: controller.banners
                    .map((e) => CustomBanner(imagePath: e.imageWebUrl))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 1,
                  height: 122.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return SliverToBoxAdapter(
      child: Obx(
        () => Visibility(
          visible: controller.searchQuery.value.trim().isEmpty &&
              controller.selectedCategoryId.value == null,
          child: Column(
            children: [
              20.verticalSpace,
              const SectionHeader(title: 'Brand Pilihan', actionText: ''),
              12.verticalSpace,
              SizedBox(
                height: 80.h,
                child: Obx(
                  () => ListView.separated(
                    controller: controller.categoryScrollController,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.category.length +
                        (controller.isLoadingMoreCategories.value ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(width: 2.w),
                    itemBuilder: (context, index) {
                      if (index >= controller.category.length) {
                        return SizedBox(
                          width: 50.w,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        );
                      }

                      final category = controller.category[index];
                      return CategoryBrand(
                        onTap: () {
                          Get.toNamed(
                            Routes.CATEGORY_PRODUCT,
                            arguments: {
                              'initialIndex': index,
                              'categories': controller.category.toList(),
                              'selectedCategory': category,
                              'categoryId': category.id,
                            },
                          );
                        },
                        imagePath: category.image,
                        name: category.name,
                      );
                    },
                  ),
                ),
              ),
              15.verticalSpace,
              const SectionHeader(
                  title: 'Produk Spesial Untukmu', actionText: ''),
              12.verticalSpace,
            ],
          ),
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
      title: SearchAnchor(
        viewBackgroundColor: AppColors.white,
        viewShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        viewLeading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black, // Change to your desired color
          onPressed: () {
            Get.back();
          },
        ),
        viewTrailing: [
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: AppColors.black,
            ),
            onPressed: () {
              controller.searchAnchorController.clear();
            },
          ),
        ],
        searchController: controller.searchAnchorController,
        builder: (context, searchController) {
          return InkWell(
            onTap: () => searchController.openView(),
            child: const IgnorePointer(
              child: AppSearchField(),
            ),
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController sc) async {
          final String keyword = sc.text.trim();
          final List<Widget> suggestions = [];

          if (keyword.isNotEmpty) {
            suggestions.add(
              ListTile(
                leading:
                    const Icon(Icons.search, color: AppColors.primaryColor),
                title: Text(
                  'Cari "$keyword"',
                  style: AppTextStyle.mediumBlackBold,
                ),
                subtitle: Text(
                  'Cari produk berdasarkan kata kunci',
                  style: AppTextStyle.mediumBlack,
                ),
                onTap: () {
                  sc.closeView(keyword);
                  controller.fetchProducts(search: keyword, categoryId: null);
                },
              ),
            );
            suggestions
                .add(const Divider(color: AppColors.lightGrey, thickness: 1.2));
          }

          // Category Suggestions
          final matchingCategories = controller.category.where((cat) {
            final name = cat.name;
            return keyword.isEmpty ||
                name.toLowerCase().contains(keyword.toLowerCase());
          }).toList();

          if (matchingCategories.isNotEmpty) {
            suggestions.add(
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  'Kategori',
                  style: AppTextStyle.mediumBlackBold,
                ),
              ),
            );
            for (final cat in matchingCategories) {
              final catName = cat.name;
              final catId = cat.id;
              suggestions.add(
                ListTile(
                  leading: const Icon(Icons.trending_up_outlined,
                      color: AppColors.grey),
                  title: Text(catName, style: AppTextStyle.mediumBlack),
                  onTap: () {
                    sc.closeView(catName);
                    controller.fetchProducts(categoryId: catId, search: '');
                  },
                ),
              );
            }
            suggestions.add(
              const Divider(color: AppColors.lightGrey, thickness: 1.2),
            );
          }

          // Live Product Suggestions from API
          if (keyword.isNotEmpty) {
            suggestions.add(
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  'Hasil Produk',
                  style: AppTextStyle.mediumGreyBold,
                ),
              ),
            );

            final apiProducts = await controller.searchProductsFromApi(keyword);
            if (apiProducts.isEmpty) {
              suggestions.add(
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Text(
                    'Tidak ada produk ditemukan',
                    style: AppTextStyle.mediumGrey,
                  ),
                ),
              );
            } else {
              for (final prod in apiProducts) {
                suggestions.add(
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined,
                        color: AppColors.primaryColor),
                    title: Text(prod.name, style: AppTextStyle.mediumBlackBold),
                    subtitle: Text(
                      Helper.formatCurrency(prod.finalPrice.toInt()),
                      style: AppTextStyle.mediumBlackBold,
                    ),
                    onTap: () {
                      sc.closeView(prod.name);
                      controller.fetchProductByID(prod.id);
                    },
                  ),
                );
              }
            }
          }

          return suggestions;
        },
      ),
      actions: [
        //** Next Phase **
        // IconBadge(
        //   iconPath: 'ic_notification.svg',
        //   count: 3,
        // ),
        // 2.horizontalSpace,
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

  Widget _buildActiveFilterHeader() {
    return Obx(() {
      final hasSearch = controller.searchQuery.value.isNotEmpty;
      final hasCategory = controller.selectedCategoryId.value != null;

      if (!hasSearch && !hasCategory) {
        return const SliverToBoxAdapter();
      }

      String filterText = '';

      if (hasSearch) {
        filterText = 'Pencarian: "${controller.searchQuery.value}"';
      }
      if (hasCategory) {
        final cat = controller.category.firstWhereOrNull(
          (c) => c.id == controller.selectedCategoryId.value,
        );
        final catName = cat is CategoryEntity ? cat.name : 'Kategori';
        if (filterText.isNotEmpty) {
          filterText += ' | Kategori: $catName';
        } else {
          filterText = 'Kategori: $catName';
        }
      }

      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    filterText,
                    style: AppTextStyle.mediumBlackBold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () => controller.fetchProducts(resetFilters: true),
                  child: Row(
                    children: [
                      Text(
                        'Reset Filter',
                        style: AppTextStyle.mediumBlack,
                      ),
                      4.horizontalSpace,
                      const Icon(Icons.close, size: 18, color: AppColors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProductGrid() {
    return Obx(() {
      if (controller.isLoadingProducts.value && controller.products.isEmpty) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const ProductCardShimmer(),
              childCount: 6,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .73,
            ),
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
              final variant = product?.variants.isNotEmpty == true
                  ? product!.variants.first
                  : null;
              final price = product == null
                  ? 0.0
                  : product.finalPrice > 0
                      ? product.finalPrice
                      : product.basePrice > 0
                          ? product.basePrice
                          : variant?.finalPrice != null &&
                                  variant!.finalPrice > 0
                              ? variant.finalPrice
                              : variant?.price ?? 0.0;
              final originalPrice = product == null
                  ? 0.0
                  : product.basePrice > price
                      ? product.basePrice
                      : (variant?.basePrice ?? 0) > price
                          ? (variant?.basePrice ?? 0.0)
                          : 0.0;
              final imageUrl = product?.thumbnail ??
                  (product?.images.isNotEmpty == true
                      ? product!.images.first.image
                      : '');
              final String rating =
                  (product?.avgRating ?? 4.2).toStringAsFixed(1);
              final String review = '(${product?.totalReviews ?? 128})';

              ImageProvider imageProvider;
              if (imageUrl.startsWith('http://') ||
                  imageUrl.startsWith('https://')) {
                imageProvider = NetworkImage(imageUrl);
              } else {
                imageProvider = AssetImage(
                  Helper.getImagePath('img_product1.jpg'),
                );
              }

              return ProductsCard(
                formattedOriginalPrice: originalPrice > 0
                    ? Helper.formatCurrency(originalPrice.toInt())
                    : '',
                formattedPrice: Helper.formatCurrency(price.toInt()),
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
            childAspectRatio: 0.53,
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
