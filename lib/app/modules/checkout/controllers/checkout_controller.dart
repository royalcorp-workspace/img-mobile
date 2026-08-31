import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/data/datasources/order_remote_datasource.dart';
import 'package:pos_royal/app/data/datasources/payment_method_remote_datasource.dart';
import 'package:pos_royal/app/data/datasources/shipping_addresses_remote_datasource.dart';
import 'package:pos_royal/app/data/models/user_model.dart';
import 'package:pos_royal/app/data/repositories/order_repository_impl.dart';
import 'package:pos_royal/app/data/repositories/payment_method_repository_impl.dart';
import 'package:pos_royal/app/data/repositories/shipping_addresses_repository_impl.dart';
import 'package:pos_royal/app/domain/entities/order_entity.dart';

import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';
import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';
import 'package:pos_royal/app/domain/entities/voucher_entity.dart';
import 'package:pos_royal/app/domain/usecases/create_order_usecase.dart';
import 'package:pos_royal/app/domain/usecases/get_payment_methods_usecase.dart';
import 'package:pos_royal/app/domain/usecases/get_shipping_addresses_usecase.dart';
import 'package:pos_royal/app/routes/app_pages.dart';

class CheckoutController extends GetxController {
  CheckoutController({
    this.getShippingAddressesUsecase,
    this.getPaymentMethodsUsecase,
    this.createOrderUseCase,
  });

  final GetShippingAddressesUsecase? getShippingAddressesUsecase;
  final GetPaymentMethodsUsecase? getPaymentMethodsUsecase;
  final CreateOrderUseCase? createOrderUseCase;

  RxString selectedShippingMethod = ''.obs;
  RxString selectedShipping = ''.obs;
  RxString selectedShippingImg = ''.obs;
  RxString shippingErrorMessage = ''.obs;
  RxString errMessage = "".obs;
  RxString selectedOption = "".obs;
  RxInt selectedQty = 1.obs;
  RxInt selectedIndex = 0.obs;
  RxInt selectedShippingPrice = 0.obs;
  RxBool isCreatingOrder = false.obs;
  ProductByIdEntity? product;
  List<ItemParams> itemParams = [];
  TextEditingController notesC = TextEditingController();

  var selectedVoucher = Rxn<VoucherEntity>();
  final int itemsPerPage = 10;
  var currentPage = 0;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var total = 0.obs;
  var paymentMethod = [].obs;
  var productByID = ProductByIdEntity().obs;
  var shippingAddresses = [].obs;

  @override
  void onInit() {
    // selectedPrice.value = Get.arguments[0];
    // selectedQty.value = Get.arguments[1];
    productByID.value = Get.arguments[0];
    selectedIndex.value = Get.arguments[1];
    fetchShippingAddresses();
    fetchPaymentMethod();

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
      if (selectedOption.value.isNotEmpty) {
        setSelectedPaymentMethodFromPage(selectedOption.value);
      }
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

  void setSelectedPaymentMethodFromPage(dynamic selected) {
    if (selected == null) return;

    String codeToSelect = '';
    if (selected is PaymentMethodEntity) {
      codeToSelect = selected.code ?? selected.name ?? '';
    } else if (selected is String) {
      codeToSelect = selected;
    }

    if (codeToSelect.isEmpty) return;

    selectedOption.value = codeToSelect;

    final targetIndex = paymentMethod.indexWhere((item) {
      if (item is PaymentMethodEntity) {
        return item.code == codeToSelect || item.name == codeToSelect;
      } else if (item is Map) {
        return item['code'] == codeToSelect || item['name'] == codeToSelect;
      }
      return false;
    });

    if (targetIndex > 0) {
      final item = paymentMethod.removeAt(targetIndex);
      paymentMethod.insert(0, item);
      paymentMethod.refresh();
    } else if (targetIndex == -1 && selected is PaymentMethodEntity) {
      paymentMethod.insert(0, selected);
      paymentMethod.refresh();
    }
  }

  Future<String> _getOrFetchCustomerId() async {
    try {
      final userDataStr = await TokenStorage.getUserData();
      if (userDataStr != null && userDataStr.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userDataStr);
        final userModel = UserModel.fromJson(userMap);
        if (userModel.customer?.id != null &&
            userModel.customer!.id!.isNotEmpty) {
          return userModel.customer!.id!;
        }
        if (userModel.id != null && userModel.id!.isNotEmpty) {
          return userModel.id!;
        }
      }
    } catch (e) {
      logger.warning(
          '⚠️ [PAYMENT_METHOD] Could not parse stored user customer ID: $e');
    }
    return "3fa85f64-5717-4562-b3fc-2c963f66afa6";
  }

  Future<void> createOrder() async {
    if (isCreatingOrder.value) return;

    try {
      isCreatingOrder.value = true;
      logger.info('🔍 [PAYMENT_METHOD] Initiating order creation...');

      final customerId = await _getOrFetchCustomerId();
      String chosenPaymentMethod = "credit_card";

      if (selectedOption.value.isNotEmpty) {
        final optIndex = int.tryParse(selectedOption.value);
        if (optIndex != null && optIndex < paymentMethod.length) {
          chosenPaymentMethod =
              paymentMethod[optIndex].code ?? paymentMethod[optIndex].name;
        } else {
          chosenPaymentMethod = selectedOption.value;
        }
      } else if (paymentMethod.isNotEmpty) {
        chosenPaymentMethod =
            paymentMethod.first.code ?? paymentMethod.first.name;
      }

      // Support multi-item orders (e.g. from Cart) or single-item fallback
      List<ItemParams> payloadItems = [];

      if (itemParams.isNotEmpty) {
        payloadItems = itemParams;
      } else {
        final productId = productByID.value.id.toString();
        final variantId = productByID.value.variants?.isNotEmpty == true
            ? (productByID.value.variants!.first.id)
            : "1";
        final itemQty = selectedQty.value > 0 ? selectedQty.value : 1;
        final itemUnitPrice =
            productByID.value.variants![selectedIndex.value].finalPrice;
        final discountNominal =
            selectedVoucher.value != null ? selectedVoucher.value!.value : 0.0;
        final shippingPrice = selectedShippingPrice.value;
        final itemTotal = itemUnitPrice + shippingPrice - discountNominal;
        final productName = productByID.value.name.toString();

        payloadItems = [
          ItemParams(
            productId: productId,
            productVariantId: variantId,
            quantity: itemQty,
            unitPrice: itemUnitPrice,
            discountNominal: discountNominal,
            discountPercent: 0,
            total: itemTotal,
            weight: 0,
            name: productName,
          ),
        ];
      }

      final subtotal = payloadItems.fold(
          0.0, (previousValue, element) => previousValue + element.total);
      // const adminFee = 2500.0;
      // final total = subtotal + adminFee;
      final total = subtotal;

      final params = CreateOrderParams(
        customerId: customerId,
        status: 0,
        paymentMethod: chosenPaymentMethod,
        paymentStatus: 0,
        subtotal: subtotal,
        tax: 0,
        discount: 0,
        total: total,
        notes: notesC.text,
        meta: {},
        items: payloadItems,
      );

      final useCase = createOrderUseCase ??
          CreateOrderUseCase(
            OrderRepositoryImpl(
              remoteDataSource: OrderRemoteDataSourceImpl(),
            ),
          );

      final orderResult = await useCase.call(params);
      logger.info(
          '✅ [CHECKOUT] Order created successfully! Order ID: ${orderResult.id}');

      Get.toNamed(Routes.PAYMENT, arguments: [
        orderResult,
        total,
        selectedQty.value,
      ]);
    } catch (e, stackTrace) {
      logger.severe('❌ [CHECKOUT] Failed to create order: $e');
      if (kDebugMode) {
        print('❌ [CHECKOUT] Error creating order: $e');
        print(stackTrace);
      }
      Get.snackbar(
        'Gagal membuat pesanan',
        'Terjadi kesalahan saat memproses pesanan. Silakan coba lagi.',
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isCreatingOrder.value = false;
    }
  }
}
