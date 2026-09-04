import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/payment_method_remote_datasource.dart';
import 'package:img/app/data/repositories/payment_method_repository_impl.dart';
import 'package:img/app/domain/entities/payment_method_entity.dart';
import 'package:img/app/domain/usecases/create_order_usecase.dart';
import 'package:img/app/domain/usecases/get_payment_methods_usecase.dart';

class PaymentMethodController extends GetxController {
  PaymentMethodController({
    this.getPaymentMethodsUsecase,
    this.createOrderUseCase,
  });

  final GetPaymentMethodsUsecase? getPaymentMethodsUsecase;
  final CreateOrderUseCase? createOrderUseCase;

  RxString selectedOption = "".obs;
  RxString errMessage = "".obs;
  int currentPage = 0;
  RxBool isLoading = false.obs;
  RxBool hasMore = false.obs;
  final int itemsPerPage = 10;
  var paymentMethod = <PaymentMethodEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethod();
  }

  Future<void> fetchPaymentMethod() async {
    try {
      isLoading.value = true;
      errMessage.value = '';
      currentPage = 1;
      hasMore.value = true;

      final useCase = getPaymentMethodsUsecase ??
          GetPaymentMethodsUsecase(
            PaymentMethodRepositoryImpl(
              remoteDataSource: PaymentMethodRemoteDatasourceImpl(),
            ),
          );

      final result =
          await useCase.call(page: currentPage, itemsPerPage: itemsPerPage);
      paymentMethod.assignAll(result.data);
      hasMore.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [PAYMENT_METHOD] Failed to fetch payment methods: $e');
      if (kDebugMode) {
        print('❌ [PAYMENT_METHOD] Error: $e');
        print(stackTrace);
      }
      errMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
