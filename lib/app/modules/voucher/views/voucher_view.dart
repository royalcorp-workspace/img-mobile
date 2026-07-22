import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/voucher/views/widgets/voucher_bottom_bar.dart';
import 'package:pos_royal/app/modules/voucher/views/widgets/voucher_section.dart';

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
          'Pakai Voucher',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                'Masukkan Kode',
                style: AppTextStyle.largeWhiteBold,
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: controller.vouchers.length,
        itemBuilder: (context, index) {
          final voucher = controller.vouchers[index];
          return Padding(
            padding: EdgeInsets.only(
                bottom: index == controller.vouchers.length - 1 ? 20 : 16),
            child: Obx(
              () => VoucherSection(
                titleVoucher: voucher.titleVoucher,
                subtitleVoucher: voucher.subtitleVoucher,
                title: voucher.title,
                description: voucher.description,
                codeVoucher: voucher.codeVoucher,
                image: voucher.image,
                itemCount: 1,
                isSelected: controller.selectedIndex.value == index,
                onTap: () => controller.selectedIndex.value = index,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const VoucherBottomBar(),
    );
  }
}
