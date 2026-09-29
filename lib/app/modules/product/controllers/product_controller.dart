import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> _fetchCategory() async {
    try {
      productErrorMessage.value = '';
      categoryPage = 1;
      hasMoreCategories.value = true;

      final useCase = getCategoryUsecase ??
          GetCategoryUsecase(
            CategoryRepositoryImpl(
              remoteDataSource: CategoryRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(page: 1, itemsPerPage: itemsPerPage);
      category.assignAll(result.data);
      hasMoreCategories.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [PRODUCT] Failed to fetch category: $e');
      if (kDebugMode) {
        print('❌ [PRODUCT] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
    }
  }

  Future<void> loadNextCategoryPage() async {
    if (isLoadingMoreCategories.value || !hasMoreCategories.value) return;

    try {
      isLoadingMoreCategories.value = true;
      final nextPage = categoryPage + 1;

      final useCase = getCategoryUsecase ??
          GetCategoryUsecase(
            CategoryRepositoryImpl(
              remoteDataSource: CategoryRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
        page: nextPage,
        itemsPerPage: itemsPerPage,
      );
      if (result.data.isNotEmpty) {
        category.addAll(result.data);
        categoryPage = nextPage;
      }
      hasMoreCategories.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [PRODUCT] Failed to load next category page: $e');
      if (kDebugMode) {
        print('❌ [PRODUCT] Error: $e');
        print(stackTrace);
      }
    } finally {
      isLoadingMoreCategories.value = false;
    }
  }

  void _initCategoryScrollListener() {
    categoryScrollController.addListener(() {
      if (categoryScrollController.position.pixels >=
          categoryScrollController.position.maxScrollExtent - 120) {
        loadNextCategoryPage();
      }
    });
  }

  Future<void> fetchProducts({
    String? search,
    String? categoryId,
    bool resetFilters = false,
  }) async {
    try {
      isLoadingProducts.value = true;
      productErrorMessage.value = '';
      currentPage = 1;
      hasMore.value = true;

      if (resetFilters) {
        searchQuery.value = '';
        selectedCategoryId.value = null;
        searchAnchorController.clear();
      } else {
        if (search != null) searchQuery.value = search;
        if (categoryId != null) selectedCategoryId.value = categoryId;
      }

      final useCase = getProductsUseCase ??
          GetProductsUseCase(
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
        page: currentPage,
        itemsPerPage: itemsPerPage,
        categoryId: selectedCategoryId.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      products.assignAll(result.data);
      hasMore.value = result.hasMore;
      _loadNextPageIfNeeded();
    } catch (e, stackTrace) {
      logger.severe('❌ [PRODUCT] Failed to fetch products: $e');
      if (kDebugMode) {
        print('❌ [PRODUCT] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void _loadNextPageIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!pageScrollController.hasClients ||
          pageScrollController.position.maxScrollExtent > 300) {
        return;
      }
      loadNextPage();
    });
  }

  Future<void> loadNextPage() async {
    if (isLoadingMore.value || isLoadingProducts.value || !hasMore.value) {
      return;
    }

    try {
      isLoadingMore.value = true;
      final nextPage = currentPage + 1;
      logger.info('🔍 [PRODUCT] Loading next page: $nextPage');

      final useCase = getProductsUseCase ??
          GetProductsUseCase(
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
        page: nextPage,
        itemsPerPage: itemsPerPage,
        categoryId: selectedCategoryId.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      if (result.data.isNotEmpty) {
        products.addAll(result.data);
        currentPage = nextPage;
      }
      hasMore.value = result.hasMore;
    } catch (e) {
      logger.severe('❌ [PRODUCT] Failed to load next page: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<List<ProductEntity>> searchProductsFromApi(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final useCase = getProductsUseCase ??
          GetProductsUseCase(
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
          );
      final result = await useCase.call(
        page: 1,
        itemsPerPage: 10,
        search: query.trim(),
      );
      return result.data;
    } catch (e) {
      logger.warning('❌ [PRODUCT] Error searching products suggestions: $e');
      return [];
    }
  }

  Future<void> _fetchProductTags() async {
    try {
      final useCase = getProductTagsUseCase ??
          GetProductTagsUseCase(
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
          );
      final result = await useCase.call();
      productTags.assignAll(result);
    } catch (e, stackTrace) {
      logger.severe('❌ [PRODUCT] Failed to fetch product tags: $e');
      if (kDebugMode) {
        print('❌ [PRODUCT] Error: $e');
        print(stackTrace);
      }
    }
  }
}
