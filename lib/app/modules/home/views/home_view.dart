import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/modules/home/widgets/event_timer_card.dart';
import 'package:img/app/modules/home/widgets/icon_badge.dart';
import 'package:img/app/modules/home/widgets/product_card.dart';
import 'package:img/app/modules/home/widgets/section_header.dart';
import 'package:img/app/modules/home/widgets/shortcut_section.dart';
import 'package:img/app/shared/widgets/app_banner.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/shared/widgets/custom_shimmer.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: controller.cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
        duration: Duration(milliseconds: 500),
      ),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        controller.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFAF5EE),
                Color(0xFFEDE2D2),
                Color(0xFFDFCFBB),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              CustomScrollView(
                controller: controller.pageScrollController,
                slivers: [
                  // 1. Full-Bleed Banner + Overlay Content (Top Bar + Search + Hero Banner)
                  _buildFullBleedHeroHeader(context),

                  // 2. White Rounded Overlapping Container (Categories, Shortcuts, Filter/Sort, Promo Banner, Section Header)
                  _buildMainBodyContainer(),
                ],
              ),

              // Scroll to top floating button
              Obx(
                () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  bottom: controller.showScrollToTop.value ? 24 : -70,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => controller.scrollToTop(),
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_upward_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Full-Bleed Hero Header containing App Header, Search Bar & Hero Banner Content
  Widget _buildFullBleedHeroHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() {
        final isFilterActive = controller.searchQuery.value.trim().isNotEmpty ||
            controller.selectedCategoryId.value != null;

        if (isFilterActive) {
          return SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: _buildSearchBarInput(context),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Top Bar: Logo + Cart Badge + Notification Badge
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 6.h,
                left: 4.w,
                right: 4.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Logo
                  Image.asset(
                    Helper.getImagePath('img_logo.webp'),
                    height: 34.h,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'IMG',
                          style: AppTextStyle.largeBlackBold.copyWith(
                            color: const Color(0xFF1B2A4A),
                            fontSize: 22.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'BETTER SLEEP  BETTER LIFE',
                          style: AppTextStyle.smallGrey.copyWith(
                            fontSize: 7.5.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: const Color(0xFF7A6855),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Search Anchor Input Bar
                  Expanded(child: _buildSearchBarInput(context)),

                  // Cart + Notification Icons
                  2.horizontalSpace,
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
                  // Row(
                  //   children: [

                  //     // 2.horizontalSpace,
                  //     // InkWell(
                  //     //   onTap: () {},
                  //     //   child: const IconBadge(
                  //     //     iconPath: 'ic_notification.svg',
                  //     //     count: 3,
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
            ),

            5.verticalSpace,

            _buildCarouselBannerContent(),

            5.verticalSpace,
          ],
        );
      }),
    );
  }

  /// White Overlapping Container Header (Category, Shortcuts, Filter/Sort, Promo Banner, Section Header)
  Widget _buildMainBodyContainer() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final isFilterActive = controller.searchQuery.value.trim().isNotEmpty ||
            controller.selectedCategoryId.value != null;

        if (isFilterActive) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActiveFilterHeaderInline(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: SectionHeader(
                  title: 'Hasil Produk',
                  actionText: '',
                ),
              ),
            ],
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              8.verticalSpace,

              Obx(
                () {
                  final selectedId = controller.selectedShortcutId.value;
                  if (controller.productTags.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 25.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.productTags.length,
                      separatorBuilder: (_, __) => SizedBox(width: 4.w),
                      itemBuilder: (context, index) {
                        final item = controller.productTags[index];
                        final isSelected = selectedId == item.id;
                        final theme = TagTheme.fromTag(item, index);

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              controller.selectedShortcutId.value = item.id;
                              Get.toNamed(
                                Routes.CATEGORY_PRODUCT,
                                arguments: {
                                  'selectedTag': item,
                                  'tagId': item.id,
                                  'tags': controller.productTags,
                                  'initialIndex': controller.productTags
                                      .indexWhere((s) => s.id == item.id),
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(24.r),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.iconColor
                                    : theme.backgroundColor,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.iconColor
                                      : theme.borderColor,
                                  width: 1.2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color:
                                              theme.iconColor.withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    theme.icon,
                                    size: 12.sp,
                                    color: isSelected
                                        ? AppColors.white
                                        : theme.iconColor,
                                  ),
                                  6.horizontalSpace,
                                  Text(
                                    item.name,
                                    style:
                                        AppTextStyle.mediumBlackBold.copyWith(
                                      fontSize: 8.sp,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // Brand Festival Promo Banner
              // PromoBanner(
              //   onTap: () {
              //     controller.fetchProducts(search: 'Promo', categoryId: null);
              //   },
              // ),

              Obx(() {
                final eventActive = controller.contentEventActive
                        .firstWhereOrNull((e) => e.isActive) ??
                    (controller.contentEventActive.isNotEmpty
                        ? controller.contentEventActive.first
                        : null);

                if (controller.contentEventActive.isEmpty ||
                    !controller.isEventActive.value ||
                    eventActive == null) {
                  return const SizedBox.shrink();
                }

                return EventTimerCard(
                  event: controller.contentEventActive.isNotEmpty
                      ? controller.contentEventActive.first
                      : null,
                  duration: controller.eventCountdownText.value,
                  eventTitle: controller.activeEventTitle.value,
                  isEventActive: controller.isEventActive.value,
                  bannerImageUrl: eventActive.bannerImageUrl,
                  onTap: () {
                    controller.fetchProducts(
                      search: eventActive.title,
                      resetFilters: true,
                    );
                  },
                );
              }),
              8.verticalSpace,
              // Featured Header ("Produk Unggulan", "Lihat Semua >")
              SectionHeader(
                title: 'Produk Unggulan',
                actionText: '',
              ),
              8.verticalSpace,
              // 3. Featured Product Cards Grid
              _buildProductGrid(),

              // 4. Infinite Scroll Load More Indicator
              _buildLoadMoreIndicator(),

              // Bottom Spacing for clean scrolling above nav bar
              24.verticalSpace
            ],
          ),
        );
      }),
    );
  }

  /// Banner Slider with Overlay Text & Carousel Pagination Dots
  Widget _buildCarouselBannerContent() {
    if (controller.banners.isNotEmpty) {
      return CarouselSlider(
        items: controller.banners
            .map((e) => CustomBanner(
                  borderRadius: BorderRadius.circular(0),
                  imagePath: e.imageWebUrl,
                ))
            .toList(),
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1,
          height: 115.h,
          autoPlayInterval: const Duration(seconds: 4),
          onPageChanged: (index, reason) {
            controller.activeBannerIndex.value = index;
          },
        ),
      );
    }

    // Styled Fallback Banner matching Reference Image
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomShimmer(
        width: double.infinity,
        height: 115.h,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Search Anchor Input Box
  Widget _buildSearchBarInput(BuildContext context) {
    return SearchAnchor(
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
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
      suggestionsBuilder: (BuildContext context, SearchController sc) async {
        final String keyword = sc.text.trim();
        final List<Widget> suggestions = [];

        if (keyword.isNotEmpty) {
          suggestions.add(
            ListTile(
              leading: const Icon(Icons.search, color: AppColors.primaryColor),
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
                controller.fetchProducts(search: keyword, categoryId: null);
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                title: Text(tagItem.name, style: AppTextStyle.mediumBlackBold),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: const Text(
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
    );
  }

  Widget _buildActiveFilterHeaderInline() {
    final hasSearch = controller.searchQuery.value.isNotEmpty;
    final hasCategory = controller.selectedCategoryId.value != null;

    if (!hasSearch && !hasCategory) {
      return const SizedBox.shrink();
    }

    String filterText = '';

    if (hasSearch) {
      filterText = 'Pencarian: "${controller.searchQuery.value}"';
    }
    // if (hasCategory) {
    //   final cat = controller.category.firstWhereOrNull(
    //     (c) => c.id == controller.selectedCategoryId.value,
    //   );
    //   final catName = cat is CategoryEntity ? cat.name : 'Kategori';
    //   if (filterText.isNotEmpty) {
    //     filterText += ' | Kategori: $catName';
    //   } else {
    //     filterText = 'Kategori: $catName';
    //   }
    // }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                filterText,
                style: AppTextStyle.mediumBlackBold.copyWith(
                  color: AppColors.primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: () => controller.fetchProducts(resetFilters: true),
              child: Row(
                children: [
                  Text(
                    'Reset Filter',
                    style: AppTextStyle.mediumBlack.copyWith(
                      color: AppColors.red,
                    ),
                  ),
                  4.horizontalSpace,
                  const Icon(Icons.close, size: 18, color: AppColors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return Obx(() {
      if (controller.isLoadingProducts.value && controller.products.isEmpty) {
        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.3,
          ),
          itemBuilder: (context, index) => const ProductCardShimmer(),
        );
      }

      if (controller.products.isEmpty) {
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.all(32.r),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64.sp,
                  color: AppColors.grey,
                ),
                12.verticalSpace,
                Text(
                  'Produk Tidak Ditemukan',
                  style: AppTextStyle.largeBlackBold,
                ),
                6.verticalSpace,
                Text(
                  'Coba gunakan kata kunci atau kategori lain',
                  style: AppTextStyle.smallGrey,
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              final product = controller.products[index];
              final title = product?.name ?? "-";
              final variant =
                  (product?.variants != null && product!.variants.isNotEmpty)
                      ? product.variants.first
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
                  ((product?.images != null && product!.images.isNotEmpty)
                      ? product.images.first.image
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
                onAddToCart: (key) => controller.addToCart(key),
              );
            },
          ));
    });
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (!controller.isLoadingMore.value) return const SizedBox.shrink();
      return SizedBox(
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
