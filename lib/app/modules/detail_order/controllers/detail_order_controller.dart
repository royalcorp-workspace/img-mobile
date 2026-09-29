import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/data/datasources/check_status_payment_remote_datasource.dart';
import 'package:img/app/data/repositories/check_status_payment_repository_impl.dart';
import 'package:img/app/domain/entities/checkout_entity.dart';
import 'package:img/app/domain/usecases/check_status_payment_usecase.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/order_remote_datasource.dart';
import 'package:img/app/data/repositories/order_repository_impl.dart';
import 'package:img/app/domain/entities/order_tracking_entity.dart';
import 'package:img/app/domain/usecases/get_order_detail_usecase.dart';

class DetailOrderController extends GetxController {
  DetailOrderController({
    this.getOrderDetailUsecase,
    this.checkStatusPaymentUsecase,
  });

  final GetOrderDetailUsecase? getOrderDetailUsecase;
  final CheckStatusPaymentUsecase? checkStatusPaymentUsecase;

  final rating = 0.obs;
  final actualStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final orderId = ''.obs;

  final orderTracking = Rxn<OrderTrackingEntity>();
  CheckoutEntity? checkoutResult;

  RxBool selectedReason1 = false.obs;
  RxBool selectedReason2 = false.obs;
  RxBool selectedReason3 = false.obs;
  RxBool selectedReason4 = false.obs;
  RxBool isCheckingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    _extractOrderIdAndFetch();
  }

  void _extractOrderIdAndFetch() {
    final args = Get.arguments;
    String? extractedId;

    if (args is String && args.isNotEmpty) {
      extractedId = args;
    } else if (args is Map) {
      extractedId = args['order_id']?.toString() ?? args['id']?.toString();
    }

    if (extractedId != null && extractedId.isNotEmpty) {
      orderId.value = extractedId;
      fetchOrderDetail(extractedId);
    }
  }

  Future<void> fetchOrderDetail(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final useCase = getOrderDetailUsecase ??
          GetOrderDetailUsecase(
            OrderRepositoryImpl(
              remoteDataSource: OrderRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(id);
      orderTracking.value = result;

      if (result.events.isNotEmpty) {
        actualStep.value = result.events.length - 1;
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [DETAIL ORDER] Failed to fetch order tracking: $e');
      if (kDebugMode) {
        print('❌ [DETAIL ORDER] Error: $e');
        print(stackTrace);
      }
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  double get itemsSubtotal {
    final items = orderTracking.value?.items ?? [];
    double sum = 0.0;
    for (var item in items) {
      sum += item.total;
    }
    return sum;
  }

  double get itemsTotalDiscount {
    final items = orderTracking.value?.items ?? [];
    double sum = 0.0;
    for (var item in items) {
      sum += item.discountNominal * item.quantity;
    }
    return sum;
  }

  String formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateStr);
      final formatted =
          DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime);
      return '$formatted WIB';
    } catch (_) {
      try {
        final dateTime = DateTime.parse(dateStr);
        final formatted = DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
        return '$formatted WIB';
      } catch (_) {
        return dateStr;
      }
    }
  }

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
                          const Duration(milliseconds: 800),
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
                    const Icon(
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

  Future<void> checkPaymentStatus() async {
    try {
      logger.info(
          '🔍 [CHECK PAYMENT STATUS] Initiating check payment status creation...');
      isCheckingStatus.value = true;

      final useCase = checkStatusPaymentUsecase ??
          CheckStatusPaymentUsecase(
            CheckStatusPaymentRepositoryImpl(
              remoteDataSource: CheckStatusPaymentRemoteDataSourceImpl(),
            ),
          );

      final checkPaymentStatusResult = await useCase.call(orderId.value);
      logger.info(
          '✅ [CHECK PAYMENT STATUS] Check Payment Status successfully! Checkout status: ${checkPaymentStatusResult.isPaid}');

      await Future.delayed(const Duration(seconds: 1));

      if (checkPaymentStatusResult.isPaid) {
        isCheckingStatus.value = false;

        finishPayment();
      } else {
        isCheckingStatus.value = false;

        Get.snackbar(
          '',
          '',
          titleText: Text('Pembayaran Belum Selesai! ⏳',
              style: AppTextStyle.largeWhiteBold),
          messageText: Text(
              '${checkoutResult?.payment?.description ?? "Metode pembayaran yang dipilih"} belum terselesaikan. Silakan lakukan pembayaran terlebih dahulu.',
              style: AppTextStyle.mediumWhite),
          backgroundColor:
              Get.context?.theme.colorScheme.error ?? AppColors.red,
          colorText: AppColors.white,
        );
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [CHECK PAYMENT STATUS] Failed to check status: $e');
      if (kDebugMode) {
        print('❌ [CHECK PAYMENT STATUS] Error checkout: $e');
        print(stackTrace);
      }

      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text(
            'Terjadi kesalahan saat mengecek status pembayaran. Silakan coba lagi.',
            style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isCheckingStatus.value = false;
    }
  }

  void finishPayment() {
    Get.offAllNamed(Routes.SUCCESS, arguments: orderId.value);
  }
}
