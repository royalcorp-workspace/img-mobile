import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/shared/widgets/button/primary_button.dart';
import 'package:img/app/shared/widgets/textformfield/text_form_field_app.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shadowGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        title: const Text(
          'Ubah Kata Sandi',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.verticalSpace,
                Obx(
                  () => TextFormfieldApp(
                    title: 'Kata Sandi Saat Ini',
                    controller: controller.oldPasswordC,
                    hintText: 'Masukkan kata sandi saat ini',
                    obscureText: controller.isOldObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isOldObscure.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                      ),
                      onPressed: controller.toggleOldObscure,
                    ),
                  ),
                ),
                16.verticalSpace,
                Obx(
                  () => TextFormfieldApp(
                    title: 'Kata Sandi Baru',
                    controller: controller.newPasswordC,
                    hintText: 'Masukkan kata sandi baru',
                    obscureText: controller.isNewObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewObscure.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                      ),
                      onPressed: controller.toggleNewObscure,
                    ),
                  ),
                ),
                16.verticalSpace,
                Obx(
                  () => TextFormfieldApp(
                    title: 'Konfirmasi Kata Sandi Baru',
                    controller: controller.confirmPasswordC,
                    hintText: 'Ulangi kata sandi baru',
                    obscureText: controller.isConfirmObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmObscure.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                      ),
                      onPressed: controller.toggleConfirmObscure,
                    ),
                  ),
                ),
                32.verticalSpace,
                Obx(
                  () => ButtonPrimary(
                    fullWidth: true,
                    text: 'Simpan Kata Sandi',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.changePassword(),
                    borderRadius: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
