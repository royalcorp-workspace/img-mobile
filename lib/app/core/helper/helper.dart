import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_royal/app/core/utils/constants/app_constant.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';

class Helper {
  /// Get svg picture path
  static String getSvgPath(String name) {
    return "$svgPath$name";
  }

  /// Get image picture path
  static String getImagePath(String name) {
    return "$imagePath$name";
  }

  /// Get gif picture path
  static String getGifPath(String name) {
    return "$gifPath$name";
  }

  /// Get vertical space
  static double getVerticalSpace() {
    return 10.h;
  }

  /// Get horizontal space
  static double getHorizontalSpace() {
    return 10.w;
  }

  /// Get screen size
  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  /// Get screen width
  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  /// Get screen width
  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  /// Get Dio Header
  static Map<String, dynamic> getHeaders() {
    final Map<String, dynamic> headers = {};
    if (TokenStorage.serverToken != null) {
      headers['Authorization'] = 'Bearer ${TokenStorage.serverToken}';
    }
    return headers..removeWhere((key, value) => value == null);
  }

  /// Format Price
  static String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
