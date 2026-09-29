import 'package:get/get.dart';

class SuccessController extends GetxController {
  var invoiceNumber = '';

  @override
  void onInit() {
    super.onInit();
    invoiceNumber = (Get.arguments != null && Get.arguments is String)
        ? (Get.arguments as String)
        : '-';
  }
}
