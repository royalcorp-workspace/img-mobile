import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/modules/home/widgets/icon_badge.dart';
import 'package:img/app/modules/home/widgets/product_card.dart';
import 'package:img/app/modules/home/widgets/shortcut_section.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/shared/widgets/app_search_field.dart';

import '../controllers/shortcut_product_controller.dart';

class ShortcutProductView extends GetView<ShortcutProductController> {
  const ShortcutProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => controller.fetchProducts(),
            color: AppColors.primaryColor,
            child: CustomScrollView(
              controller: controller.pageScrollController,
              slivers: [
                _buildShortcutSelector(),
                _buildActiveShortcutHeader(),
                _buildProductGrid(),
                _buildLoadMoreIndicator(),
              ],
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              bottom: controller.showScrollToTop.value ? 24 : -70,
              right: 20,
              child: GestureDetector(
                onTap: controller.scrollToTop,
                child: const CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(
                    Icons.arrow_upward_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 70.h,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Get.back(),
      ),
      title: SearchAnchor(
        viewBackgroundColor: AppColors.white,
        viewShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        viewLeading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        viewTrailing: [
          IconButton(
            icon: const Icon(Icons.clear, color: AppColors.black),
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
                  'Cari produk di shortcut ini',
                  style: AppTextStyle.mediumBlack,
                ),
                onTap: () {
                  sc.closeView(keyword);
                  controller.fetchProducts(search: keyword);
                },
              ),
            );
            suggestions
                .add(const Divider(color: AppColors.lightGrey, thickness: 1.2));

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

  Widget _buildShortcutSelector() {
    return SliverToBoxAdapter(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Obx(
            () => controller.shortcutList.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 25.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.shortcutList.length,
                      separatorBuilder: (_, __) => SizedBox(width: 4.w),
                      itemBuilder: (context, index) {
                        final item = controller.shortcutList[index];
                        final isSelected =
                            controller.selectedShortcutId == item.id;
                        final theme = TagTheme.fromTag(item, index);

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              controller.selectShortcutByItem(item);
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
                  ),
          )),
    );
  }

  Widget _buildActiveShortcutHeader() {
    return Obx(() {
      final selected = controller.selectedShortcut;
      final shortcutTitle = selected?.name ?? 'Produk Tag';
      final theme = selected != null
          ? TagTheme.fromTag(selected, controller.selectedIndex.value)
          : null;
      final hasSearch = controller.searchQuery.value.isNotEmpty;

      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (selected != null && theme != null) ...[
                      Icon(
                        theme.icon,
                        color: theme.iconColor,
                        size: 20.sp,
                      ),
                      8.horizontalSpace,
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shortcutTitle,
                            style: AppTextStyle.largeBlackBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (hasSearch)
                            Text(
                              'Pencarian: "${controller.searchQuery.value}"',
                              style: AppTextStyle.mediumGrey,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasSearch)
                InkWell(
                  onTap: () => controller.fetchProducts(search: ''),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Row(
                      children: [
                        Text(
                          'Hapus Cari',
                          style: AppTextStyle.smallGrey,
                        ),
                        4.horizontalSpace,
                        const Icon(Icons.close, size: 16, color: AppColors.red),
                      ],
                    ),
                  ),
                ),
            ],
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.53,
            ),
          ),
        );
      }

      if (controller.products.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64.r,
                  color: AppColors.grey,
                ),
                16.verticalSpace,
                Text(
                  'Produk Tidak Ditemukan',
                  style: AppTextStyle.largeBlackBold,
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  'Tidak ada produk yang tersedia untuk shortcut ini saat ini.',
                  style: AppTextStyle.mediumGrey,
                  textAlign: TextAlign.center,
                ),
              ],
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
              final title = product.name;
              final variant =
                  (product.variants.isNotEmpty) ? product.variants.first : null;

              final price = product.finalPrice > 0
                  ? product.finalPrice
                  : product.basePrice > 0
                      ? product.basePrice
                      : (variant?.finalPrice ?? 0) > 0
                          ? variant!.finalPrice
                          : variant?.price ?? 0.0;

              final originalPrice = product.basePrice > price
                  ? product.basePrice
                  : (variant?.basePrice ?? 0) > price
                      ? (variant?.basePrice ?? 0.0)
                      : 0.0;

              final String imageUrl =
                  (product.thumbnail != null && product.thumbnail!.isNotEmpty)
                      ? product.thumbnail!
                      : ((product.images.isNotEmpty)
                          ? product.images.first.image
                          : '');

              final String rating = (product.avgRating).toStringAsFixed(1);
              final String review = '(${product.totalReviews})';

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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                color: AppColors.primaryColor,
                strokeWidth: 2.5,
              ),
            ),
          ),
        ),
      );
    });
  }
}
