import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/data/datasources/checkout_remote_datasource.dart';
import 'package:pos_royal/app/data/datasources/order_remote_datasource.dart';
import 'package:pos_royal/app/data/datasources/payment_method_remote_datasource.dart';
import 'package:pos_royal/app/data/datasources/shipping_addresses_remote_datasource.dart';
import 'package:pos_royal/app/data/models/checkout_params_model.dart';
import 'package:pos_royal/app/data/models/user_model.dart';
import 'package:pos_royal/app/data/repositories/checkout_repository_impl.dart';
import 'package:pos_royal/app/data/repositories/order_repository_impl.dart';
import 'package:pos_royal/app/data/repositories/payment_method_repository_impl.dart';
import 'package:pos_royal/app/data/repositories/shipping_addresses_repository_impl.dart';
import 'package:pos_royal/app/domain/entities/add_to_cart_entity.dart';
import 'package:pos_royal/app/domain/entities/order_entity.dart';

import 'package:pos_royal/app/domain/entities/payment_method_entity.dart';
import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';
import 'package:pos_royal/app/domain/entities/voucher_entity.dart';
import 'package:pos_royal/app/domain/usecases/checkout_usecase.dart';
import 'package:pos_royal/app/domain/usecases/create_order_usecase.dart';
import 'package:pos_royal/app/domain/usecases/get_payment_methods_usecase.dart';
import 'package:pos_royal/app/domain/usecases/get_shipping_addresses_usecase.dart';
import 'package:pos_royal/app/modules/checkout/models/checkout_arguments.dart';
import 'package:pos_royal/app/routes/app_pages.dart';

class CheckoutController extends GetxController {
  CheckoutController({
    this.getShippingAddressesUsecase,
    this.getPaymentMethodsUsecase,
    this.createOrderUseCase,
    this.checkoutUsecase,
  });

  final GetShippingAddressesUsecase? getShippingAddressesUsecase;
  final GetPaymentMethodsUsecase? getPaymentMethodsUsecase;
  final CreateOrderUseCase? createOrderUseCase;
  final CheckoutUsecase? checkoutUsecase;

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
  CheckoutSource? checkoutSource;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is CheckoutArguments) {
      _handleCheckoutArguments(args);
    } else if (args is List && args.isNotEmpty) {
      logger.warning(
        '⚠️ [CHECKOUT] Legacy positional arguments detected; use CheckoutArguments instead.',
      );

      if (args.first is ProductByIdEntity) {
        final product = args.first as ProductByIdEntity;
        final variantIndex = args.length > 1
            ? (args[1] is num ? (args[1] as num).toInt() : 0)
            : 0;
        _handleProductCheckout(
          CheckoutArguments(
            source: CheckoutSource.product,
            product: product,
            selectedVariantIndex: variantIndex,
          ),
        );
      } else if (args.first is List<ItemCart>) {
        _handleCartCheckout(
          CheckoutArguments(
            source: CheckoutSource.cart,
            cartItems: args.first as List<ItemCart>,
          ),
        );
      } else {
        logger.warning('⚠️ [CHECKOUT] Invalid legacy checkout arguments');
      }
    } else {
      logger.warning('⚠️ [CHECKOUT] No arguments received');
    }

    fetchShippingAddresses();
    fetchPaymentMethod();
  }

  void _handleCheckoutArguments(CheckoutArguments args) {
    checkoutSource = args.source;

    switch (args.source) {
      case CheckoutSource.cart:
        _handleCartCheckout(args);
        break;
      case CheckoutSource.product:
        _handleProductCheckout(args);
        break;
    }
  }

  void _handleCartCheckout(CheckoutArguments args) {
    itemParams.clear();

    final items = args.cartItems ?? [];
    if (items.isEmpty) {
      logger.warning('⚠️ [CHECKOUT] Cart checkout has no selected items');
      return;
    }

    itemParams = items.map((item) {
      final productId = item.productId ?? '';
      final variantId = item.productVariantId ?? item.product?.id ?? '1';
      final quantity = item.quantity;
      final unitPrice = item.unitPrice;
      final discountNominal = item.discountNominal;
      final discountPercent = item.discountPercent;
      final total = item.total;
      final variant = item.variant;

      return ItemParams(
        productId: productId,
        productVariantId: variantId,
        quantity: quantity,
        unitPrice: unitPrice,
        discountNominal: discountNominal,
        discountPercent: discountPercent,
        total: total,
        weight: 0,
        name: item.name ?? item.product?.name ?? '',
        variant: variant,
      );
    }).toList();

    logger.info(
      '🛒 [CHECKOUT] Cart checkout with ${itemParams.length} items',
    );
  }

  void _handleProductCheckout(CheckoutArguments args) {
    final productValue = args.product;

    if (productValue == null) {
      logger.warning('⚠️ [CHECKOUT] Product is missing');
      return;
    }

    productByID.value = productValue;

    final targetIndex = args.selectedVariantIndex ?? 0;

    if (productValue.variants == null || productValue.variants!.isEmpty) {
      selectedIndex.value = 0;
      logger.warning('⚠️ [CHECKOUT] Product has no available variants');
      return;
    }

    final safeIndex =
        targetIndex >= 0 && targetIndex < productValue.variants!.length
            ? targetIndex
            : 0;

    selectedIndex.value = safeIndex;

    final selectedVariant = productValue.variants![safeIndex];

    itemParams.clear();

    final itemQty = selectedQty.value > 0 ? selectedQty.value : 1;
    final itemUnitPrice = selectedVariant.finalPrice.toDouble();

    itemParams.add(
      ItemParams(
        productId: productValue.id ?? '',
        productVariantId: selectedVariant.id,
        quantity: itemQty,
        unitPrice: itemUnitPrice,
        discountNominal: 0,
        discountPercent: 0,
        total: itemUnitPrice * itemQty,
        weight: selectedVariant.weight.toDouble(),
        name: productValue.name ?? '',
        variant: selectedVariant,
      ),
    );

    logger.info(
      '🛍️ [CHECKOUT] Product detail checkout '
      'product=${productValue.id}, '
      'variant=${selectedVariant.id}, '
      'variantName=${selectedVariant.variantName}',
    );
  }

  double get checkoutTotal {
    if (checkoutSource == CheckoutSource.cart) {
      return itemParams.fold<double>(
        0,
        (sum, item) => sum + item.total,
      );
    }

    if (checkoutSource == CheckoutSource.product) {
      final variants = productByID.value.variants;

      if (variants == null || variants.isEmpty) {
        return 0;
      }

      final index = selectedIndex.value;

      if (index < 0 || index >= variants.length) {
        return 0;
      }

      return variants[index].finalPrice.toDouble() * selectedQty.value;
    }

    return 0;
  }

  double get shippingCost => selectedShippingPrice.value.toDouble();

  double get voucherDiscount => selectedVoucher.value?.value.toDouble() ?? 0;

  double get serviceFee => 0;

  double get totalBill {
    final result = checkoutTotal + shippingCost - voucherDiscount + serviceFee;

    return result < 0 ? 0 : result;
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

  double calculateSubtotal(List<ItemParams> items) {
    return items.fold(0.0, (sum, item) => sum + item.total);
  }

  Future<void> createOrder() async {
    if (isCreatingOrder.value) return;

    try {
      isCreatingOrder.value = true;
      logger.info('🔍 [CREATE-ORDER] Initiating order creation...');

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

      final List<ItemParams> payloadItems;

      if (checkoutSource == CheckoutSource.cart) {
        payloadItems = itemParams;
      } else {
        final productId = productByID.value.id?.toString() ?? '';
        if (productByID.value.id == null || productByID.value.id!.isEmpty) {
          logger.warning(
              '⚠️ [CREATE-ORDER] Missing product ID for product checkout');
          return;
        }

        if (productByID.value.variants == null ||
            productByID.value.variants!.isEmpty) {
          logger
              .warning('⚠️ [CREATE-ORDER] Product has no variants to checkout');
          return;
        }

        final variantIndex = selectedIndex.value >= 0 &&
                selectedIndex.value < productByID.value.variants!.length
            ? selectedIndex.value
            : 0;
        final selectedVariant = productByID.value.variants![variantIndex];
        final itemQty = selectedQty.value > 0 ? selectedQty.value : 1;
        final itemUnitPrice = selectedVariant.finalPrice.toDouble();
        final discountNominal =
            selectedVoucher.value != null ? selectedVoucher.value!.value : 0.0;
        final itemTotal = itemUnitPrice * itemQty;

        final productName = productByID.value.name.toString();

        payloadItems = [
          ItemParams(
            productId: productId,
            productVariantId: selectedVariant.id,
            quantity: itemQty,
            unitPrice: itemUnitPrice,
            discountNominal: discountNominal,
            discountPercent: 0,
            total: itemTotal,
            weight: selectedVariant.weight.toDouble(),
            name: productName,
            variant: selectedVariant,
          ),
        ];
      }

      if (payloadItems.isEmpty) {
        logger.warning('⚠️ [CREATE-ORDER] No create order items were prepared');
        return;
      }

      final subtotal = checkoutTotal;
      final shipping = shippingCost;
      final discount = voucherDiscount;
      final serviceFee = 0.0;

      final total = subtotal + shipping - discount + serviceFee;

      final params = CreateOrderParams(
        customerId: customerId,
        status: 0,
        paymentMethod: chosenPaymentMethod,
        paymentStatus: 0,
        subtotal: subtotal,
        tax: 0,
        discount: discount,
        total: total < 0 ? 0 : total,
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
          '✅ [ORDER] Order created successfully! Order ID: ${orderResult.id}');

      await checkout(orderResult.id, orderResult.paymentMethod);
    } catch (e, stackTrace) {
      isCreatingOrder.value = false;
      logger.severe('❌ [CREATE-ORDER] Failed to create order: $e');
      if (kDebugMode) {
        print('❌ [CREATE-ORDER] Error creating order: $e');
        print(stackTrace);
      }
      Get.snackbar(
        'Gagal membuat pesanan',
        'Terjadi kesalahan saat memproses pesanan. Silakan coba lagi.',
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
    }
  }

  Future<void> checkout(String orderID, String paymentMethodCode) async {
    try {
      logger.info('🔍 [CHECKOUT] Initiating checkout creation...');

      final params = CheckoutParamsModel(
        orderId: orderID,
        paymentMethodCode: paymentMethodCode,
      );

      final useCase = checkoutUsecase ??
          CheckoutUsecase(
            CheckoutRepositoryImpl(
              remoteDataSource: CheckoutRemoteDataSourceImpl(),
            ),
          );

      final checkoutResult = await useCase.call(params);
      logger.info(
          '✅ [CHECKOUT] Checkout created successfully! Checkout status: ${checkoutResult.success}');
      isCreatingOrder.value = false;

      Get.offAllNamed(
        Routes.PAYMENT,
        arguments: [checkoutResult, orderID],
      );
    } catch (e, stackTrace) {
      isCreatingOrder.value = false;
      logger.severe('❌ [CHECKOUT] Failed to checkout: $e');
      if (kDebugMode) {
        print('❌ [CHECKOUT] Error checkout: $e');
        print(stackTrace);
      }
      Get.snackbar(
        'Gagal membayar tagihan',
        'Terjadi kesalahan saat menyiapkan proses pembayaran. Silakan coba lagi.',
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isCreatingOrder.value = false;
    }
  }
}
