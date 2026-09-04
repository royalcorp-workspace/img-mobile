import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/modules/voucher/views/widgets/voucher_bottom_bar.dart';
import 'package:img/app/modules/voucher/views/widgets/voucher_card.dart';

import '../controllers/voucher_controller.dart';

class VoucherView extends GetView<VoucherController> {
  const VoucherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.shadowGrey,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
          title: const Text(
            'Voucher',
            style: AppTextStyle.xLargeWhiteBold,
          ),
          // actions: const [
          //   Padding(
          //     padding: EdgeInsets.only(right: 12),
          //     child: Center(
          //       child: Text(
          //         'Masukkan Kode',
          //         style: AppTextStyle.largeWhiteBold,
          //       ),
          //     ),
          //   )
          // ],
        ),
        body: Obx(
          () {
            if (controller.isLoading.value && controller.vouchers.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }
            if (controller.vouchers.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada voucher tersedia',
                  style: AppTextStyle.largeBlackBold,
                ),
              );
            }
            return ListView.builder(
              controller: controller.pageScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: controller.vouchers.length,
              itemBuilder: (context, index) {
                final data = controller.vouchers[index];
                return Obx(
                  () => VoucherCard(
                    title: data.title,
                    description: data.description,
                    codeVoucher: data.code,
                    isSelected: controller.selectedIndex.value == index,
                    onTap: () => controller.selectedIndex.value = index,
                  ),
                  // VoucherSection(
                  //   titleVoucher: data.title,
                  //   subtitleVoucher: 'data.subtitle',
                  //   title: data.title,
                  //   description: data.description,
                  //   codeVoucher: data.code,
                  //   image: 'img_discount.png',
                  //   itemCount: 1,
                  //   isSelected: controller.selectedIndex.value == index,
                  //   onTap: () => controller.selectedIndex.value = index,
                  // ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Obx(
          () {
            if (controller.vouchers.isEmpty ||
                controller.selectedIndex.value < 0 ||
                controller.selectedIndex.value >= controller.vouchers.length) {
              return const SizedBox.shrink();
            }
            return VoucherBottomBar(
              value: controller.vouchers[controller.selectedIndex.value].value
                  .toInt(),
              onTap: () {
                final selectedVoucher =
                    controller.vouchers[controller.selectedIndex.value];
                Get.back(result: selectedVoucher);
              },
            );
          },
        ));
  }
}
