import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/shared/widgets/button/primary_button.dart';
import '../../../core/styles/app_color.dart';
import '../../../core/styles/app_text_style.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header (Skip button)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: controller.skip,
                    child: Text(
                      "Lewati",
                      style: AppTextStyle.mediumBlack,
                    ),
                  ),
                ],
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildPage(
                    title: controller.onboardingData[index]['title']!,
                    subtitle: controller.onboardingData[index]['subtitle']!,
                    index: index,
                  );
                },
              ),
            ),
            // Dots Indicator
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.onboardingData.length,
                  (index) => _buildDot(index),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            // Bottom Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: Obx(() {
                  bool isLast = controller.currentIndex.value ==
                      controller.onboardingData.length - 1;
                  return ButtonPrimary(
                    fullWidth: true,
                    text: isLast ? "Mulai Sekarang" : "Lanjut",
                    onPressed: controller.nextPage,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
      {required String title, required String subtitle, required int index}) {
    String imagePath;
    if (index == 0) {
      imagePath = "img_onboarding_1.png";
    } else if (index == 1) {
      imagePath = "img_onboarding_2.png";
    } else {
      imagePath = "img_onboarding_3.png";
    }

    final parts = title.split('\n');
    final firstLine = parts.isNotEmpty ? parts[0] : '';
    final secondLine = parts.length > 1 ? parts.sublist(1).join('\n') : '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyle.xxxLargeBlackBold.copyWith(
                color: AppColors.textDark,
                height: 1.2,
              ),
              children: [
                TextSpan(text: firstLine),
                if (secondLine.isNotEmpty) ...[
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: secondLine,
                    style: AppTextStyle.xxxLargeBlackBold.copyWith(
                      color: AppColors.brownAccent,
                      height: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 10.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.mediumBlack.copyWith(
              color: AppColors.textMedium,
              height: 1.5,
            ),
          ),
          SizedBox(height: 30.h),

          // Placeholder for illustration
          ClipRRect(
            borderRadius: BorderRadius.circular(32.0), // Adjust the roundness
            child: Image.asset(Helper.getImagePath(imagePath), height: 250.h)
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5.w),
      height: 8.h,
      width: controller.currentIndex.value == index ? 24.w : 8.w,
      decoration: BoxDecoration(
        color: controller.currentIndex.value == index
            ? AppColors.mainGold
            : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
