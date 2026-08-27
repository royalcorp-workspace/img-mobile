import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/detail_product/widgets/cart_badge.dart';
import 'package:pos_royal/app/modules/detail_product/widgets/comment_card.dart';
import 'package:pos_royal/app/modules/detail_product/widgets/detail_product_card.dart';
import 'package:pos_royal/app/modules/home/widgets/product_card.dart';
import 'package:pos_royal/app/routes/app_pages.dart';
import 'package:pos_royal/app/shared/widgets/app_divider.dart';
import 'package:pos_royal/app/shared/widgets/text/text_price_line_through.dart';
import 'package:readmore/readmore.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({super.key});
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
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailProductCard(
                widgetKey: controller.widgetKey,
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  controller.productByID.value.name ?? '-',
                  style: AppTextStyle.xLargeBlackBold,
                ),
              ),
              5.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.yellow,
                          size: 20,
                        ),
                        5.horizontalSpace,
                        Text(
                          '4.2',
                          style: AppTextStyle.mediumBlackBold.copyWith(
                            color: AppColors.yellow,
                          ),
                        ),
                        5.horizontalSpace,
                        const Text(
                          '(128)',
                          style: AppTextStyle.smallGrey,
                        ),
                      ],
                    ),
                    8.horizontalSpace,
                    Text(
                      '|',
                      style: AppTextStyle.mediumGrey
                          .copyWith(color: AppColors.lightGrey),
                    ),
                    8.horizontalSpace,
                    Row(
                      children: [
                        const Text(
                          '30',
                          style: AppTextStyle.mediumBlack,
                        ),
                        5.horizontalSpace,
                        const Text(
                          'Terjual',
                          style: AppTextStyle.smallGrey,
                        ),
                      ],
                    ),
                    8.horizontalSpace,
                    Text(
                      '|',
                      style: AppTextStyle.mediumGrey
                          .copyWith(color: AppColors.lightGrey),
                    ),
                    8.horizontalSpace,
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            '${controller.productByID.value.variants?[controller.selectedIndex.value].stockQty}',
                            style: AppTextStyle.mediumBlack,
                          ),
                        ),
                        5.horizontalSpace,
                        const Text(
                          'Stok',
                          style: AppTextStyle.smallGrey,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        Helper.formatCurrency(controller
                                .productByID
                                .value
                                .variants?[controller.selectedIndex.value]
                                .finalPrice
                                .toInt() ??
                            0),
                        style: AppTextStyle.xLargeBlackBold.copyWith(
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Obx(
                      () => Visibility(
                        visible: controller
                                .productByID
                                .value
                                .variants?[controller.selectedIndex.value]
                                .finalPrice !=
                            controller
                                .productByID
                                .value
                                .variants?[controller.selectedIndex.value]
                                .price,
                        child: TextPriceLineThrough(
                            price: Helper.formatCurrency(controller
                                    .productByID
                                    .value
                                    .variants?[controller.selectedIndex.value]
                                    .price
                                    .toInt() ??
                                0)),
                      ),
                    ),
                    8.horizontalSpace,
                    Visibility(
                      visible: controller
                              .productByID
                              .value
                              .variants?[controller.selectedIndex.value]
                              .finalPrice !=
                          controller.productByID.value
                              .variants?[controller.selectedIndex.value].price,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.shadeRed,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.remove,
                              size: 12,
                              color: AppColors.orange,
                            ),
                            Obx(
                              () => Text(
                                controller
                                        .productByID
                                        .value
                                        .variants![
                                            controller.selectedIndex.value]
                                        .priceProductSettings
                                        .isEmpty
                                    ? ''
                                    : '${controller.productByID.value.variants?[controller.selectedIndex.value].priceProductSettings.first.discountValue.toInt()}%',
                                style: AppTextStyle.mediumBlackBold.copyWith(
                                  color: AppColors.orange,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              10.verticalSpace,
              Visibility(
                  visible: controller
                      .productByID
                      .value
                      .variants![controller.selectedIndex.value]
                      .priceProductSettings
                      .isNotEmpty,
                  child: const Divider(
                      color: AppColors.lightGrey, thickness: 1.2)),
              Visibility(
                visible: controller
                    .productByID
                    .value
                    .variants![controller.selectedIndex.value]
                    .priceProductSettings
                    .isNotEmpty,
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0,
                    horizontalTitleGap: 5,
                    leading: Image.asset(
                      height: 60,
                      width: 60,
                      Helper.getImagePath('img_special_promo.png'),
                    ),
                    title: Obx(
                      () => Text(
                        controller
                                .productByID
                                .value
                                .variants![controller.selectedIndex.value]
                                .priceProductSettings
                                .isEmpty
                            ? '-'
                            : '${controller.productByID.value.variants?[controller.selectedIndex.value].priceProductSettings.first.title}',
                        style: AppTextStyle.mediumBlackBold,
                      ),
                    ),
                    subtitle: Obx(
                      () => Text(
                        controller
                                .productByID
                                .value
                                .variants![controller.selectedIndex.value]
                                .priceProductSettings
                                .isEmpty
                            ? '-'
                            : '${controller.productByID.value.variants?[controller.selectedIndex.value].priceProductSettings.first.description}',
                        style: AppTextStyle.mediumBlack,
                      ),
                    )),
              ),
              AppDivider(),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Text(
                  'Pilih Ukuran',
                  style: AppTextStyle.largeBlackBold,
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SizedBox(
                  height: 32.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: controller.productByID.value.variants?.length,
                    itemBuilder: (context, index) => Obx(
                      () => SizeContainer(
                        label:
                            '${controller.productByID.value.variants?[index].width}x${controller.productByID.value.variants?[index].length}',
                        isSelected: controller.selectedIndex.value == index,
                        onTap: () => controller.selectedIndex.value = index,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: controller.productByID.value.colors!.isNotEmpty,
                  child: 10.verticalSpace),
              Visibility(
                visible: controller.productByID.value.colors!.isNotEmpty,
                child: RPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: const Text(
                    'Pilih Warna',
                    style: AppTextStyle.largeBlackBold,
                  ),
                ),
              ),
              Visibility(
                  visible: controller.productByID.value.colors!.isNotEmpty,
                  child: 10.verticalSpace),
              Visibility(
                visible: controller.productByID.value.colors!.isNotEmpty,
                child: RPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: SizedBox(
                    height: 32.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: controller.productByID.value.colors?.length,
                      itemBuilder: (context, index) => Obx(
                        () => SizeContainer(
                          label:
                              '${controller.productByID.value.colors?[index].name}',
                          isSelected: controller.selectedIndex.value == index,
                          onTap: () => controller.selectedIndex.value = index,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
              AppDivider(),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Text(
                  'Deskripsi Produk',
                  style: AppTextStyle.largeBlackBold,
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ReadMoreText(
                  '''
${controller.productByID.value.description}
''',
                  trimMode: TrimMode.Line,
                  trimLines: 3,
                  style: AppTextStyle.mediumBlackSecondary,
                  lessStyle: AppTextStyle.mediumBlack600
                      .copyWith(color: AppColors.primaryColor),
                  trimCollapsedText: 'Lihat Semua',
                  trimExpandedText: 'Lihat Sedikit',
                  moreStyle: AppTextStyle.mediumBlack600
                      .copyWith(color: AppColors.primaryColor),
                ),
              ),
              10.verticalSpace,
              AppDivider(),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ulasan Produk',
                      style: AppTextStyle.largeBlackBold,
                    ),
                    Text(
                      'Lihat Semua',
                      style: AppTextStyle.smallBlackBold,
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.verticalSpace,
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              Text(
                                '4.2',
                                style: AppTextStyle.xLargeBlackBold,
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          Text(
                            '128 Rating\ndan 24 Review',
                            style: AppTextStyle.smallGrey,
                          )
                        ],
                      ),
                      VerticalDivider(
                        color: AppColors.lightGrey,
                        thickness: 1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '5',
                                style: AppTextStyle.smallGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0.8,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '67%',
                                style: AppTextStyle.smallGrey,
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '4',
                                style: AppTextStyle.smallGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0.2,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '20%',
                                style: AppTextStyle.smallGrey,
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '3',
                                style: AppTextStyle.smallGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '7%',
                                style: AppTextStyle.smallGrey,
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '2',
                                style: AppTextStyle.smallGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '0%',
                                style: AppTextStyle.smallGrey,
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '1',
                                style: AppTextStyle.smallGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0.1,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '2%',
                                style: AppTextStyle.smallGrey,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CommentCard(),
              ),
              10.verticalSpace,
              AppDivider(),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Produk Serupa',
                      style: AppTextStyle.largeBlackBold,
                    ),
                    Text(
                      'Lihat Semua',
                      style: AppTextStyle.smallBlackBold,
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(14),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    //               final String title = product?.name ?? "-";
                    // double priceVal = 0.0;
                    // double originalPriceVal = 0.0;
                    // if (product != null) {
                    //   priceVal = product!.finalPrice > 0
                    //       ? product!.finalPrice
                    //       : (product!.basePrice > 0
                    //           ? product!.basePrice
                    //           : (product!.variants.isNotEmpty
                    //               ? (product!.variants.first.finalPrice > 0
                    //                   ? product!.variants.first.finalPrice
                    //                   : product!.variants.first.price)
                    //               : 0.0));
                    //   if (product!.basePrice > priceVal) {
                    //     originalPriceVal = product!.basePrice;
                    //   }
                    // }
                    // final String formattedPrice =
                    //     product != null ? Helper.formatCurrency(priceVal.toInt()) : 'Rp 0';
                    // final String formattedOriginalPrice = originalPriceVal > 0
                    //     ? Helper.formatCurrency(originalPriceVal.toInt())
                    //     : '';
                    // final String imageUrl = product?.thumbnail ??
                    //     (product?.images.isNotEmpty == true ? product!.images.first.image : '');
                    // final String ratingStr = (product?.avgRating ?? 4.2).toStringAsFixed(1);
                    // final String reviewsStr = '(${product?.totalReviews ?? 128})';

                    // ImageProvider imageProvider;
                    // if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
                    //   imageProvider = NetworkImage(imageUrl);
                    // } else {
                    //   imageProvider = AssetImage(
                    //     Helper.getImagePath('img_product1.jpg'),
                    //   );
                    // }
                    return ProductsCard(
                      title: '',
                      formattedOriginalPrice: '',
                      formattedPrice: '',
                      imageProvider:
                          AssetImage(Helper.getImagePath('img_product1.jpg')),
                      rating: '',
                      review: '',
                      onTap: (p0) => Get.toNamed(Routes.DETAIL_PRODUCT),
                    );
                  })
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, -8),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: BottomAppBar(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.message_outlined,
                      size: 20,
                      color: AppColors.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed(Routes.CHECKOUT, arguments: [
                    controller.productByID.value,
                    controller.selectedIndex.value
                  ]),
                  child: Container(
                    height: 35.h,
                    width: 148.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Beli Langsung',
                        style: AppTextStyle.largeBlackBold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.addToCart(controller.widgetKey);
                  },
                  child: Container(
                    height: 35.h,
                    width: 148.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        '+ Keranjang',
                        style: AppTextStyle.largeWhiteBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // AppBar with search and action icons
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Detail Produk',
        style: AppTextStyle.xxLargeWhiteBold,
      ),
      backgroundColor: AppColors.primaryColor,
      actions: [
        SizedBox(
          height: 22,
          width: 22,
          child: SvgPicture.asset(
            Helper.getSvgPath('ic_share.svg'),
          ),
        ),
        2.horizontalSpace,
        Obx(
          () => AddToCartIcon(
            key: controller.cartKey,
            icon: InkWell(
              onTap: () => Get.toNamed(Routes.CART),
              child: CartBadge(
                iconPath: 'ic_cart.svg',
                count: controller.cartQuantityItems.value,
              ),
            ),
            badgeOptions: const BadgeOptions(
              width: 0,
              height: 0,
              fontSize: 0,
              active: false,
            ),
          ),
        ),
        7.horizontalSpace,
      ],
    );
  }
}

class SizeContainer extends StatelessWidget {
  const SizeContainer({
    super.key,
    required this.label,
    this.onTap,
    required this.isSelected,
  });

  final String label;
  final void Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.lightGrey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTextStyle.mediumBlack.copyWith(
            color: isSelected ? AppColors.primaryColor : AppColors.black,
          ),
        ),
      ),
    );
  }
}
