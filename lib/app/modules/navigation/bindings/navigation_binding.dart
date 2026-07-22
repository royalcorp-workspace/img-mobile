import 'package:get/get.dart';
import 'package:pos_royal/app/modules/home/controllers/home_controller.dart';
import 'package:pos_royal/app/modules/order/controllers/order_controller.dart';
import 'package:pos_royal/app/modules/product/controllers/product_controller.dart';
import 'package:pos_royal/app/modules/setting/controllers/setting_controller.dart';

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
      );
  }
}
