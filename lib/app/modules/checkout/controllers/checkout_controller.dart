import 'package:get/get.dart';

class CheckoutController extends GetxController {
  RxString selectedShippingMethod = ''.obs;
  RxString selectedShipping = ''.obs;
  RxString selectedShippingImg = ''.obs;
  RxInt selectedPrice = 0.obs;
  RxInt selectedQty = 0.obs;

  @override
  void onInit() {
    selectedPrice.value = Get.arguments[0];
    selectedQty.value = Get.arguments[1];
    super.onInit();
  }
}
