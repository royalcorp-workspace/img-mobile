import 'package:get/get.dart';
import 'package:img/app/data/datasources/customer_remote_datasource.dart';
import 'package:img/app/data/repositories/customer_repository_impl.dart';
import 'package:img/app/domain/repositories/customer_repository.dart';
import 'package:img/app/domain/usecases/change_password_usecase.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerRemoteDataSource>(
      () => CustomerRemoteDataSourceImpl(),
    );
    Get.lazyPut<CustomerRepository>(
      () => CustomerRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut<ChangePasswordUsecase>(
      () => ChangePasswordUsecase(Get.find()),
    );
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(
        changePasswordUsecase: Get.find(),
      ),
    );
  }
}
