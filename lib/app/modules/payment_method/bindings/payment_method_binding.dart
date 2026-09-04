import 'package:get/get.dart';
import 'package:img/app/data/datasources/order_remote_datasource.dart';
import 'package:img/app/data/datasources/payment_method_remote_datasource.dart';
import 'package:img/app/data/repositories/order_repository_impl.dart';
import 'package:img/app/data/repositories/payment_method_repository_impl.dart';
import 'package:img/app/domain/usecases/create_order_usecase.dart';
import 'package:img/app/domain/usecases/get_payment_methods_usecase.dart';

import '../controllers/payment_method_controller.dart';

class PaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl());
    Get.lazyPut<OrderRepositoryImpl>(
      () => OrderRepositoryImpl(
        remoteDataSource: Get.find<OrderRemoteDataSource>(),
      ),
    );
    Get.lazyPut<CreateOrderUseCase>(
      () => CreateOrderUseCase(Get.find<OrderRepositoryImpl>()),
    );

    Get.lazyPut<PaymentMethodRemoteDatasource>(
      () => PaymentMethodRemoteDatasourceImpl(),
    );
    Get.lazyPut<PaymentMethodRepositoryImpl>(
      () => PaymentMethodRepositoryImpl(
        remoteDataSource: Get.find<PaymentMethodRemoteDatasource>(),
      ),
    );
    Get.lazyPut<GetPaymentMethodsUsecase>(
      () => GetPaymentMethodsUsecase(Get.find<PaymentMethodRepositoryImpl>()),
    );

    Get.lazyPut<PaymentMethodController>(
      () => PaymentMethodController(
        getPaymentMethodsUsecase: Get.find<GetPaymentMethodsUsecase>(),
        createOrderUseCase: Get.find<CreateOrderUseCase>(),
      ),
    );
  }
}
