import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

class DetailOrderController extends GetxController {
  final rating = 0.obs;
  final actualStep = 1.obs;
  RxBool selectedReason1 = false.obs;
  RxBool selectedReason2 = false.obs;
  RxBool selectedReason3 = false.obs;
  RxBool selectedReason4 = false.obs;

  void showConfirmationDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Konfirmasi Pesanan Selesai?',
                style: AppTextStyle.xLargeBlackBold,
                textAlign: TextAlign.center,
              ),
              12.verticalSpace,
              Text(
                'Konfirmasi pesanan kamu jika pesanan telah sampai ditujuan/telah kamu ambil',
                style: AppTextStyle.mediumGrey.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Batal',
                        style: AppTextStyle.largeBlackBold,
                      ),
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        actualStep.value = 4;
                        Get.back();
                        await Future.delayed(
                          Duration(milliseconds: 800),
                        );
                        Get.dialog(
                          Dialog(
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    height: 100,
                                    width: 100,
                                    Helper.getImagePath(
                                        'img_order_success.png'),
                                  ),
                                  Text(
                                    'Pesanan Selesai !',
                                    style: AppTextStyle.xLargeBlackBold,
                                    textAlign: TextAlign.center,
                                  ),
                                  12.verticalSpace,
                                  Text(
                                    'Lanjutkan belanja untuk mendapatkan promo menarik lainnya',
                                    style: AppTextStyle.mediumGrey
                                        .copyWith(height: 1.5),
                                    textAlign: TextAlign.center,
                                  ),
                                  20.verticalSpace,
                                  SizedBox(
                                    width: Get.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                      ),
                                      child: Text(
                                        'Tutup',
                                        style: AppTextStyle.largeWhiteBold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Konfirmasi',
                        style: AppTextStyle.largeWhiteBold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showCancelOrderDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Apakah kamu yakin ingin membatalkan pesanan ini?',
                  style: AppTextStyle.xLargeBlackBold,
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      side: BorderSide(
                          color: selectedReason1.value
                              ? AppColors.red
                              : AppColors.lightGrey),
                      fillColor: WidgetStatePropertyAll(selectedReason1.value
                          ? AppColors.red
                          : AppColors.lightGrey),
                      value: selectedReason1.value,
                      checkColor: AppColors.white,
                      onChanged: (e) {
                        selectedReason1.value = e!;
                      },
                    ),
                    Text(
                      'Ada masalah dengan pesanan',
                      style: AppTextStyle.mediumGrey,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      side: BorderSide(
                          color: selectedReason2.value
                              ? AppColors.red
                              : AppColors.lightGrey),
                      fillColor: WidgetStatePropertyAll(selectedReason2.value
                          ? AppColors.red
                          : AppColors.lightGrey),
                      value: selectedReason2.value,
                      checkColor: AppColors.white,
                      onChanged: (e) {
                        selectedReason2.value = e!;
                      },
                    ),
                    Text(
                      'Ingin merubah pesanan',
                      style: AppTextStyle.mediumGrey,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      side: BorderSide(
                          color: selectedReason3.value
                              ? AppColors.red
                              : AppColors.lightGrey),
                      fillColor: WidgetStatePropertyAll(selectedReason3.value
                          ? AppColors.red
                          : AppColors.lightGrey),
                      value: selectedReason3.value,
                      checkColor: AppColors.white,
                      onChanged: (e) {
                        selectedReason3.value = e!;
                      },
                    ),
                    Text(
                      'Ingin menambah produk',
                      style: AppTextStyle.mediumGrey,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      side: BorderSide(
                          color: selectedReason4.value
                              ? AppColors.red
                              : AppColors.lightGrey),
                      fillColor: WidgetStatePropertyAll(selectedReason4.value
                          ? AppColors.red
                          : AppColors.lightGrey),
                      value: selectedReason4.value,
                      checkColor: AppColors.white,
                      onChanged: (e) {
                        selectedReason4.value = e!;
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Ingin merubah alamat pengiriman',
                        maxLines: 2,
                        style: AppTextStyle.mediumGrey,
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.blue,
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Jika kamu membatalkan pesanan, voucher yang sudah digunakan ketika pembelian mungkin akan hilang.',
                        style: AppTextStyle.mediumGrey.copyWith(height: 1.5),
                        maxLines: 4,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Ya, batalkan pesanan',
                      style: AppTextStyle.largeWhiteBold,
                    ),
                  ),
                ),
                5.verticalSpace,
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Tidak, kembali',
                      style: AppTextStyle.largeWhiteBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showFeedbackDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Konfirmasi Ulasan Selesai?',
                style: AppTextStyle.xLargeBlackBold,
                textAlign: TextAlign.center,
              ),
              12.verticalSpace,
              Text(
                'Konfirmasi pesanan kamu jika pesanan telah sesuai dengan yang kamu pesan',
                style: AppTextStyle.mediumGrey.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Batal',
                        style: AppTextStyle.largeBlackBold,
                      ),
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.dialog(
                          Dialog(
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    height: 100,
                                    width: 100,
                                    Helper.getImagePath('img_success.png'),
                                  ),
                                  Text(
                                    'Ulasan Selesai !',
                                    style: AppTextStyle.xLargeBlackBold,
                                    textAlign: TextAlign.center,
                                  ),
                                  12.verticalSpace,
                                  Text(
                                    'Lanjutkan belanja untuk mendapatkan promo menarik lainnya',
                                    style: AppTextStyle.mediumGrey
                                        .copyWith(height: 1.5),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Konfirmasi',
                        style: AppTextStyle.largeWhiteBold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
