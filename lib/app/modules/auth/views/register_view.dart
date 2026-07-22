import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/shared/widgets/button/primary_button.dart';
import '../../../core/styles/app_color.dart';
import '../../../core/styles/app_text_style.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              // Logo Placeholder
              Image.asset(Helper.getImagePath('img_logo.webp'), height: 64)
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.2),
              SizedBox(height: 10.h),
              Text(
                "Buat Akun Baru",
                style: AppTextStyle.xxxLargeBlackBold.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                "Daftar dan nikmati pengalaman berbelanja terbaik",
                style: AppTextStyle.mediumBlackSecondary
                    .copyWith(color: AppColors.textMedium),
              ),
              SizedBox(height: 40.h),

              // Full Name Input
              _buildTextField(
                hint: "Nama Lengkap",
                icon: Icons.person_outline,
                controller: controller.registerNameC,
              ),
              SizedBox(height: 15.h),

              // Email Input
              _buildTextField(
                hint: "Email",
                icon: Icons.mail_outline,
                controller: controller.registerEmailC,
              ),
              SizedBox(height: 15.h),

              // Phone Number Input
              _buildTextField(
                hint: "Nomor Telepon",
                icon: Icons.phone_outlined,
                controller: controller.registerPhoneC,
              ),
              SizedBox(height: 15.h),

              // Password Input
              Obx(() => _buildPasswordField(
                    hint: "Kata Sandi",
                    isHidden: controller.isRegisterPasswordHidden.value,
                    onToggle: controller.toggleRegisterPassword,
                    controller: controller.registerPassC,
                  )),
              SizedBox(height: 15.h),

              // Confirm Password Input
              Obx(() => _buildPasswordField(
                    hint: "Konfirmasi Kata Sandi",
                    isHidden: controller.isConfirmPasswordHidden.value,
                    onToggle: controller.toggleConfirmPassword,
                    controller: controller.registerConfirmPassC,
                  )),
              SizedBox(height: 10.h),

              // Terms and Conditions
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: controller.isTermsAccepted.value,
                        onChanged: controller.toggleTermsAccepted,
                        activeColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r)),
                      )),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "Saya setuju dengan ",
                        style: AppTextStyle.smallBlackSecondary
                            .copyWith(color: AppColors.textMedium),
                        children: [
                          TextSpan(
                            text: "Syarat & Ketentuan",
                            style: AppTextStyle.smallBlackBold
                                .copyWith(color: AppColors.primaryColor),
                          ),
                          const TextSpan(text: "\ndan "),
                          TextSpan(
                            text: "Kebijakan Privasi",
                            style: AppTextStyle.smallBlackBold
                                .copyWith(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              // Create Account Button
              Obx(() => ButtonPrimary(
                    fullWidth: true,
                    text: 'Daftar',
                    isLoading: controller.isRegistering.value,
                    enable: !controller.isRegistering.value,
                    onPressed: controller.register,
                  )),
              SizedBox(height: 20.h),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.lightGrey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      "atau daftar dengan",
                      style: AppTextStyle.mediumBlackSecondary
                          .copyWith(color: AppColors.textMedium),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.lightGrey)),
                ],
              ),
              SizedBox(height: 20.h),

              // Social Login: Google
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    side: const BorderSide(color: AppColors.lightGrey),
                  ),
                  onPressed: controller.signInWithGoogle,
                  icon: SvgPicture.asset(
                    height: 20,
                    width: 20,
                    Helper.getSvgPath(
                      'ic_gmail.svg',
                    ),
                  ),
                  label: Text(
                    "Google",
                    style: AppTextStyle.mediumBlackBold,
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: AppTextStyle.mediumBlackSecondary
                        .copyWith(color: AppColors.textMedium),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(), // Go back to login
                    child: Text(
                      "Masuk sekarang",
                      style: AppTextStyle.mediumBlackBold
                          .copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyle.mediumGrey,
        prefixIcon: Icon(icon, color: AppColors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool isHidden,
    required VoidCallback onToggle,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyle.mediumGrey,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            isHidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.grey,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
      ),
    );
  }
}
