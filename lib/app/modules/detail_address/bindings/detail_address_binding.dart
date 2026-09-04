import 'package:get/get.dart';
import 'package:img/app/data/datasources/customer_remote_datasource.dart';
import 'package:img/app/data/repositories/customer_repository_impl.dart';
import 'package:img/app/domain/usecases/add_address_usecase.dart';

import '../controllers/detail_address_controller.dart';

class DetailAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAddressController>(
      () => DetailAddressController(
        addAddressUsecase: AddAddressUsecase(
          CustomerRepositoryImpl(
            remoteDataSource: CustomerRemoteDataSourceImpl(),
          ),
        ),
      ),
    );
  }
}
