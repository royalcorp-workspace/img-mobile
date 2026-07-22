import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  List<String> options = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
  ];

  RxString selectedOption = "".obs;
  RxInt selectedPrice = 0.obs;
  RxInt selectedQty = 0.obs;

  @override
  void onInit() {
    selectedPrice.value = Get.arguments[0];
    selectedQty.value = Get.arguments[1];
    super.onInit();
  }
}
