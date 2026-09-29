import 'package:get/get.dart';
import 'package:img/app/data/datasources/order_remote_datasource.dart';
import 'package:img/app/data/repositories/order_repository_impl.dart';
import 'package:img/app/domain/usecases/get_order_detail_usecase.dart';

import '../controllers/detail_order_controller.dart';

class DetailOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(),
    );
    Get.lazyPut<OrderRepositoryImpl>(
      () => OrderRepositoryImpl(
        remoteDataSource: Get.find<OrderRemoteDataSource>(),
      ),
    );
    Get.lazyPut<GetOrderDetailUsecase>(
      () => GetOrderDetailUsecase(
        Get.find<OrderRepositoryImpl>(),
      ),
    );
    Get.lazyPut<DetailOrderController>(
      () => DetailOrderController(
        getOrderDetailUsecase: Get.find<GetOrderDetailUsecase>(),
      ),
    );
  }
}
