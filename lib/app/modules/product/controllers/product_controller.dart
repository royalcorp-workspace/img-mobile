import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/category_remote_datasource.dart';
import 'package:img/app/data/datasources/homepage_content_remote_datasource.dart';
import 'package:img/app/data/datasources/product_remote_datasource.dart';
import 'package:img/app/data/repositories/category_repository_impl.dart';
import 'package:img/app/data/repositories/homepage_content_repository_impl.dart';
import 'package:img/app/data/repositories/product_repository_impl.dart';
import 'package:img/app/domain/entities/category_entity.dart';
import 'package:img/app/domain/entities/homepage_content_entity.dart';
import 'package:img/app/domain/entities/product_entity.dart';
import 'package:img/app/domain/entities/product_tag_entity.dart';
import 'package:img/app/domain/usecases/get_category_usecase.dart';
import 'package:img/app/domain/usecases/get_homepage_content_usecase.dart';
import 'package:img/app/domain/usecases/get_product_by_id_usecase.dart';
import 'package:img/app/domain/usecases/get_product_tags_usecase.dart';
import 'package:img/app/domain/usecases/get_products_usecase.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/routes/app_pages.dart';

class ProductController extends GetxController {
  ProductController({
    this.getHomepageContentUsecase,
    this.getProductByIdUsecase,
    this.getCategoryUsecase,
    this.getProductsUseCase,
    this.getProductTagsUseCase,
  });

  final GetHomepageContentUsecase? getHomepageContentUsecase;
  final GetProductByIdUsecase? getProductByIdUsecase;
  final GetCategoryUsecase? getCategoryUsecase;
  final GetProductsUseCase? getProductsUseCase;
  final GetProductTagsUseCase? getProductTagsUseCase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final ScrollController categoryScrollController = ScrollController();
  final ScrollController pageScrollController = ScrollController(); // renamed

  RxInt selectedIndex = 0.obs;
  final int itemsPerPage = 10;
  var isLoadingProducts = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;

  final SearchController searchAnchorController = SearchController();
  final homepageContent = <HomepageContentSectionEntity>[].obs;
  final isLoadingHomepageContent = true.obs;
  var category = <CategoryEntity>[].obs;

  var isLoading = false.obs;
  var productErrorMessage = ''.obs;
  var searchQuery = ''.obs;

  var isLoadingMoreCategories = false.obs;
  var hasMoreCategories = true.obs;
  var categoryPage = 1;
  var selectedCategoryId = RxnString();
  var products = [].obs;
  var productTags = <ProductTagEntity>[].obs;

  CartController get cartController {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController(), fenix: true);
    }
    return Get.find<CartController>();
  }

  List get carts => cartController.carts;

  @override
  void onInit() {
    startTimer();
    super.onInit();
    _initCategoryScrollListener();
    fetchHomepageContent();
    _fetchCategory();
    _fetchProductTags();
  }

  @override
  void onClose() {
    searchAnchorController.dispose();
    categoryScrollController.dispose();
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
