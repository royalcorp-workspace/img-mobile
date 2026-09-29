import 'package:get/get.dart';

class AddressController extends GetxController {
  List<String> options = ["Option 1", "Option 2"];

  RxString selectedOption = "Option 1".obs;
}
