import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:img/app/core/helper/helper.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              Helper.getImagePath('img_bg_auth_gold.png'),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image.asset(
              height: 200.h,
              width: 200.w,
              Helper.getImagePath('img_logo.webp'),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 80,
              child: Lottie.asset(
                height: 50.h,
                width: 50.w,
                Helper.getGifPath('gif_loading_animation.json'),
                fit: BoxFit.contain,
              ))
        ],
      ),
    );
  }
}
