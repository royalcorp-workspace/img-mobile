import 'dart:convert';
import 'dart:developer';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/core/utils/token_storage.dart';
import 'package:img/app/data/datasources/cart_remote_datasource.dart';
import 'package:img/app/data/models/user_model.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/data/repositories/cart_repository_impl.dart';
import 'package:img/app/domain/entities/add_to_cart_entity.dart';
import 'package:img/app/domain/entities/order_entity.dart';
import 'package:img/app/domain/entities/product_by_id_entity.dart';
import 'package:img/app/domain/usecases/add_to_cart_usecase.dart';
import 'package:img/app/domain/usecases/get_cart_usecase.dart';

class DetailProductController extends GetxController {
  DetailProductController({this.addToCartUsecase, this.getCartUsecase});

  final AddToCartUsecase? addToCartUsecase;
  final GetCartUsecase? getCartUsecase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final GlobalKey widgetKey = GlobalKey();

  late Function(GlobalKey) runAddToCartAnimation;
  var cartQuantityItems = 0.obs;
  RxInt selectedIndex = 0.obs;

  var isLoadingCarts = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 10;
  var productByID = ProductByIdEntity().obs;
  var cartErrorMessage = ''.obs;

  CartController get cartController {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController(), fenix: true);
    }
    return Get.find<CartController>();
  }

  List get carts => cartController.carts;

  @override
  void onInit() {
    super.onInit();
    productByID(Get.arguments[0]);
    if (cartController.carts.isEmpty) {
      refreshCart();
    }
    log('HERE ${productByID.value.description}');
  }

  Future<void> refreshCart() async {
    try {
      isLoadingCarts.value = true;
      cartErrorMessage.value = '';
      currentPage = 1;
      hasMore.value = true;
      await cartController.fetchCart();
      hasMore.value = cartController.hasMore.value;
    } catch (e, stackTrace) {
      logger.severe('❌ [HOME] Failed to fetch carts: $e');
      if (kDebugMode) {
        print('❌ [HOME] Error: $e');
        print(stackTrace);
      }
      cartErrorMessage.value = e.toString();
    } finally {
      isLoadingCarts.value = false;
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

  Future<void> addToCart(GlobalKey widgetKey) async {
    try {
      logger.info('🔍 [ADD_TO_CART] Initiating add to cart creation...');
      final customerId = await _getOrFetchCustomerId();

      // Support multi-item orders (e.g. from Cart) or single-item fallback
      List<ItemParams> payloadItems = [];

      final productId = productByID.value.id.toString();
      final variantId = productByID.value.variants?.isNotEmpty == true
          ? (productByID.value.variants![selectedIndex.value].id)
          : "1";
      final itemQty = 1;
      final itemUnitPrice =
          productByID.value.variants![selectedIndex.value].finalPrice;
      final discountNominal = 0.0;
      final itemTotal = itemUnitPrice - discountNominal;
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

      final subtotal = payloadItems.fold(
          0.0, (previousValue, element) => previousValue + element.total);
      // const adminFee = 2500.0;
      // final total = subtotal + adminFee;
      final total = subtotal;

      final params = AddToCartEntityParams(
        customerId: customerId,
        sessionId: customerId,
        customerName: customerId,
        customerEmail: customerId,
        customerPhone: customerId,
        subtotal: subtotal,
        tax: 0,
        discount: 0,
        total: total,
        meta: {},
        items: payloadItems,
      );

      final useCase = addToCartUsecase ??
          AddToCartUsecase(
            CartRepositoryImpl(
              remoteDataSource: CartRemoteDataSourceImpl(),
            ),
          );

      final addToCartResult = await useCase.call(params);
      logger.info(
          '✅ [ADD-TO-CART] Add to Cart successfully! Cart ID: ${addToCartResult.id}');

      await runAddToCartAnimation(widgetKey);

      // Update state after animation completes
      cartQuantityItems++;

      // Run the cart badge animation
      await cartKey.currentState!
          .runCartAnimation(cartController.cartItemCount.toString());

      await refreshCart();
    } catch (e, stackTrace) {
      logger.severe('❌ [ADD-TO-CART] Failed to create order: $e');
      if (kDebugMode) {
        print('❌ [ADD-TO-CART] Error creating order: $e');
        print(stackTrace);
      }
      Get.snackbar(
        'Gagal menambahkan produk',
        'Terjadi kesalahan saat memproses produk. Silakan coba lagi.',
        backgroundColor: Get.context?.theme.colorScheme.error ?? AppColors.red,
        colorText: AppColors.white,
      );
    }
  }
}
