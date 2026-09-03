import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/modules/cart/controllers/cart_controller.dart';
import 'package:pos_royal/app/modules/home/widgets/parts_product.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/modules/home/widgets/icon_badge.dart';
import 'package:pos_royal/app/modules/home/widgets/product_card.dart';
import 'package:pos_royal/app/modules/home/widgets/section_header.dart';
import 'package:pos_royal/app/routes/app_pages.dart';
import 'package:pos_royal/app/shared/widgets/app_banner.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/domain/entities/category_entity.dart';
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
          _buildCarouselandCategory(),
          _buildActiveFilterHeader(),
          _buildProductGrid(),
          _buildLoadMoreIndicator()
        ],
      ),
    );
  }

  Widget _buildCarouselandCategory() {
    return SliverToBoxAdapter(
      child: Obx(
        () => Visibility(
          visible: controller.searchQuery.value.trim().isEmpty &&
              controller.selectedCategoryId.value == null,
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
                      .map((e) =>
                          PartsProduct(imagePath: e.imagePath, title: e.title))
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
            final name = cat is CategoryEntity ? cat.name : cat.toString();
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
              final catName = cat is CategoryEntity ? cat.name : cat.toString();
              final catId = cat is CategoryEntity ? cat.id : null;
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
        IconBadge(
          iconPath: 'ic_notification.svg',
          count: 1,
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
          (c) =>
              c is CategoryEntity &&
              c.id == controller.selectedCategoryId.value,
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
