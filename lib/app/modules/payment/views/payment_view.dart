import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
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
                    Helper.formatCurrency((controller.selectedPrice.value *
                            controller.selectedQty.value) +
                        2500),
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
                        DateFormat('dd MMM yyyy hh:mm a').format(
                            DateTime.now().add(const Duration(minutes: 5))),
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
                        'Transfer Bank (Virtual Account)',
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
                        'Bank BCA',
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
                        50.horizontalSpace,
                        Text(
                          '123 4567 8901 2345',
                          style: AppTextStyle.xxLargeBlackBold
                              .copyWith(color: AppColors.primaryColor),
                        ),
                        40.horizontalSpace,
                        SvgPicture.asset(
                          height: 25,
                          width: 25,
                          Helper.getSvgPath('ic_copy.svg'),
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
                      'Cara Pembayaran',
                      style: AppTextStyle.mediumBlackBold,
                    ),
                    10.verticalSpace,
                    ListTile(
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
                        'Buka Aplikasi BCA Mobile dan Masuk ke akun anda',
                        style: AppTextStyle.mediumBlack,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      minVerticalPadding: 5,
                      horizontalTitleGap: 10,
                      minTileHeight: 0,
                      leading: CircleAvatar(
                          radius: 8, backgroundColor: AppColors.primaryColor),
                      title: Text(
                        'Pilih Menu BCA Virtual Account',
                        style: AppTextStyle.mediumBlack,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      minVerticalPadding: 5,
                      horizontalTitleGap: 10,
                      minTileHeight: 0,
                      leading: CircleAvatar(
                          radius: 8, backgroundColor: AppColors.primaryColor),
                      title: Text(
                        'Input No.Rek/Virtual Account & Jumlah Pembayaran',
                        style: AppTextStyle.mediumBlack,
                      ),
                    ),
                    Divider(color: AppColors.lightGrey, thickness: 1.2),
                    10.verticalSpace,
                    Text(
                      'Proses verifikasi kurang dari 10 menit setelah pembayaran berhasil',
                      style: AppTextStyle.mediumBlack,
                    ),
                    10.verticalSpace,
                    Divider(color: AppColors.lightGrey, thickness: 1.2),
                    10.verticalSpace,
                    Text(
                      'Bayar pesanan ke Virtual Account diatas sebelum membuat pesanan kembali agar nomor Virtual Account tetap sama',
                      style: AppTextStyle.mediumGrey,
                    ),
                  ],
                ),
              ),
              30.verticalSpace,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    side: const BorderSide(
                        color: AppColors.primaryColor, width: 1.5),
                  ),
                  onPressed: () => controller.checkPaymentStatus(),
                  child: Obx(
                    () => controller.isCheckingStatus.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: AppColors.primaryColor, strokeWidth: 2),
                          )
                        : Text(
                            'Cek Status Pembayaran',
                            style: AppTextStyle.largeBlackBold
                                .copyWith(color: AppColors.primaryColor),
                          ),
                  ),
                ),
              ),
              12.verticalSpace,
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
                  onPressed: () => controller.finishPayment(),
                  child: Text(
                    'Selesai',
                    style: AppTextStyle.largeWhiteBold,
                  ),
                ),
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
