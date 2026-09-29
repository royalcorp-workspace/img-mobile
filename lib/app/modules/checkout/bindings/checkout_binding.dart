import 'package:get/get.dart';
import 'package:img/app/data/datasources/shipping_addresses_remote_datasource.dart';
import 'package:img/app/data/repositories/shipping_addresses_repository_impl.dart';
import 'package:img/app/domain/repositories/shipping_addresses_repository.dart';
import 'package:img/app/domain/usecases/get_shipping_addresses_usecase.dart';

import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShippingAddressesRemoteDatasource>(
        () => ShippingAddressesRemoteDatasourceImpl());
    Get.lazyPut<ShippingAddressesRepository>(
      () => ShippingAddressesRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut<GetShippingAddressesUsecase>(
      () => GetShippingAddressesUsecase(Get.find()),
    );
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(getShippingAddressesUsecase: Get.find()),
    );
  }
}
