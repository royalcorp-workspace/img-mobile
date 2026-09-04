import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/routes/app_pages.dart';

import '../controllers/success_controller.dart';

class SuccessView extends GetView<SuccessController> {
  const SuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RPadding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 3),
              Image.asset(
                Helper.getImagePath('img_success.png'),
              ),
              50.verticalSpace,
              Text(
                'Terima Kasih',
                style: AppTextStyle.xxxLargeBlackBold,
              ),
              15.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Pesanan kamu akan dikirimkan dengan invoice ',
                    style: AppTextStyle.mediumGrey,
                    children: [
                      TextSpan(
                        text: '#9ds69hs',
                        style: AppTextStyle.mediumBlackBold.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            '. Kamu dapat melacak pengiriman di bagian riwayat pesanan',
                        style: AppTextStyle.mediumGrey,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 3),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.primaryColor,
                    ),
                  ),
                  onPressed: () => Get.offAllNamed(Routes.NAVIGATION),
                  child: Text(
                    'Lanjut Belanja',
                    style: AppTextStyle.mediumWhiteBold,
                  ),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
