import 'package:get/get.dart';
import 'package:img/app/data/datasources/category_remote_datasource.dart';
import 'package:img/app/data/datasources/product_remote_datasource.dart';
import 'package:img/app/data/repositories/category_repository_impl.dart';
import 'package:img/app/data/repositories/product_repository_impl.dart';
import 'package:img/app/domain/repositories/category_repository.dart';
import 'package:img/app/domain/repositories/product_repository.dart';
import 'package:img/app/domain/usecases/get_category_usecase.dart';
import 'package:img/app/domain/usecases/get_product_by_id_usecase.dart';
import 'package:img/app/domain/usecases/get_products_usecase.dart';

import '../controllers/category_product_controller.dart';

class CategoryProductBinding extends Bindings {
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
    if (!Get.isRegistered<CategoryRemoteDataSource>()) {
      Get.lazyPut<CategoryRemoteDataSource>(
          () => CategoryRemoteDataSourceImpl());
    }
    if (!Get.isRegistered<CategoryRepository>()) {
      Get.lazyPut<CategoryRepository>(
        () => CategoryRepositoryImpl(remoteDataSource: Get.find()),
      );
    }
    if (!Get.isRegistered<GetProductsUseCase>()) {
      Get.lazyPut<GetProductsUseCase>(
        () => GetProductsUseCase(Get.find()),
      );
    }
    if (!Get.isRegistered<GetCategoryUsecase>()) {
      Get.lazyPut<GetCategoryUsecase>(
        () => GetCategoryUsecase(Get.find()),
      );
    }
    if (!Get.isRegistered<GetProductByIdUsecase>()) {
      Get.lazyPut<GetProductByIdUsecase>(
        () => GetProductByIdUsecase(Get.find()),
      );
    }
    Get.lazyPut<CategoryProductController>(
      () => CategoryProductController(
        getProductsUseCase: Get.find(),
        getCategoryUsecase: Get.find(),
        getProductByIdUsecase: Get.find(),
      ),
    );
  }
}
