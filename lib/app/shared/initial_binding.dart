import 'package:get/get.dart';
import 'package:pos_royal/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:pos_royal/app/modules/home/controllers/home_controller.dart';
import 'package:pos_royal/app/modules/navigation/controllers/navigation_controller.dart';
import 'package:pos_royal/app/modules/order/controllers/order_controller.dart';
import 'package:pos_royal/app/modules/product/controllers/product_controller.dart';
import 'package:pos_royal/app/modules/setting/controllers/setting_controller.dart';
import 'package:pos_royal/app/modules/splash/controllers/splash_controller.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get
      ..lazyPut<SplashController>(
        () => SplashController(),
      )
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
