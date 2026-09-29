import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/domain/usecases/change_password_usecase.dart';

class ChangePasswordController extends GetxController {
  final ChangePasswordUsecase changePasswordUsecase;

  ChangePasswordController({
    required this.changePasswordUsecase,
  });

  final formKey = GlobalKey<FormState>();

  final oldPasswordC = TextEditingController();
  final newPasswordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  final isOldObscure = true.obs;
  final isNewObscure = true.obs;
  final isConfirmObscure = true.obs;

  final isLoading = false.obs;

  void toggleOldObscure() => isOldObscure.value = !isOldObscure.value;
  void toggleNewObscure() => isNewObscure.value = !isNewObscure.value;
  void toggleConfirmObscure() =>
      isConfirmObscure.value = !isConfirmObscure.value;

  Future<void> changePassword() async {
    final oldPassword = oldPasswordC.text;
    final newPassword = newPasswordC.text;
    final confirmPassword = confirmPasswordC.text;

    if (oldPassword.isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Kata sandi saat ini tidak boleh kosong',
            style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    if (newPassword.isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Kata sandi baru tidak boleh kosong',
            style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Kata sandi baru minimal 8 karakter',
            style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Konfirmasi kata sandi baru tidak cocok',
            style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await changePasswordUsecase(
        currentPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      Get.snackbar(
        '',
        '',
        titleText: Text('Berhasil', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Kata sandi Anda berhasil diubah',
            style: AppTextStyle.mediumWhite),
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
      );
    } catch (e) {
      logger.severe('❌ [CHANGE-PASSWORD] Error changing password: $e');

      Get.snackbar(
        '',
        '',
        titleText: Text('Gagal', style: AppTextStyle.largeWhiteBold),
        messageText: Text(
            'Gagal mengubah kata sandi. Pastikan kata sandi saat ini benar.',
            style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordC.dispose();
    newPasswordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }
}
