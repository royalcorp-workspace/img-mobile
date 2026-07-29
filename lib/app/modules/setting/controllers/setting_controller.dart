import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/data/models/user_model.dart';

class SettingController extends GetxController {
  var userModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    _getOrFetchCustomerId();
  }

  Future<String> _getOrFetchCustomerId() async {
    try {
      final userDataStr = await TokenStorage.getUserData();
      if (userDataStr != null && userDataStr.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userDataStr);
        final parsed = UserModel.fromJson(userMap);
        userModel.value = parsed;

        if (parsed.customer?.id != null &&
            parsed.customer!.id!.isNotEmpty) {
          return parsed.customer!.id!;
        }
        if (parsed.id != null && parsed.id!.isNotEmpty) {
          return parsed.id!;
        }
      }
    } catch (e) {
      logger.warning(
          '⚠️ [SETTING] Could not parse stored user customer ID: $e');
    }
    return "3fa85f64-5717-4562-b3fc-2c963f66afa6";
  }

  void showDeleteConfirmationDialog() {
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
                'Konfirmasi',
                style: AppTextStyle.xLargeBlackBold,
                textAlign: TextAlign.center,
              ),
              12.verticalSpace,
              Text(
                'Anda yakin akan keluar dari aplikasi?',
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
                        Get.offAllNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Keluar',
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
