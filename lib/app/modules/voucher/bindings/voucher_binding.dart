import 'package:get/get.dart';
import 'package:pos_royal/app/data/datasources/voucher_remote_datasource.dart';
import 'package:pos_royal/app/data/repositories/voucher_repository_impl.dart';
import 'package:pos_royal/app/domain/repositories/voucher_repository.dart';
import 'package:pos_royal/app/domain/usecases/get_voucher_usecase.dart';

import '../controllers/voucher_controller.dart';

class VoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoucherRemoteDataSource>(
      () => VoucherRemoteDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<VoucherRepository>(
      () => VoucherRepositoryImpl(
        remoteDataSource: Get.find<VoucherRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<GetVoucherUsecase>(
      () => GetVoucherUsecase(Get.find<VoucherRepository>()),
      fenix: true,
    );
    Get.lazyPut<VoucherController>(
      () => VoucherController(
        getVoucherUsecase: Get.find<GetVoucherUsecase>(),
      ),
      fenix: true,
    );
  }
}
