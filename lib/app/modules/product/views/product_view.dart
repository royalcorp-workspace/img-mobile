import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/modules/home/widgets/icon_badge.dart';
import 'package:img/app/modules/home/widgets/product_card.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/shared/widgets/app_search_field.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
              _buildHomepageContent(),
              20.verticalSpace,
            ],
          ),
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
                      final imageUrl = product.thumbnailUrl.isEmpty
                          ? product.thumbnail
                          : (product.image.isNotEmpty ? product.image : '');

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
                      height: 270.h,
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
