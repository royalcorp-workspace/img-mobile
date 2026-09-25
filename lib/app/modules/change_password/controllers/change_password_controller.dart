import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        'Kesalahan',
        'Kata sandi saat ini tidak boleh kosong',
        backgroundColor: Get.context!.theme.colorScheme.error,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.isEmpty) {
      Get.snackbar(
        'Kesalahan',
        'Kata sandi baru tidak boleh kosong',
        backgroundColor: Get.context!.theme.colorScheme.error,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar(
        'Kesalahan',
        'Kata sandi baru minimal 8 karakter',
        backgroundColor: Get.context!.theme.colorScheme.error,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Kesalahan',
        'Konfirmasi kata sandi baru tidak cocok',
        backgroundColor: Get.context!.theme.colorScheme.error,
        colorText: Colors.white,
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
        'Berhasil',
        'Kata sandi Anda berhasil diubah',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      logger.severe('❌ [CHANGE-PASSWORD] Error changing password: $e');
      Get.snackbar(
        'Gagal',
        'Gagal mengubah kata sandi. Pastikan kata sandi saat ini benar.',
        backgroundColor: Get.context!.theme.colorScheme.error,
        colorText: Colors.white,
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
