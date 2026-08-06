import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/services/auth_service.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/routes/app_pages.dart';

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
  var isTermsAccepted = false.obs;
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

  void toggleTermsAccepted(bool? value) {
    if (value != null) {
      isTermsAccepted.value = value;
    }
  }

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

    logger.info('  Email: $email');

    // Validation
    // if (email.isEmpty) {
    //   logger.warning('⚠️ [CONTROLLER] Email is empty');
    //   Get.snackbar('Kesalahan', 'Email diperlukan',
    //       backgroundColor: Get.context!.theme.colorScheme.error,
    //       colorText: Colors.white);
    //   return;
    // }
    // if (!_isValidEmail(email)) {
    //   logger.warning('⚠️ [CONTROLLER] Invalid email format: $email');
    //   Get.snackbar('Kesalahan', 'Masukkan email yang valid',
    //       backgroundColor: Get.context!.theme.colorScheme.error,
    //       colorText: Colors.white);
    //   return;
    // }
    // if (password.isEmpty) {
    //   logger.warning('⚠️ [CONTROLLER] Password is empty');
    //   Get.snackbar('Kesalahan', 'Kata sandi diperlukan',
    //       backgroundColor: Get.context!.theme.colorScheme.error,
    //       colorText: Colors.white);
    //   return;
    // }
    // if (password.length < 6) {
    //   logger.warning('⚠️ [CONTROLLER] Password too short');
    //   Get.snackbar('Kesalahan', 'Kata sandi harus minimal 6 karakter',
    //       backgroundColor: Get.context!.theme.colorScheme.error,
    //       colorText: Colors.white);
    //   return;
    // }

    try {
      isLoggingIn.value = true;
      logger.info('🔍 [CONTROLLER] Calling AuthService.loginWithEmail()');
      final success = await _authService.loginWithEmail(
          email: 'testloginuser@test.com', password: 'TestPass123!');

      if (success) {
        logger.info('✅ [CONTROLLER] Login successful, navigating...');
        Get.offAllNamed(Routes.NAVIGATION);
      } else {
        logger.warning('⚠️ [CONTROLLER] Login failed');
        Get.snackbar('Kesalahan',
            'Gagal masuk. Periksa kembali email dan kata sandi Anda.',
            backgroundColor: Get.context!.theme.colorScheme.error,
            colorText: Colors.white);
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
      Get.snackbar('Kesalahan', errorMsg,
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
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
      Get.snackbar('Kesalahan', 'Nama diperlukan',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }
    if (email.isEmpty) {
      Get.snackbar('Kesalahan', 'Email diperlukan',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }
    if (!_isValidEmail(email)) {
      Get.snackbar('Kesalahan', 'Masukkan email yang valid',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }
    if (phone.isEmpty) {
      Get.snackbar('Kesalahan', 'Nomor telepon diperlukan',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Kesalahan', 'Kata sandi diperlukan',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Kesalahan', 'Kata sandi harus minimal 6 karakter',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar('Kesalahan', 'Kata sandi tidak sesuai',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }
    if (!isTermsAccepted.value) {
      Get.snackbar('Kesalahan', 'Harap terima Syarat & Ketentuan',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }

    try {
      isRegistering.value = true;
      await _authService.registerWithEmail(email: email, password: password);
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
      Get.snackbar('Kesalahan', errorMsg,
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
    } finally {
      isRegistering.value = false;
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    logger.info('🔍 [CONTROLLER] Starting Google sign-in flow...');
    try {
      isLoggingIn.value = true;
      logger.info('🔍 [CONTROLLER] Calling AuthService.signInWithGoogle()');
      final result = await _authService.signInWithGoogle();

      if (result == null) {
        logger.warning('⚠️ [CONTROLLER] Google sign-in was cancelled by user');
        Get.snackbar('ℹ️', 'Google sign-in dibatalkan',
            backgroundColor: Get.context!.theme.colorScheme.tertiary,
            colorText: Colors.white);
        return;
      }

      logger.info('✅ [CONTROLLER] Google sign-in successful, navigating...');
      Get.offAllNamed(Routes.NAVIGATION);
    } on Exception catch (e) {
      logger.severe('❌ [CONTROLLER] Google sign-in error: $e');
      logger.severe('  Error type: ${e.runtimeType}');
      logger.severe('  Full error: ${e.toString()}');
      Get.snackbar('Kesalahan', 'Gagal masuk dengan Google: ${e.toString()}',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoggingIn.value = false;
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    logger.info('🔍 [CONTROLLER] Starting Apple sign-in flow...');
    try {
      isLoggingIn.value = true;
      logger.info('🔍 [CONTROLLER] Calling AuthService.signInWithApple()');
      final result = await _authService.signInWithApple();

      if (result == null) {
        logger.warning('⚠️ [CONTROLLER] Apple sign-in was cancelled by user');
        Get.snackbar('ℹ️', 'Apple sign-in dibatalkan',
            backgroundColor: Get.context!.theme.colorScheme.tertiary,
            colorText: Colors.white);
        return;
      }

      logger.info('✅ [CONTROLLER] Apple sign-in successful, navigating...');
      Get.offAllNamed(Routes.NAVIGATION);
    } on Exception catch (e) {
      logger.severe('❌ [CONTROLLER] Apple sign-in error: $e');
      logger.severe('  Error type: ${e.runtimeType}');
      logger.severe('  Full error: ${e.toString()}');
      Get.snackbar('Kesalahan', 'Gagal masuk dengan Apple: ${e.toString()}',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoggingIn.value = false;
    }
  }

  @override
  void onClose() {
    loginEmailC.dispose();
    loginPassC.dispose();
    registerNameC.dispose();
    registerEmailC.dispose();
    registerPhoneC.dispose();
    registerPassC.dispose();
    registerConfirmPassC.dispose();
    super.onClose();
  }
}
