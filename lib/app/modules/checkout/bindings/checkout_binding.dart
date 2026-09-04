import 'package:get/get.dart';
import 'package:img/app/data/datasources/order_remote_datasource.dart';
import 'package:img/app/data/datasources/payment_method_remote_datasource.dart';
import 'package:img/app/data/datasources/shipping_addresses_remote_datasource.dart';
import 'package:img/app/data/repositories/order_repository_impl.dart';
import 'package:img/app/data/repositories/payment_method_repository_impl.dart';
import 'package:img/app/data/repositories/shipping_addresses_repository_impl.dart';
import 'package:img/app/domain/repositories/shipping_addresses_repository.dart';
import 'package:img/app/domain/usecases/create_order_usecase.dart';
import 'package:img/app/domain/usecases/get_payment_methods_usecase.dart';
import 'package:img/app/domain/usecases/get_shipping_addresses_usecase.dart';
import 'package:img/app/modules/payment_method/controllers/payment_method_controller.dart';

import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
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
    Get.lazyPut<ShippingAddressesRemoteDatasource>(
        () => ShippingAddressesRemoteDatasourceImpl());
    Get.lazyPut<ShippingAddressesRepository>(
      () => ShippingAddressesRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut<GetShippingAddressesUsecase>(
      () => GetShippingAddressesUsecase(Get.find()),
      fenix: true,
    );
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(getShippingAddressesUsecase: Get.find()),
    );
  }
}
