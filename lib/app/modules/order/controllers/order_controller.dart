import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  RxInt selectedIndex = 0.obs;
}
