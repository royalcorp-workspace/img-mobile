import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/homepage_content_remote_datasource.dart';
import 'package:img/app/data/datasources/product_remote_datasource.dart';
import 'package:img/app/data/repositories/homepage_content_repository_impl.dart';
import 'package:img/app/data/repositories/product_repository_impl.dart';
import 'package:img/app/domain/entities/homepage_content_entity.dart';
import 'package:img/app/domain/usecases/get_homepage_content_usecase.dart';
import 'package:img/app/domain/usecases/get_product_by_id_usecase.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/routes/app_pages.dart';

class ProductController extends GetxController {
  ProductController({
    this.getHomepageContentUsecase,
    this.getProductByIdUsecase,
  });

  final GetHomepageContentUsecase? getHomepageContentUsecase;
  final GetProductByIdUsecase? getProductByIdUsecase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();

  RxInt selectedIndex = 0.obs;

  final SearchController searchAnchorController = SearchController();
  final homepageContent = <HomepageContentSectionEntity>[].obs;
  final isLoadingHomepageContent = true.obs;

  var isLoading = false.obs;
  var productErrorMessage = ''.obs;

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
    fetchHomepageContent();
  }

  @override
  void onClose() {
    searchAnchorController.dispose();
    super.onClose();
  }

  Future<void> fetchHomepageContent() async {
    isLoadingHomepageContent.value = true;
    try {
      final useCase = getHomepageContentUsecase ??
          GetHomepageContentUsecase(
            HomepageContentRepositoryImpl(
              remoteDataSource: HomepageContentRemoteDataSourceImpl(),
            ),
          );
      final result = await useCase.call();
      homepageContent.assignAll(
        result.data.where((section) => section.isVisible),
      );
    } catch (e) {
      logger.warning('Failed to load homepage content: $e');
    } finally {
      isLoadingHomepageContent.value = false;
    }
  }

  Future<void> fetchProductByID(String productID) async {
    try {
      isLoading.value = true;
      productErrorMessage.value = '';

      final useCase = getProductByIdUsecase ??
          GetProductByIdUsecase(
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(productID);
      Get.toNamed(
        Routes.DETAIL_PRODUCT,
        arguments: [result, carts],
      );
    } catch (e, stackTrace) {
      logger.severe('❌ [PRODUCT] Failed to fetch detail products by ID: $e');
      if (kDebugMode) {
        print('❌ [PRODUCT] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
