import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/shared/widgets/button/primary_button.dart';
import '../../../core/styles/app_color.dart';
import '../../../core/styles/app_text_style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 45.h),
                // Logo Placeholder
                Center(
                  child: Column(
                    children: [
                      Image.asset(Helper.getImagePath('img_logo.webp'),
                              height: 80.h)
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: -0.2),
                      SizedBox(height: 18.h),
                      Text(
                        "Selamat Datang Kembali!",
                        style: AppTextStyle.xxxLargeBlackBold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Masuk untuk melanjutkan belanja",
                        style: AppTextStyle.mediumBlackSecondary
                            .copyWith(color: AppColors.textMedium),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),

                // Email Input
                Text(
                  'Email',
                  style: AppTextStyle.mediumBlackBold,
                ),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: controller.loginEmailC,
                  cursorColor: AppColors.primaryColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    hintText: "Masukkan email",
                    hintStyle: AppTextStyle.mediumGrey,
                    prefixIcon:
                        const Icon(Icons.mail_outline, color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.lightGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.lightGrey),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Kata Sandi',
                  style: AppTextStyle.mediumBlackBold,
                ),
                SizedBox(height: 4.h),

                // Password Input
                Obx(() => TextFormField(
                      controller: controller.loginPassC,
                      cursorColor: AppColors.primaryColor,
                      obscureText: controller.isLoginPasswordHidden.value,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.white,
                        hintText: "Masukkan kata sandi",
                        hintStyle: AppTextStyle.mediumGrey,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isLoginPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.grey,
                          ),
                          onPressed: controller.toggleLoginPassword,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide:
                              const BorderSide(color: AppColors.lightGrey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide:
                              const BorderSide(color: AppColors.lightGrey),
                        ),
                      ),
                    )),
                SizedBox(height: 12.h),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Lupa Kata Sandi?",
                      style: AppTextStyle.mediumBlackBold.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // Login Button
                Obx(
                  () => ButtonPrimary(
                    fullWidth: true,
                    text: 'Masuk',
                    textColor: AppColors.white,
                    isLoading: controller.isLoggingIn.value,
                    enable: !controller.isLoggingIn.value,
                    color: AppColors.primaryColor,
                    onPressed: controller.login,
                  ),
                ),

                SizedBox(height: 30.h),

                // Divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColors.lightGrey),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        "atau masuk dengan",
                        style: AppTextStyle.mediumBlackSecondary
                            .copyWith(color: AppColors.textMedium),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: AppColors.lightGrey),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                // Social Login:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: controller.signInWithGoogle,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 45.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.shadowGrey),
                          color: AppColors.white,
                        ),
                        child: SvgPicture.asset(
                          Helper.getSvgPath(
                            'ic_gmail.svg',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    GestureDetector(
                      onTap: controller.signInWithApple,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 45.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.shadowGrey),
                          color: AppColors.white,
                        ),
                        child: SvgPicture.asset(
                          Helper.getSvgPath(
                            'ic_apple.svg',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun? ",
                      style: AppTextStyle.mediumBlackSecondary
                          .copyWith(color: AppColors.textMedium),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.REGISTER),
                      child: Text(
                        "Daftar",
                        style: AppTextStyle.mediumWhiteBold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ));
  }
}
