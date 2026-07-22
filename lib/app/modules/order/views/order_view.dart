import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/home/widgets/icon_badge.dart';
import 'package:pos_royal/app/routes/app_pages.dart';
import 'package:pos_royal/app/shared/widgets/app_search_field.dart';
import 'package:pos_royal/app/shared/widgets/stepper/app_simple_horizontal_step_indicator.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              ? 'Semua Status'
                              : index == 1
                                  ? 'Belum dibayar'
                                  : index == 2
                                      ? 'Selesai'
                                      : 'Dibatalkan',
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
            RPadding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, -1),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSimpleHorizontalStepIndicator(
                      actualStep: 1,
                      steps: 4,
                    ),
                    20.verticalSpace,
                    Text(
                      'Paket dalam Perjalanan',
                      style: AppTextStyle.largeBlackBold,
                    ),
                    5.verticalSpace,
                    Text(
                      'Dikirim dengan instant - Lalamove',
                      style: AppTextStyle.mediumGrey,
                    ),
                    25.verticalSpace,
                    Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              Helper.getImagePath(
                                'img_product1.jpg',
                              ),
                            ),
                          )),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Elite Springbed Kasur Pocket Emporium New Edition",
                                style: AppTextStyle.largeBlackBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '1 barang | #9ds69hs',
                                style: AppTextStyle.mediumGrey,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    25.verticalSpace,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            AppColors.primaryColor,
                          ),
                        ),
                        onPressed: () => Get.toNamed(Routes.DETAIL_ORDER),
                        child: Text(
                          'Info Detail',
                          style: AppTextStyle.mediumWhiteBold,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            AppColors.lightGrey,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Batalkan Pesanan',
                          style: AppTextStyle.mediumWhiteBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Riwayat Pesanan',
                style: AppTextStyle.largeBlackBold,
              ),
            ),
            10.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 0),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.secondaryColor,
                            ),
                            10.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Belanja',
                                  style: AppTextStyle.mediumBlackBold,
                                ),
                                Text(
                                  '20 May 2025',
                                  style: AppTextStyle.mediumGrey,
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.green.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Selesai',
                                style: AppTextStyle.mediumBlackBold.copyWith(
                                  color: AppColors.greenContrast,
                                ),
                              ),
                            ),
                            5.horizontalSpace,
                            Icon(Icons.more_vert_rounded)
                          ],
                        )
                      ],
                    ),
                    5.verticalSpace,
                    const Divider(color: AppColors.lightGrey, thickness: 0.8),
                    5.verticalSpace,
                    Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              Helper.getImagePath(
                                'img_product1.jpg',
                              ),
                            ),
                          )),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Elite Springbed Kasur Pocket Emporium New Edition",
                                style: AppTextStyle.largeBlackBold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '1 barang',
                                style: AppTextStyle.mediumGrey,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Belanja',
                              style: AppTextStyle.mediumBlack,
                            ),
                            Text(
                              'Rp 1.087.210',
                              style: AppTextStyle.mediumBlackBold,
                            ),
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.greenContrast,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Beli Lagi',
                            style: AppTextStyle.mediumBlackBold.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            8.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 0),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.secondaryColor,
                            ),
                            10.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Belanja',
                                  style: AppTextStyle.mediumBlackBold,
                                ),
                                Text(
                                  '23 May 2025',
                                  style: AppTextStyle.mediumGrey,
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Dibatalkan',
                                style: AppTextStyle.mediumBlackBold.copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            ),
                            5.horizontalSpace,
                            Icon(Icons.more_vert_rounded)
                          ],
                        )
                      ],
                    ),
                    5.verticalSpace,
                    const Divider(color: AppColors.lightGrey, thickness: 0.8),
                    5.verticalSpace,
                    Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              Helper.getImagePath(
                                'img_product1.jpg',
                              ),
                            ),
                          )),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Elite Springbed Kasur Pocket Emporium New Edition",
                                style: AppTextStyle.largeBlackBold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '1 barang',
                                style: AppTextStyle.mediumGrey,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    15.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Belanja',
                          style: AppTextStyle.mediumBlack,
                        ),
                        Text(
                          'Rp 1.087.210',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            15.verticalSpace,
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 70.h,
      automaticallyImplyLeading: false,
      title: SizedBox(
        width: 260.w,
        child: const AppSearchField(),
      ),
      backgroundColor: AppColors.primaryColor,
      actions: [
        const IconBadge(
          iconPath: 'ic_notification.svg',
          count: 3,
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
}
