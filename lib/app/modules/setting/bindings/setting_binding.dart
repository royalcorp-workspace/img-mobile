import 'package:get/get.dart';
import 'package:img/app/data/datasources/customer_remote_datasource.dart';
import 'package:img/app/data/repositories/customer_repository_impl.dart';
import 'package:img/app/domain/repositories/customer_repository.dart';
import 'package:img/app/domain/usecases/get_customer_profile_usecase.dart';

import '../controllers/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerRemoteDataSource>(
      () => CustomerRemoteDataSourceImpl(),
    );
    Get.lazyPut<CustomerRepository>(
      () => CustomerRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut<GetCustomerProfileUsecase>(
      () => GetCustomerProfileUsecase(Get.find()),
    );
    Get.lazyPut<SettingController>(
      () => SettingController(
        getCustomerProfileUsecase: Get.find(),
      ),
    );
  }
}
