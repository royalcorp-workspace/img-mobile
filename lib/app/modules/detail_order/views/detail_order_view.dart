import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/shared/widgets/dashed_border_container.dart';
import 'package:pos_royal/app/shared/widgets/stepper/app_simple_vertical_step_indicator.dart';

import '../controllers/detail_order_controller.dart';

class DetailOrderView extends GetView<DetailOrderController> {
  const DetailOrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        title: const Text(
          'Detail Order',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: RPadding(
          padding: EdgeInsets.symmetric(horizontal: 14),
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
              Obx(
                () => AppSimpleVerticalStepIndicator(
                  height: 250,
                  actualStep: controller.actualStep.value,
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
                      AppColors.primaryColor,
                    ),
                  ),
                  onPressed: () => controller.showConfirmationDialog(),
                  child: Text(
                    'Konfirmasi Selesai',
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
                      AppColors.red,
                    ),
                  ),
                  onPressed: () => controller.showCancelOrderDialog(),
                  child: Text(
                    'Batalkan Pesanan',
                    style: AppTextStyle.mediumWhiteBold,
                  ),
                ),
              ),
              20.verticalSpace,
              const Divider(color: AppColors.lightGrey, thickness: 1.2),
              20.verticalSpace,
              Text(
                'Informasi Pengiriman',
                style: AppTextStyle.largeBlackBold,
              ),
              20.verticalSpace,
              Text(
                'Alamat Pesanan',
                style: AppTextStyle.largeBlack,
              ),
              10.verticalSpace,
              Text(
                'Jl. H. R. Rasuna Said No.Kav. 19A, RT.8/RW.4, Kuningan Tim., Kecamatan Setiabudi, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12950',
                style: AppTextStyle.mediumGrey,
              ),
              20.verticalSpace,
              Text(
                'Penerima',
                style: AppTextStyle.largeBlack,
              ),
              5.verticalSpace,
              Text(
                'Alghany Kennedy Adam',
                style: AppTextStyle.mediumGrey,
              ),
              20.verticalSpace,
              Text(
                'Kode Transaksi',
                style: AppTextStyle.largeBlack,
              ),
              5.verticalSpace,
              Text(
                '#9ds69hs',
                style: AppTextStyle.mediumGrey,
              ),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
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
                          'Rp. 70.500',
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
                          'Rp. 7.000',
                          style: AppTextStyle.mediumBlack,
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diskon Barang',
                          style: AppTextStyle.mediumGrey,
                        ),
                        Text('-Rp. 7.000',
                            style: AppTextStyle.mediumBlack
                                .copyWith(color: AppColors.red)),
                      ],
                    ),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Voucher Diskon (%)',
                          style: AppTextStyle.mediumGrey,
                        ),
                        Text(
                          '-Rp. 20.000',
                          style: AppTextStyle.mediumBlack
                              .copyWith(color: AppColors.red),
                        ),
                      ],
                    ),
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
                          'Rp. 50.500',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                      ],
                    ),
                    5.verticalSpace,
                  ],
                ),
              ),
              20.verticalSpace,
              Text(
                'Metode Pembayaran',
                style: AppTextStyle.largeBlack,
              ),
              5.verticalSpace,
              Text(
                'BCA Virtual Account',
                style: AppTextStyle.mediumGrey,
              ),
              20.verticalSpace,
              Text(
                'Tanggal Pembayaran',
                style: AppTextStyle.largeBlack,
              ),
              5.verticalSpace,
              Text(
                '28 May 2025, 06:00 WIB',
                style: AppTextStyle.mediumGrey,
              ),
              20.verticalSpace,
              Text(
                'Outlet Toko',
                style: AppTextStyle.largeBlack,
              ),
              5.verticalSpace,
              Text(
                'Royal Pusat',
                style: AppTextStyle.mediumGrey,
              ),
              20.verticalSpace,
              const Divider(color: AppColors.lightGrey, thickness: 1.2),
              20.verticalSpace,
              Text(
                'Biar praktis, ulas semua produk sekaligus !',
                style: AppTextStyle.largeBlackBold,
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (_) {
                    return SizedBox(
                      width: 65,
                      height: 65,
                      child: Image.asset(
                        Helper.getImagePath(
                          'img_product1.jpg',
                        ),
                      ),
                    );
                  },
                ),
              ),
              20.verticalSpace,
              Obx(
                () {
                  final rating = controller.rating.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          controller.rating.value = index + 1;
                          log('INDEX $index');
                          log('RATING ${controller.rating.value}');
                        },
                        child: Icon(
                          index < rating ? Icons.star : Icons.star,
                          color: index < rating
                              ? AppColors.secondaryColor
                              : AppColors.grey,
                          size: 32,
                        ),
                      );
                    }),
                  );
                },
              ),
              20.verticalSpace,
              Container(
                width: Get.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.lightGrey,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration.collapsed(
                    hintText:
                        'Contoh: Barang berkualitas baik, tersegel dan aman ada garansi jika barang yang datang tidak sesuai gambar product. Pengiriman sangat cepat! Top!',
                    hintStyle: AppTextStyle.mediumGrey,
                  ),
                  cursorColor: AppColors.primaryColor,
                  style: AppTextStyle.mediumBlack,
                ),
              ),
              15.verticalSpace,
              DashedBorderContainer(
                color: AppColors.primaryColor,
                dashWidth: 4,
                dashGap: 4,
                strokeWidth: 0.6,
                borderRadius: BorderRadius.circular(8),
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      15.horizontalSpace,
                      Text(
                        'Bagikan Foto atau Video Produk',
                        style: AppTextStyle.mediumBlack.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              40.verticalSpace,
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
                  onPressed: () => controller.showFeedbackDialog(),
                  child: Text(
                    'Berikan Ulasan',
                    style: AppTextStyle.mediumWhiteBold,
                  ),
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
