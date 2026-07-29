import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/domain/entities/order_entity.dart';
import 'package:pos_royal/app/routes/app_pages.dart';

class PaymentController extends GetxController {
  late Timer _timer;

  RxInt start = 300.obs;
  RxInt selectedPrice = 0.obs;
  RxInt selectedQty = 0.obs;
  OrderEntity? createdOrder;
  RxString paymentStatus = 'PENDING'.obs;
  RxBool isCheckingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is List) {
      final args = Get.arguments as List;
      if (args.isNotEmpty) {
        if (args[0] is OrderEntity) {
          createdOrder = args[0] as OrderEntity;
          selectedPrice.value = createdOrder!.subtotal.toInt();
        } else if (args[0] is num) {
          selectedPrice.value = (args[0] as num).toInt();
        }
      }
      if (args.length > 1 && args[1] is num) {
        selectedQty.value = (args[1] as num).toInt();
      }
      if (args.length > 2 && args[2] is num) {
        selectedQty.value = (args[2] as num).toInt();
      }
    }
    startTimer();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  String get formattedTime {
    final duration = Duration(seconds: start.value);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours : $minutes : $seconds';
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
        } else {
          start--;
        }
      },
    );
  }

  Future<void> checkPaymentStatus() async {
    try {
      isCheckingStatus.value = true;
      // Simulate/prepare ESPAY payment gateway status check call
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar(
        'Status Pembayaran',
        'Pesanan sedang diproses oleh Payment Gateway',
        backgroundColor: Get.context?.theme.colorScheme.primary ?? Colors.blue,
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
