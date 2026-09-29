import 'package:get/get.dart';
import 'package:pos_royal/app/data/datasources/product_remote_datasource.dart';
import 'package:pos_royal/app/data/repositories/product_repository_impl.dart';
import 'package:pos_royal/app/domain/repositories/product_repository.dart';
import 'package:pos_royal/app/domain/usecases/get_products_usecase.dart';

import '../controllers/home_controller.dart';

import 'package:img/app/domain/usecases/get_product_tags_usecase.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl());
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut<GetProductsUseCase>(
      () => GetProductsUseCase(Get.find()),
    );
    Get.lazyPut<GetProductTagsUseCase>(
      () => GetProductTagsUseCase(Get.find()),
    );
    Get.put<CartController>(
      CartController(),
      permanent: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
        getProductsUseCase: Get.find(),
        getProductTagsUseCase: Get.find(),
      ),
    );
  }
}
