import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/core/utils/token_storage.dart';
import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/data/models/user_model.dart';
import 'package:img/app/domain/usecases/get_customer_profile_usecase.dart';

class SettingController extends GetxController {
  final GetCustomerProfileUsecase? getCustomerProfileUsecase;

  SettingController({this.getCustomerProfileUsecase});

  var userModel = UserModel().obs;
  var customerModel = Rxn<CustomerModel>();
  var isLoadingProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    _loadFromTokenStorage();
    if (getCustomerProfileUsecase != null) {
      try {
        isLoadingProfile.value = true;
        final profile = await getCustomerProfileUsecase!();
        customerModel.value = profile;

        userModel.value = UserModel(
          id: profile.userId ?? userModel.value.id,
          name: profile.name ?? userModel.value.name,
          email: profile.email ?? userModel.value.email,
          username: userModel.value.username,
          customer: profile,
        );
      } catch (e) {
        logger.warning('⚠️ [SETTING] Error fetching customer profile me: $e');
      } finally {
        isLoadingProfile.value = false;
      }
    }
  }

  void _loadFromTokenStorage() {
    try {
      final userDataStr = TokenStorage.getUserData();
      userDataStr.then((str) {
        if (str != null && str.isNotEmpty) {
          final Map<String, dynamic> userMap = jsonDecode(str);
          final parsed = UserModel.fromJson(userMap);
          userModel.value = parsed;
          if (parsed.customer != null) {
            customerModel.value = parsed.customer;
          }
        }
      });
    } catch (e) {
      logger.warning('⚠️ [SETTING] Could not parse stored user data: $e');
    }
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
                      onPressed: () async {
                        await TokenStorage.clear();
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
