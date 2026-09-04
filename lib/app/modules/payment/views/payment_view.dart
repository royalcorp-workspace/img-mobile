import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/shared/widgets/button/primary_button.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
          leading: IconButton(
            tooltip: 'Kembali ke beranda',
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.offAllNamed(Routes.NAVIGATION),
          ),
          title: const Text(
            'Payment',
            style: AppTextStyle.xxLargeWhiteBold,
          ),
          centerTitle: true,
        ),
        body: RPadding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: SingleChildScrollView(
            child: Column(
              children: [
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Tagihan',
                      style: AppTextStyle.mediumBlack,
                    ),
                    Text(
                      Helper.formatCurrency(
                        (double.tryParse(controller
                                        .checkoutResult?.payment?.totalAmount ??
                                    '0') ??
                                0)
                            .round(),
                      ),
                      style: AppTextStyle.largeBlackBold.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Divider(color: AppColors.lightGrey, thickness: 1.2),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bayar Sebelum',
                      style: AppTextStyle.mediumBlack,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(
                          () => Text(
                            controller.formattedTime,
                            style: AppTextStyle.largeBlackBold.copyWith(
                              color: AppColors.red,
                            ),
                          ),
                        ),
                        Text(
                          controller.formattedExpiredDate,
                          style: AppTextStyle.mediumBlack,
                        ),
                      ],
                    )
                  ],
                ),
                15.verticalSpace,
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.lightGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            width: 25,
                            height: 25,
                            Helper.getImagePath('img_va.png'),
                          ),
                        ),
                        title: Text(
                          '${controller.checkoutResult?.payment?.typeName}',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                      ),
                      RPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child:
                            Divider(color: AppColors.lightGrey, thickness: 1.2),
                      ),
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.lightGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            width: 25,
                            height: 25,
                            Helper.getImagePath('img_bca.png'),
                          ),
                        ),
                        title: Text(
                          '${controller.checkoutResult?.payment?.bankName}',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                        subtitle: Text(
                          'No. Rek/Virtual Account',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.checkoutResult?.vaNumber ?? '',
                            style: AppTextStyle.xxLargeBlackBold
                                .copyWith(color: AppColors.primaryColor),
                          ),
                          5.horizontalSpace,
                          GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(
                                ClipboardData(
                                  text:
                                      controller.checkoutResult?.vaNumber ?? '',
                                ),
                              );

                              Get.snackbar(
                                'Berhasil!',
                                'Copied to clipboard!',
                                backgroundColor: AppColors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: SvgPicture.asset(
                              height: 20,
                              width: 20,
                              Helper.getSvgPath(
                                'ic_copy.svg',
                              ),
                              color: AppColors.grey,
                            ),
                          )
                        ],
                      ),
                      10.verticalSpace,
                    ],
                  ),
                ),
                15.verticalSpace,
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cara Pembayaran:',
                        style: AppTextStyle.mediumBlackBold,
                      ),
                      10.verticalSpace,
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller
                              .checkoutResult?.payment?.caraBayar.length,
                          itemBuilder: (context, index) {
                            final data = controller
                                .checkoutResult?.payment?.caraBayar[index];

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              minLeadingWidth: 0,
                              minVerticalPadding: 5,
                              horizontalTitleGap: 10,
                              minTileHeight: 0,
                              leading: CircleAvatar(
                                radius: 8,
                                backgroundColor: AppColors.primaryColor,
                              ),
                              title: Text(
                                '$data',
                                style: AppTextStyle.mediumBlack,
                              ),
                            );
                          }),
                      // Divider(color: AppColors.lightGrey, thickness: 1.2),
                      // 10.verticalSpace,
                      // Text(
                      //   'Proses verifikasi kurang dari 10 menit setelah pembayaran berhasil',
                      //   style: AppTextStyle.mediumBlack,
                      // ),
                      // 10.verticalSpace,
                      // Divider(color: AppColors.lightGrey, thickness: 1.2),
                      // 10.verticalSpace,
                      // Text(
                      //   'Bayar pesanan ke Virtual Account diatas sebelum membuat pesanan kembali agar nomor Virtual Account tetap sama',
                      //   style: AppTextStyle.mediumGrey,
                      // ),
                    ],
                  ),
                ),
                30.verticalSpace,
                Obx(
                  () => ButtonPrimary(
                    fullWidth: true,
                    color: AppColors.primaryColor,
                    borderRadius: 28,
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1.5),
                    text: 'Cek Status Pembayaran',
                    onPressed: () => controller.checkPaymentStatus(),
                    isLoading: controller.isCheckingStatus.value,
                  ),
                ),
                // 12.verticalSpace,
                // ButtonPrimary(
                //   fullWidth: true,
                //   color: AppColors.primaryColor,
                //   borderRadius: 28,
                //   text: 'Selesai',
                //   onPressed: () => controller.finishPayment(),
                // ),
                50.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
