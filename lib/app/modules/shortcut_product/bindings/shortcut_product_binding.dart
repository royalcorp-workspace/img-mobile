import 'package:get/get.dart';
import 'package:img/app/data/datasources/product_remote_datasource.dart';
import 'package:img/app/data/repositories/product_repository_impl.dart';
import 'package:img/app/domain/repositories/product_repository.dart';
import 'package:img/app/domain/usecases/get_product_by_id_usecase.dart';
import 'package:img/app/domain/usecases/get_products_usecase.dart';

import '../controllers/shortcut_product_controller.dart';

class ShortcutProductBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProductRemoteDataSource>()) {
      Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl());
    }
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(remoteDataSource: Get.find()),
      );
    }
    if (!Get.isRegistered<GetProductsUseCase>()) {
      Get.lazyPut<GetProductsUseCase>(
        () => GetProductsUseCase(Get.find()),
      );
    }
    if (!Get.isRegistered<GetProductByIdUsecase>()) {
      Get.lazyPut<GetProductByIdUsecase>(
        () => GetProductByIdUsecase(Get.find()),
      );
    }
    Get.lazyPut<ShortcutProductController>(
      () => ShortcutProductController(
        getProductsUseCase: Get.find(),
        getProductByIdUsecase: Get.find(),
      ),
    );
  }
}
