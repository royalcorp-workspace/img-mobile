import 'package:get/get.dart';
import 'package:pos_royal/app/routes/app_pages.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/shared/data/app_shared_prefs.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _onSplashStarted();
  }

  void _onSplashStarted() async {
    await Future.delayed(const Duration(seconds: 2));

    // 1. If valid token exists -> go straight to NAVIGATION (skip onboarding & login)
    if (TokenStorage.serverToken != null && TokenStorage.serverToken!.isNotEmpty) {
      Get.offAllNamed(Routes.NAVIGATION);
      return;
    }

    // 2. Otherwise check if onboarding has been shown once before
    final prefs = Get.find<AppSharedPrefs>();
    final seenOnboarding = await prefs.read('seen_onboarding');

    if (seenOnboarding == 'true') {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }
}
