import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/shared/widgets/button/primary_button.dart';
import 'package:img/app/shared/widgets/stepper/app_simple_vertical_step_indicator.dart';

import '../controllers/detail_order_controller.dart';

class DetailOrderView extends GetView<DetailOrderController> {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail Order',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.orderTracking.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.red,
                    size: 60,
                  ),
                  16.verticalSpace,
                  Text(
                    'Gagal memuat detail pesanan',
                    style: AppTextStyle.largeBlackBold,
                    textAlign: TextAlign.center,
                  ),
                  8.verticalSpace,
                  Text(
                    controller.errorMessage.value,
                    style: AppTextStyle.mediumGrey,
                    textAlign: TextAlign.center,
                  ),
                  20.verticalSpace,
                  ElevatedButton(
                    onPressed: () {
                      if (controller.orderId.isNotEmpty) {
                        controller.fetchOrderDetail(controller.orderId.value);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Coba Lagi',
                      style: AppTextStyle.mediumWhiteBold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final tracking = controller.orderTracking.value;
        if (tracking == null) {
          return const _DefaultDetailOrderContent();
        }

        return SingleChildScrollView(
          child: RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,

                /// Order Status Header Badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tracking.currentStatus.isNotEmpty
                                  ? tracking.currentStatus
                                  : tracking.statusLabel,
                              style: AppTextStyle.largeBlackBold.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            2.verticalSpace,
                            Text(
                              'Nomor Pesanan: ${tracking.orderNumber}',
                              style: AppTextStyle.mediumGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                20.verticalSpace,

                /// Items List
                Text(
                  'Produk Pesanan (${tracking.items.length})',
                  style: AppTextStyle.largeBlackBold,
                ),
                10.verticalSpace,

                ...tracking.items.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightGrey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: item.thumbnail.isNotEmpty
                                ? Image.network(
                                    item.thumbnail,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      Helper.getImagePath('img_product1.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    Helper.getImagePath('img_product1.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: AppTextStyle.mediumBlackBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              4.verticalSpace,
                              if (item.variantName.isNotEmpty)
                                Text(
                                  'Varian: ${item.variantName}',
                                  style: AppTextStyle.mediumGrey,
                                ),
                              6.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.quantity} x ${Helper.formatCurrency(item.sellPrice.toInt())}',
                                    style: AppTextStyle.mediumBlack,
                                  ),
                                  Text(
                                    Helper.formatCurrency(item.total.toInt()),
                                    style: AppTextStyle.mediumBlackBold,
                                  ),
                                ],
                              ),
                              if (item.hasAdjustment &&
                                  item.discountPercent > 0) ...[
                                4.verticalSpace,
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.shadeRed,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '-${item.discountPercent.toInt()}%',
                                        style: AppTextStyle.mediumBlackBold
                                            .copyWith(
                                          color: AppColors.red,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                    6.horizontalSpace,
                                    Text(
                                      Helper.formatCurrency(
                                          item.originalPrice.toInt()),
                                      style: AppTextStyle.mediumGrey.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                5.verticalSpace,
                Visibility(
                  visible: tracking.status == 1,
                  child: Obx(
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
                ),

                5.verticalSpace,
                const Divider(color: AppColors.lightGrey, thickness: 1.2),
                15.verticalSpace,

                /// Delivery & Tracking Timeline
                Text(
                  'Dikirim dengan ${tracking.courierName ?? "Kurir"}',
                  style: AppTextStyle.largeBlackBold,
                ),
                if (tracking.trackingNumber != null &&
                    tracking.trackingNumber!.isNotEmpty) ...[
                  6.verticalSpace,
                  Row(
                    children: [
                      Text(
                        'No. Resi: ${tracking.trackingNumber}',
                        style: AppTextStyle.mediumGrey,
                      ),
                      8.horizontalSpace,
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: tracking.trackingNumber!));

                          Get.snackbar(
                            '',
                            '',
                            titleText: Text('Berhasil',
                                style: AppTextStyle.largeWhiteBold),
                            messageText: Text('Nomor resi telah disalin',
                                style: AppTextStyle.mediumWhite),
                            backgroundColor: AppColors.green,
                            colorText: AppColors.white,
                          );
                        },
                        child: const Icon(
                          Icons.copy,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],

                15.verticalSpace,

                /// Dynamic Events Stepper
                if (tracking.events.isNotEmpty) ...[
                  Obx(
                    () => AppSimpleVerticalStepIndicator(
                      height:
                          (tracking.events.length * 65.0).clamp(120.0, 400.0),
                      actualStep: controller.actualStep.value,
                      titles: tracking.events.map((e) => e.status).toList(),
                      timestamps: tracking.events
                          .map((e) =>
                              '${e.location} - ${controller.formatDateString(e.createdAt)}')
                          .toList(),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Belum ada riwayat pelacakan',
                    style: AppTextStyle.mediumGrey,
                  ),
                ],

                // 15.verticalSpace,

                /// Action Buttons (on HOLD)
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(28),
                //       ),
                //       backgroundColor: AppColors.primaryColor,
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //     ),
                //     onPressed: () => controller.showConfirmationDialog(),
                //     child: Text(
                //       'Konfirmasi Selesai',
                //       style: AppTextStyle.mediumWhiteBold,
                //     ),
                //   ),
                // ),
                // 10.verticalSpace,
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(28),
                //       ),
                //       backgroundColor: AppColors.red,
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //     ),
                //     onPressed: () => controller.showCancelOrderDialog(),
                //     child: Text(
                //       'Batalkan Pesanan',
                //       style: AppTextStyle.mediumWhiteBold,
                //     ),
                //   ),
                // ),

                const Divider(color: AppColors.lightGrey, thickness: 1.2),
                15.verticalSpace,

                /// Shipping & Order Info
                Text(
                  'Informasi Pengiriman',
                  style: AppTextStyle.largeBlackBold,
                ),
                15.verticalSpace,

                Text(
                  'Kurir Pengiriman',
                  style: AppTextStyle.largeBlack,
                ),
                5.verticalSpace,
                Text(
                  tracking.courierName ?? 'Kurir',
                  style: AppTextStyle.mediumGrey,
                ),
                15.verticalSpace,

                Text(
                  'Kode Pesanan',
                  style: AppTextStyle.largeBlack,
                ),
                5.verticalSpace,
                Text(
                  '#${tracking.orderNumber}',
                  style: AppTextStyle.mediumGrey,
                ),
                20.verticalSpace,

                /// Transaction Summary Expansion
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.lightGrey),
                      bottom: BorderSide(color: AppColors.lightGrey),
                    ),
                  ),
                  child: ExpansionTile(
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.centerLeft,
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    iconColor: AppColors.black,
                    title: Text(
                      'Detail Pesanan',
                      style: AppTextStyle.largeBlackBold,
                    ),
                    children: [
                      Text(
                        'Ringkasan Transaksi',
                        style: AppTextStyle.largeBlackBold,
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pembelian',
                            style: AppTextStyle.mediumGrey,
                          ),
                          Text(
                            Helper.formatCurrency(
                                controller.itemsSubtotal.toInt()),
                            style: AppTextStyle.mediumBlack,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ongkos Kirim',
                            style: AppTextStyle.mediumGrey,
                          ),
                          Text(
                            Helper.formatCurrency(
                                tracking.shippingCost.toInt()),
                            style: AppTextStyle.mediumBlack,
                          ),
                        ],
                      ),
                      if (tracking.shippingCostSubsidy > 0) ...[
                        10.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subsidi Ongkir',
                              style: AppTextStyle.mediumGrey,
                            ),
                            Text(
                              '-${Helper.formatCurrency(tracking.shippingCostSubsidy.toInt())}',
                              style: AppTextStyle.mediumBlack
                                  .copyWith(color: AppColors.red),
                            ),
                          ],
                        ),
                      ],
                      if (tracking.voucherNominal > 0) ...[
                        10.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Voucher Diskon',
                              style: AppTextStyle.mediumGrey,
                            ),
                            Text(
                              '-${Helper.formatCurrency(tracking.voucherNominal.toInt())}',
                              style: AppTextStyle.mediumBlack
                                  .copyWith(color: AppColors.red),
                            ),
                          ],
                        ),
                      ],
                      15.verticalSpace,
                      Image.asset(
                        Helper.getImagePath('img_divider.png'),
                      ),
                      15.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Tagihan',
                            style: AppTextStyle.mediumBlack,
                          ),
                          Text(
                            Helper.formatCurrency(
                              (controller.itemsSubtotal +
                                      tracking.shippingCost -
                                      tracking.shippingCostSubsidy -
                                      tracking.voucherNominal)
                                  .toInt(),
                            ),
                            style: AppTextStyle.mediumBlackBold,
                          ),
                        ],
                      ),
                      5.verticalSpace,
                    ],
                  ),
                ),

                // 20.verticalSpace,
                // const Divider(color: AppColors.lightGrey, thickness: 1.2),
                // 20.verticalSpace,

                /// Review Section
                // Text(
                //   'Biar praktis, ulas semua produk sekaligus !',
                //   style: AppTextStyle.largeBlackBold,
                // ),
                // 20.verticalSpace,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: List.generate(
                //     5,
                //     (_) {
                //       return SizedBox(
                //         width: 65,
                //         height: 65,
                //         child: Image.asset(
                //           Helper.getImagePath(
                //             'img_product1.jpg',
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // 20.verticalSpace,
                // Obx(
                //   () {
                //     final rating = controller.rating.value;
                //     return Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: List.generate(5, (index) {
                //         return GestureDetector(
                //           onTap: () {
                //             controller.rating.value = index + 1;
                //             log('INDEX $index');
                //             log('RATING ${controller.rating.value}');
                //           },
                //           child: Icon(
                //             index < rating ? Icons.star : Icons.star,
                //             color: index < rating
                //                 ? AppColors.secondaryColor
                //                 : AppColors.grey,
                //             size: 32,
                //           ),
                //         );
                //       }),
                //     );
                //   },
                // ),
                // 20.verticalSpace,
                // Container(
                //   width: Get.width,
                //   padding: const EdgeInsets.all(15),
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: AppColors.lightGrey,
                //     ),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: TextField(
                //     maxLines: 5,
                //     decoration: InputDecoration.collapsed(
                //       hintText:
                //           'Contoh: Barang berkualitas baik, tersegel dan aman ada garansi jika barang yang datang tidak sesuai gambar product. Pengiriman sangat cepat! Top!',
                //       hintStyle: AppTextStyle.mediumGrey,
                //     ),
                //     cursorColor: AppColors.primaryColor,
                //     style: AppTextStyle.mediumBlack,
                //   ),
                // ),
                // 15.verticalSpace,
                // DashedBorderContainer(
                //   color: AppColors.primaryColor,
                //   dashWidth: 4,
                //   dashGap: 4,
                //   strokeWidth: 0.6,
                //   borderRadius: BorderRadius.circular(8),
                //   padding: const EdgeInsets.all(20),
                //   child: SizedBox(
                //     width: Get.width,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Icon(
                //           Icons.camera_alt_outlined,
                //           color: AppColors.primaryColor,
                //           size: 20,
                //         ),
                //         15.horizontalSpace,
                //         Text(
                //           'Bagikan Foto atau Video Produk',
                //           style: AppTextStyle.mediumBlack.copyWith(
                //             color: AppColors.primaryColor,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // 40.verticalSpace,
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(28),
                //       ),
                //       backgroundColor: AppColors.primaryColor,
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //     ),
                //     onPressed: () => controller.showFeedbackDialog(),
                //     child: Text(
                //       'Berikan Ulasan',
                //       style: AppTextStyle.mediumWhiteBold,
                //     ),
                //   ),
                // ),
                40.verticalSpace,
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _DefaultDetailOrderContent extends StatelessWidget {
  const _DefaultDetailOrderContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      Helper.getImagePath(
                        'img_product1.jpg',
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                Text(
                  "Elite Springbed Kasur Pocket Emporium New Edition",
                  style: AppTextStyle.largeBlackBold,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                10.verticalSpace,
                Text(
                  '1 barang | #9ds69hs',
                  style: AppTextStyle.mediumGrey,
                ),
              ],
            ),
            15.verticalSpace,
            const Divider(color: AppColors.lightGrey, thickness: 1.2),
            15.verticalSpace,
            Text(
              'Dikirim dengan Instant - Lalamove',
              style: AppTextStyle.largeBlackBold,
            ),
            15.verticalSpace,
            const AppSimpleVerticalStepIndicator(
              height: 250,
              actualStep: 1,
              titles: [
                'Pesanan diterima',
                'Sedang diproses',
                'Dikirim',
                'Sampai tujuan',
              ],
              timestamps: [
                '28 Mei 2025, 09:00 WIB',
                '28 Mei 2025, 12:00 WIB',
                '29 Mei 2025, 08:30 WIB',
                '29 Mei 2025, 12:50 WIB',
              ],
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
