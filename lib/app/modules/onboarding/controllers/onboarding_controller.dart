import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/shared/data/app_shared_prefs.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentIndex = 0.obs;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Temukan Belanja\nPremium",
      "subtitle":
          "Temukan ribuan produk berkualitas\ndari penjual terpercaya di seluruh dunia.",
      "image": "assets/svg/onboarding_1.svg",
    },
    {
      "title": "Pengiriman Cepat\n& Aman",
      "subtitle":
          "Lacak pesanan Anda secara real-time\ndan nikmati metode pembayaran yang aman.",
      "image": "assets/svg/onboarding_2.svg",
    },
    {
      "title": "Penawaran Eksklusif\nSetiap Hari",
      "subtitle": "Dapatkan cashback, voucher, dan\ndiskon khusus setiap hari.",
      "image": "assets/svg/onboarding_3.svg",
    },
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      skip();
    }
  }

  Future<void> skip() async {
    try {
      final prefs = Get.find<AppSharedPrefs>();
      await prefs.write('seen_onboarding', 'true');
    } catch (_) {}
    Get.offAllNamed(Routes.LOGIN);
  }
}
