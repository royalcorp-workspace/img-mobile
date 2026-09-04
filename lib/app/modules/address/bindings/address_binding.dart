import 'package:get/get.dart';
import 'package:img/app/data/datasources/customer_remote_datasource.dart';
import 'package:img/app/data/repositories/customer_repository_impl.dart';
import 'package:img/app/domain/usecases/get_customer_usecase.dart';

import '../controllers/address_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(
      () => AddressController(
        getCustomerUsecase: GetCustomerUsecase(
          CustomerRepositoryImpl(
            remoteDataSource: CustomerRemoteDataSourceImpl(),
          ),
        ),
      ),
    );
  }
}
