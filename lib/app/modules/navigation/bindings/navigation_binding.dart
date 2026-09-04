import 'package:get/get.dart';
import 'package:img/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:img/app/modules/home/controllers/home_controller.dart';
import 'package:img/app/modules/order/controllers/order_controller.dart';
import 'package:img/app/modules/product/controllers/product_controller.dart';
import 'package:img/app/modules/setting/controllers/setting_controller.dart';

import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<NavigationController>(
        () => NavigationController(),
      )
      ..lazyPut<HomeController>(
        () => HomeController(),
      )
      ..lazyPut<ProductController>(
        () => ProductController(),
      )
      ..lazyPut<OrderController>(
        () => OrderController(),
      )
      ..lazyPut<SettingController>(
        () => SettingController(),
      )
      ..lazyPut<CheckoutController>(
        () => CheckoutController(),
      );
  }
}
