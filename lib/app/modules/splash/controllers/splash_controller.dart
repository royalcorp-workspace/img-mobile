import 'package:get/get.dart';
import 'package:pos_royal/app/routes/app_pages.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/shared/data/app_shared_prefs.dart';

// Check onboarding flag first, then auth token

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _onSplashStarted();
  }

  void _onSplashStarted() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = Get.find<AppSharedPrefs>();
    final seen = await prefs.read('seen_onboarding');
    if (seen == null) {
      Get.offNamed(Routes.ONBOARDING);
      return;
    }

    if (TokenStorage.serverToken != null) {
      Get.offNamed(Routes.NAVIGATION);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}
