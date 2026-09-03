import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/datasources/check_status_payment_remote_datasource.dart';
import 'package:pos_royal/app/data/repositories/check_status_payment_repository_impl.dart';
import 'package:pos_royal/app/domain/entities/checkout_entity.dart';
import 'package:pos_royal/app/domain/entities/order_entity.dart';
import 'package:pos_royal/app/domain/usecases/check_status_payment_usecase.dart';
import 'package:pos_royal/app/routes/app_pages.dart';

class PaymentController extends GetxController {
  PaymentController({this.checkStatusPaymentUsecase});

  final CheckStatusPaymentUsecase? checkStatusPaymentUsecase;

  Timer? _timer;

  RxInt start = 0.obs;
  OrderEntity? createdOrder;
  CheckoutEntity? checkoutResult;
  RxString paymentStatus = 'PENDING'.obs;
  RxBool isCheckingStatus = false.obs;
  RxString orderId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is List) {
      final args = Get.arguments as List;
      if (args.isNotEmpty) {
        if (args[0] is CheckoutEntity) {
          checkoutResult = args[0] as CheckoutEntity;
        }
        if (args.length > 1 && args[1] is String) {
          orderId.value = (args[1] as String);
        }
      }
    }

    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String get formattedTime {
    final duration = Duration(seconds: start.value);

    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours : $minutes : $seconds';
  }

  String get formattedExpiredDate {
    final value = checkoutResult?.vaExpired;

    if (value == null || value.isEmpty) {
      return '-';
    }

    try {
      final expiredAt = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).parse(value);

      return DateFormat(
        'dd MMM yyyy hh:mm a',
      ).format(expiredAt);
    } catch (_) {
      return '-';
    }
  }

  void startTimer() {
    final vaExpired = checkoutResult?.vaExpired;

    if (vaExpired == null || vaExpired.isEmpty) {
      start.value = 0;
      _timer?.cancel();
      return;
    }

    try {
      final expiredAt = DateFormat('yyyy-MM-dd HH:mm:ss').parse(vaExpired);
      _updateRemainingTime(expiredAt);

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateRemainingTime(expiredAt);
      });
    } catch (_) {
      start.value = 0;
      _timer?.cancel();
    }
  }

  void _updateRemainingTime(DateTime expiredAt) {
    final now = DateTime.now();
    final difference = expiredAt.difference(now);

    if (difference.inSeconds <= 0) {
      start.value = 0;
      _timer?.cancel();
      return;
    }

    start.value = difference.inSeconds;
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
        finishPayment();
        isCheckingStatus.value = false;
      } else {
        isCheckingStatus.value = false;
        Get.snackbar(
          'Pembayaran Belum Selesai! ⏳',
          '${checkoutResult?.payment?.description} akan otomatis dibatalkan dalam $formattedTime. Silakan lakukan pembayaran',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [CHECK PAYMENT STATUS Failed to check status: $e');
      if (kDebugMode) {
        print('❌ [CHECK PAYMENT STATUS Error checkout: $e');
        print(stackTrace);
      }
      Get.snackbar(
        'Kesalahan $e',
        'Terjadi kesalahan saat mengecek status pembayaran. Silakan coba beberapa saat lagi.',
        backgroundColor: Get.context!.theme.colorScheme.error,
        colorText: Colors.white,
      );
    } finally {
      isCheckingStatus.value = false;
    }
  }

  void finishPayment() {
    Get.offAllNamed(Routes.SUCCESS);
  }
}
