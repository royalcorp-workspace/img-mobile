import 'package:get/get.dart';
import 'package:img/app/data/datasources/voucher_remote_datasource.dart';
import 'package:img/app/data/repositories/voucher_repository_impl.dart';
import 'package:img/app/domain/repositories/voucher_repository.dart';
import 'package:img/app/domain/usecases/get_voucher_usecase.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/modules/detail_product/controllers/detail_product_controller.dart';
import 'package:img/app/modules/home/controllers/home_controller.dart';
import 'package:img/app/modules/navigation/controllers/navigation_controller.dart';
import 'package:img/app/modules/order/controllers/order_controller.dart';
import 'package:img/app/modules/product/controllers/product_controller.dart';
import 'package:img/app/modules/setting/controllers/setting_controller.dart';
import 'package:img/app/modules/splash/controllers/splash_controller.dart';
import 'package:img/app/modules/voucher/controllers/voucher_controller.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get
      ..lazyPut<SplashController>(
        () => SplashController(),
        fenix: true,
      )
      ..lazyPut<NavigationController>(
        () => NavigationController(),
        fenix: true,
      )
      ..lazyPut<HomeController>(
        () => HomeController(),
        fenix: true,
      )
      ..lazyPut<ProductController>(
        () => ProductController(),
        fenix: true,
      )
      ..lazyPut<DetailProductController>(
        () => DetailProductController(),
        fenix: true,
      )
      ..lazyPut<OrderController>(
        () => OrderController(),
        fenix: true,
      )
      ..lazyPut<SettingController>(
        () => SettingController(),
        fenix: true,
      )
      ..lazyPut<CartController>(
        () => CartController(),
        fenix: true,
      );

    Get.lazyPut<VoucherRemoteDataSource>(
      () => VoucherRemoteDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<VoucherRepository>(
      () => VoucherRepositoryImpl(
        remoteDataSource: Get.find<VoucherRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<GetVoucherUsecase>(
      () => GetVoucherUsecase(Get.find<VoucherRepository>()),
      fenix: true,
    );
    Get.lazyPut<VoucherController>(
      () => VoucherController(
        getVoucherUsecase: Get.find<GetVoucherUsecase>(),
      ),
      fenix: true,
    );
  }
}
