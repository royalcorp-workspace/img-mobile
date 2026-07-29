import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/datasources/shipping_addresses_remote_datasource.dart';
import 'package:pos_royal/app/data/repositories/shipping_addresses_repository_impl.dart';

import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';
import 'package:pos_royal/app/domain/entities/shipping_addresses_entity.dart';
import 'package:pos_royal/app/domain/usecases/get_shipping_addresses_usecase.dart';

class CheckoutController extends GetxController {
  CheckoutController({this.getShippingAddressesUsecase});

  RxString selectedShippingMethod = ''.obs;
  RxString selectedShipping = ''.obs;
  RxString selectedShippingImg = ''.obs;
  RxString shippingErrorMessage = ''.obs;
  RxInt selectedQty = 1.obs;
  RxInt selectedIndex = 0.obs;
  RxInt selectedShippingPrice = 0.obs;
  final int itemsPerPage = 10;
  var currentPage = 0;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;

  var productByID = ProductByIdEntity().obs;
  var shippingAddresses = <ShippingAddressesEntity>[].obs;
  final GetShippingAddressesUsecase? getShippingAddressesUsecase;

  @override
  void onInit() {
    // selectedPrice.value = Get.arguments[0];
    // selectedQty.value = Get.arguments[1];
    productByID.value = Get.arguments[0];
    selectedIndex.value = Get.arguments[1];
    fetchShippingAddresses();
    super.onInit();
  }

  void incrementQty() {
    selectedQty.value++;
  }

  void decrementQty() {
    if (selectedQty.value == 0) {
      selectedQty.value;
    } else {
      selectedQty.value--;
    }
  }

  Future<void> fetchShippingAddresses() async {
    try {
      isLoading.value = true;
      shippingErrorMessage.value = '';
      currentPage = 1;
      hasMore.value = true;

      final useCase = getShippingAddressesUsecase ??
          GetShippingAddressesUsecase(
            ShippingAddressesRepositoryImpl(
              remoteDataSource: ShippingAddressesRemoteDatasourceImpl(),
            ),
          );

      final result =
          await useCase.call(page: currentPage, itemsPerPage: itemsPerPage);
      shippingAddresses.assignAll(result.data);
      hasMore.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [CHECKOUT] Failed to fetch shipping: $e');
      if (kDebugMode) {
        print('❌ [CHECKOUT] Error: $e');
        print(stackTrace);
      }
      shippingErrorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
