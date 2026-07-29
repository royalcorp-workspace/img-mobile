import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/data/datasources/order_remote_datasource.dart';
import 'package:pos_royal/app/data/datasources/payment_method_remote_datasource.dart';
import 'package:pos_royal/app/data/models/user_model.dart';
import 'package:pos_royal/app/data/repositories/order_repository_impl.dart';
import 'package:pos_royal/app/data/repositories/payment_method_repository_impl.dart';
import 'package:pos_royal/app/domain/entities/order_entity.dart';
import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';
import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';
import 'package:pos_royal/app/domain/usecases/create_order_usecase.dart';
import 'package:pos_royal/app/domain/usecases/get_payment_methods_usecase.dart';
import 'package:pos_royal/app/routes/app_pages.dart';

class PaymentMethodController extends GetxController {
  PaymentMethodController({
    this.getPaymentMethodsUsecase,
    this.createOrderUseCase,
  });

  final GetPaymentMethodsUsecase? getPaymentMethodsUsecase;
  final CreateOrderUseCase? createOrderUseCase;

  List<String> options = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
  ];

  RxString selectedOption = "".obs;
  RxString errMessage = "".obs;
  RxInt selectedPrice = 0.obs;
  RxInt selectedQty = 0.obs;
  int currentPage = 0;
  RxBool isLoading = false.obs;
  RxBool isCreatingOrder = false.obs;
  RxBool hasMore = false.obs;
  final int itemsPerPage = 10;
  var paymentMethod = <PaymentMethodEntity>[].obs;
  ProductByIdEntity? product;
  List<CreateOrderItemParams> customOrderItems = [];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is List) {
      final args = Get.arguments as List;
      if (args.isNotEmpty && args[0] != null) {
        selectedPrice.value = (args[0] as num).toInt();
      }
      if (args.length > 1 && args[1] != null) {
        selectedQty.value = (args[1] as num).toInt();
      }
      if (args.length > 2 && args[2] is ProductByIdEntity) {
        product = args[2] as ProductByIdEntity;
      }
      if (args.length > 3 && args[3] is List<CreateOrderItemParams>) {
        customOrderItems = args[3] as List<CreateOrderItemParams>;
      }
    }
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
      List<CreateOrderItemParams> payloadItems = [];

      if (customOrderItems.isNotEmpty) {
        payloadItems = customOrderItems;
      } else {
        final productId = product?.id ?? "1";
        final variantId = product?.variants?.isNotEmpty == true
            ? (product?.variants!.first.id ?? "1")
            : "1";
        final productName = product?.name ?? "Product Order";
        final itemUnitPrice = selectedPrice.value.toDouble();
        final itemQty = selectedQty.value > 0 ? selectedQty.value : 1;
        final itemTotal = itemUnitPrice * itemQty;

        payloadItems = [
          CreateOrderItemParams(
            productId: productId,
            productVariantId: variantId,
            quantity: itemQty,
            unitPrice: itemUnitPrice,
            discountNominal: 0,
            discountPercent: 0,
            total: itemTotal,
            weight: 0,
            name: productName,
          ),
        ];
      }

      final subtotal = payloadItems.fold(
          0.0, (previousValue, element) => previousValue + element.total);
      const adminFee = 2500.0;
      final total = subtotal + adminFee;

      final params = CreateOrderParams(
        customerId: customerId,
        status: 0,
        paymentMethod: chosenPaymentMethod,
        paymentStatus: 0,
        subtotal: subtotal,
        tax: 0,
        discount: 0,
        total: total,
        notes: "Order from mobile app",
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
          '✅ [PAYMENT_METHOD] Order created successfully! Order ID: ${orderResult.id}');

      Get.toNamed(Routes.PAYMENT, arguments: [
        orderResult,
        selectedPrice.value,
        selectedQty.value,
      ]);
    } catch (e, stackTrace) {
      logger.severe('❌ [PAYMENT_METHOD] Failed to create order: $e');
      if (kDebugMode) {
        print('❌ [PAYMENT_METHOD] Error creating order: $e');
        print(stackTrace);
      }
      Get.snackbar(
        'Gagal membuat pesanan',
        'Terjadi kesalahan saat memproses pesanan. Silakan coba lagi.',
        backgroundColor: Get.context?.theme.colorScheme.error ?? Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingOrder.value = false;
    }
  }
}
