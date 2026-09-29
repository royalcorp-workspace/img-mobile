import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/modules/home/widgets/home_category_section.dart';
import 'package:img/app/modules/home/widgets/icon_badge.dart';
import 'package:img/app/modules/home/widgets/product_card.dart';
import 'package:img/app/routes/app_pages.dart';

import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            5.verticalSpace,
            // Categories horizontal list
            Obx(
              () => CategorySection(
                showTitle: true,
                categories: controller.category.toList(),
                selectedCategoryId: controller.selectedCategoryId.value,
                onSelectCategory: (cat) {
                  Get.toNamed(
                    Routes.CATEGORY_PRODUCT,
                    arguments: {
                      'categories': controller.category.toList(),
                      if (cat != null) 'selectedCategory': cat,
                      if (cat != null) 'categoryId': cat.id,
                    },
                  );
                },
                categoryScrollController: controller.categoryScrollController,
                isLoadingMore: controller.isLoadingMoreCategories.value,
              ),
            ),

            _buildHomepageContent(),
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
      if (controller.isLoadingHomepageContent.value && sections.isEmpty) {
        return const _HomepageContentShimmer();
      }
      if (sections.isEmpty) return const SizedBox();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sections.map((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: AppTextStyle.largeBlackBold,
                ),
                10.verticalSpace,
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSingleProduct = section.items.data.length == 1;

                    ProductsCard buildProductCard(int index) {
                      final product = section.items.data[index];
                      final thumbnailUrlStr =
                          product.thumbnailUrl?.toString() ?? '';
                      final thumbnailStr = product.thumbnail?.toString() ?? '';
                      final imageStr = product.image?.toString() ?? '';
                      final imageUrl = thumbnailUrlStr.isNotEmpty
                          ? thumbnailUrlStr
                          : (thumbnailStr.isNotEmpty ? thumbnailStr : imageStr);

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
                        width: isSingleProduct ? constraints.maxWidth : null,
                        formattedOriginalPrice:
                            Helper.formatCurrency(product.basePrice.toInt()),
                        formattedPrice:
                            Helper.formatCurrency(product.sellPrice.toInt()),
                        imageProvider: imageProvider,
                        rating: product.reviewCount.toStringAsFixed(1),
                        review: '(${product.totalReviews})',
                        title: product.name,
                        onTap: (_) => controller.fetchProductByID(product.id),
                      );
                    }

                    if (isSingleProduct) {
                      return buildProductCard(0);
                    }

                    return SizedBox(
                      height: 220.h,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: section.items.data.length,
                        separatorBuilder: (_, __) => 10.horizontalSpace,
                        itemBuilder: (_, index) => buildProductCard(index),
                      ),
                    );
                  },
                ),
                15.verticalSpace,
              ],
            );
          }).toList(),
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 48.h,
      automaticallyImplyLeading: false,
      title: SizedBox(
          width: 280.w,
          child: SearchAnchor(
            viewBackgroundColor: AppColors.white,
            viewShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            viewLeading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
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
                child: IgnorePointer(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Text(
                            'Cari produk, brand atau kategori...',
                            style: AppTextStyle.mediumBlackSecondary.copyWith(
                              color: AppColors.grey,
                              fontSize: 11.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController sc) async {
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
                    subtitle: const Text(
                      'Cari produk berdasarkan kata kunci',
                      style: AppTextStyle.mediumBlack,
                    ),
                    onTap: () {
                      sc.closeView(keyword);
                      controller.fetchProducts(
                          search: keyword, categoryId: null);
                    },
                  ),
                );
                suggestions.add(
                  const Divider(color: AppColors.lightGrey, thickness: 1.2),
                );
              }

              // Tag Suggestions
              final matchingTags = controller.productTags.where((tag) {
                final name = tag.name;
                return keyword.isEmpty ||
                    name.toLowerCase().contains(keyword.toLowerCase());
              }).toList();

              if (matchingTags.isNotEmpty) {
                suggestions.add(
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: const Text(
                      'Tag Produk',
                      style: AppTextStyle.mediumBlackBold,
                    ),
                  ),
                );
                for (final tag in matchingTags) {
                  final tagItem = tag;
                  suggestions.add(
                    ListTile(
                      leading: const Icon(Icons.label_outlined,
                          color: AppColors.primaryColor),
                      title: Text(tagItem.name,
                          style: AppTextStyle.mediumBlackBold),
                      onTap: () {
                        sc.closeView(tagItem.name);
                        Get.toNamed(
                          Routes.CATEGORY_PRODUCT,
                          arguments: {
                            'selectedTag': tagItem,
                            'tagId': tagItem.id,
                            'tags': controller.productTags,
                          },
                        );
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: const Text(
                      'Hasil Produk',
                      style: AppTextStyle.mediumGreyBold,
                    ),
                  ),
                );

                final apiProducts =
                    await controller.searchProductsFromApi(keyword);
                if (apiProducts.isEmpty) {
                  suggestions.add(
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: const Text(
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
                        title: Text(prod.name,
                            style: AppTextStyle.mediumBlackBold),
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
          )),
      backgroundColor: AppColors.primaryColor,
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
              icon: GestureDetector(
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

class _HomepageContentShimmer extends StatefulWidget {
  const _HomepageContentShimmer();

  @override
  State<_HomepageContentShimmer> createState() =>
      _HomepageContentShimmerState();
}

class _HomepageContentShimmerState extends State<_HomepageContentShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final offset = (_controller.value * 2) - 1;
            return LinearGradient(
              begin: Alignment(offset - 1, 0),
              end: Alignment(offset + 1, 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF7F7F7),
                Color(0xFFE8E8E8),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: const _HomepageContentPlaceholder(),
    );
  }
}

class _HomepageContentPlaceholder extends StatelessWidget {
  const _HomepageContentPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(2, (sectionIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: sectionIndex == 0 ? 150.w : 120.w,
                height: 22.h,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              10.verticalSpace,
              SizedBox(
                height: 220.h,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => 10.horizontalSpace,
                  itemBuilder: (_, __) => ProductCardShimmer(
                    height: 220.h,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
