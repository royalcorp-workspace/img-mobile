import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/services/auth_service.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/models/register_params_model.dart';
import 'package:img/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Login States
  final TextEditingController loginEmailC = TextEditingController();
  final TextEditingController loginPassC = TextEditingController();
  var isLoginPasswordHidden = true.obs;
  var isLoggingIn = false.obs;

  // Register States
  final TextEditingController registerNameC = TextEditingController();
  final TextEditingController registerEmailC = TextEditingController();
  final TextEditingController registerPhoneC = TextEditingController();
  final TextEditingController registerPassC = TextEditingController();
  final TextEditingController registerConfirmPassC = TextEditingController();
  var isRegisterPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  // var isTermsAccepted = false.obs;
  var isRegistering = false.obs;

  void toggleLoginPassword() {
    isLoginPasswordHidden.value = !isLoginPasswordHidden.value;
  }

  void toggleRegisterPassword() {
    isRegisterPasswordHidden.value = !isRegisterPasswordHidden.value;
  }

  void toggleConfirmPassword() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // void toggleTermsAccepted(bool? value) {
  //   if (value != null) {
  //     isTermsAccepted.value = value;
  //   }
  // }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Login with email and password
  void login() async {
    logger.info('🔍 [CONTROLLER] Starting email login...');
    final email = loginEmailC.text.trim();
    final password = loginPassC.text;

    logger.info('Email: $email');

    // Validation
    if (email.isEmpty) {
      logger.warning('⚠️ [CONTROLLER] Email is empty');

      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Email diperlukan', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (!_isValidEmail(email)) {
      logger.warning('⚠️ [CONTROLLER] Invalid email format: $email');

      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText:
            Text('Masukkan email yang valid', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (password.isEmpty) {
      logger.warning('⚠️ [CONTROLLER] Password is empty');
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText:
            Text('Kata sandi diperlukan', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (password.length < 6) {
      logger.warning('⚠️ [CONTROLLER] Password too short');

      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Kata sandi harus minimal 6 karakter',
            style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    try {
      isLoggingIn.value = true;
      logger.info('🔍 [CONTROLLER] Calling AuthService.loginWithEmail()');
      final success = await _authService.login(
          email: email.isEmpty ? 'testloginuser@test.com' : email,
          password: password.isEmpty ? 'TestPass123!' : password);

      if (success) {
        logger.info('✅ [CONTROLLER] Login successful, navigating...');
        Get.offAllNamed(Routes.NAVIGATION);
      } else {
        logger.warning('⚠️ [CONTROLLER] Login failed');

        Get.snackbar(
          '',
          '',
          titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
          messageText: Text(
              'Gagal masuk. Periksa kembali email dan kata sandi Anda.',
              style: AppTextStyle.mediumWhite),
          backgroundColor:
              Get.context?.theme.colorScheme.error ?? AppColors.red,
          colorText: AppColors.white,
        );
      }
    } on Exception catch (e) {
      logger.severe('❌ [CONTROLLER] Login error: $e');
      String errorMsg =
          'Gagal masuk. Periksa kembali koneksi atau kredensial Anda.';
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMsg = 'Email atau kata sandi salah';
      } else if (e.toString().contains('user-not-found')) {
        errorMsg = 'Pengguna tidak ditemukan';
      } else if (e.toString().contains('wrong-password')) {
        errorMsg = 'Kata sandi salah';
      } else if (e.toString().contains('invalid-email')) {
        errorMsg = 'Email tidak valid';
      } else if (e.toString().contains('user-disabled')) {
        errorMsg = 'Akun pengguna dinonaktifkan';
      }

      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text(errorMsg, style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isLoggingIn.value = false;
    }
  }

  /// Register with email and password
  Future<void> register() async {
    final name = registerNameC.text.trim();
    final email = registerEmailC.text.trim();
    final phone = registerPhoneC.text.trim();
    final password = registerPassC.text;
    final confirmPassword = registerConfirmPassC.text;

    // Validation
    if (name.isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Nama diperlukan', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (email.isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Email diperlukan', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (!_isValidEmail(email)) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText:
            Text('Masukkan email yang valid', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (phone.isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText:
            Text('Nomor telepon diperlukan', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (password.isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText:
            Text('Kata sandi diperlukan', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (password.length < 6) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text('Kata sandi harus minimal 6 karakter',
            style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText:
            Text('Kata sandi tidak sesuai', style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }
    // if (!isTermsAccepted.value) {
    //   Get.snackbar(
    //     '',
    //     '',
    //     titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
    //     messageText: Text('Harap terima Syarat & Ketentuan',
    //         style: AppTextStyle.mediumWhite),
    //     backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
    //     colorText: AppColors.white,
    //   );
    //   return;
    // }

    try {
      isRegistering.value = true;
      await _authService.register(email: email, password: password);
      Get.offAllNamed(Routes.NAVIGATION);
    } on Exception catch (e) {
      String errorMsg = 'Gagal mendaftar';
      if (e.toString().contains('email-already-in-use')) {
        errorMsg = 'Email sudah terdaftar';
      } else if (e.toString().contains('invalid-email')) {
        errorMsg = 'Email tidak valid';
      } else if (e.toString().contains('weak-password')) {
        errorMsg = 'Kata sandi terlalu lemah';
      }

      Get.snackbar(
        '',
        '',
        titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
        messageText: Text(errorMsg, style: AppTextStyle.mediumWhite),
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isRegistering.value = false;
    }
  }

  /// Sign in with Gmail
  Future<void> loginWithGmail() async {
    logger.info('🔍 [CONTROLLER] Starting Gmail sign-in flow...');
    try {
      isLoggingIn.value = true;
      logger.info('🔍 [CONTROLLER] Calling AuthService.loginWithGmail()');
      final result = await _authService.loginWithGmail();

      if (result == null) {
        logger.warning('⚠️ [CONTROLLER] Gmail sign-in was cancelled by user');
        Get.snackbar('ℹ️', 'Gmail sign-in dibatalkan',
            backgroundColor: Get.context!.theme.colorScheme.tertiary,
            colorText: Colors.white);
        return;
      }

      if (result == true) {
        logger.info(
            '✅ [CONTROLLER] Gmail sign-in verified by server, navigating...');
        Get.offAllNamed(Routes.NAVIGATION);
      }
    } on Exception catch (e) {
      logger.severe('❌ [CONTROLLER] Gmail sign-in error: $e');
      logger.severe('  Error type: ${e.runtimeType}');
      logger.severe('  Full error: ${e.toString()}');
      Get.snackbar('Kesalahan', 'Gagal masuk dengan Gmail: ${e.toString()}',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoggingIn.value = false;
    }
  }

  /// Sign in with Apple
  Future<void> loginWithApple() async {
    logger.info('🔍 [CONTROLLER] Starting Apple sign-in flow...');
    try {
      isLoggingIn.value = true;
      logger.info('🔍 [CONTROLLER] Calling AuthService.loginWithApple()');
      final result = await _authService.loginWithApple();

      if (result == null) {
        logger.warning('⚠️ [CONTROLLER] Apple sign-in was cancelled by user');

        Get.snackbar('', '',
            titleText: Text('ℹ️', style: AppTextStyle.largeWhiteBold),
            messageText: Text('Apple sign-in dibatalkan',
                style: AppTextStyle.mediumWhite),
            backgroundColor:
                Get.context?.theme.colorScheme.error ?? AppColors.red,
            colorText: AppColors.white,
            duration: Duration(seconds: 5));
        return;
      }

      logger.info('✅ [CONTROLLER] Apple sign-in successful, navigating...');
      Get.offAllNamed(Routes.NAVIGATION);
    } on Exception catch (e) {
      logger.severe('❌ [CONTROLLER] Apple sign-in error: $e');
      logger.severe('  Error type: ${e.runtimeType}');
      logger.severe('  Full error: ${e.toString()}');

      Get.snackbar('', '',
          titleText: Text('Kesalahan', style: AppTextStyle.largeWhiteBold),
          messageText: Text('Gagal masuk dengan Apple: ${e.toString()}',
              style: AppTextStyle.mediumWhite),
          backgroundColor:
              Get.context?.theme.colorScheme.error ?? AppColors.red,
          colorText: AppColors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoggingIn.value = false;
    }
  }
}
