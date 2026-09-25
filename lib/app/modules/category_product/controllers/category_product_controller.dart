import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/category_remote_datasource.dart';
import 'package:img/app/data/datasources/product_remote_datasource.dart';
import 'package:img/app/data/repositories/category_repository_impl.dart';
import 'package:img/app/data/repositories/product_repository_impl.dart';
import 'package:img/app/domain/entities/category_entity.dart';
import 'package:img/app/domain/entities/product_entity.dart';
import 'package:img/app/domain/usecases/get_category_usecase.dart';
import 'package:img/app/domain/usecases/get_product_by_id_usecase.dart';
import 'package:img/app/domain/usecases/get_products_usecase.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/routes/app_pages.dart';

class CategoryProductController extends GetxController {
  CategoryProductController({
    this.getProductsUseCase,
    this.getCategoryUsecase,
    this.getProductByIdUsecase,
  });

  final GetProductsUseCase? getProductsUseCase;
  final GetCategoryUsecase? getCategoryUsecase;
  final GetProductByIdUsecase? getProductByIdUsecase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();

  final ScrollController pageScrollController = ScrollController();
  final ScrollController categoryScrollController = ScrollController();
  final SearchController searchAnchorController = SearchController();

  final categoryList = <CategoryEntity>[].obs;
  final selectedIndex = 0.obs;

  final products = <ProductEntity>[].obs;
  final isLoadingProducts = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

  final isLoadingCategories = false.obs;
  final RxBool showScrollToTop = false.obs;
  final productErrorMessage = ''.obs;

  int currentPage = 1;
  final int itemsPerPage = 10;
  final searchQuery = ''.obs;

  CartController get cartController {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController(), fenix: true);
    }
    return Get.find<CartController>();
  }

  List get carts => cartController.carts;

  CategoryEntity? get selectedCategory {
    if (selectedIndex.value >= 0 && selectedIndex.value < categoryList.length) {
      return categoryList[selectedIndex.value];
    }
    return null;
  }

  String? get selectedCategoryId => selectedCategory?.id;

  @override
  void onInit() {
    super.onInit();
    _initScrollListeners();
    _parseArgumentsAndInit();
  }

  @override
  void onClose() {
    pageScrollController.removeListener(_onScroll);
    pageScrollController.dispose();
    categoryScrollController.dispose();
    searchAnchorController.dispose();
    super.onClose();
  }

  void _initScrollListeners() {
    pageScrollController.addListener(() {
      if (pageScrollController.position.pixels >=
          pageScrollController.position.maxScrollExtent - 300) {
        loadNextPage();
      }
      _onScroll();
    });
  }

  void _onScroll() {
    showScrollToTop.value = pageScrollController.offset > 500;
  }

  void scrollToTop() {
    if (pageScrollController.hasClients) {
      pageScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _parseArgumentsAndInit() async {
    int initialIndex = 0;
    List<CategoryEntity>? passedCategories;
    String? initialCategoryId;

    final args = Get.arguments;
    if (args is Map) {
      if (args.containsKey('initialIndex') && args['initialIndex'] is int) {
        initialIndex = args['initialIndex'] as int;
      }
      if (args.containsKey('categories') && args['categories'] is List) {
        passedCategories = (args['categories'] as List)
            .whereType<CategoryEntity>()
            .toList();
      }
      if (args.containsKey('selectedCategory') &&
          args['selectedCategory'] is CategoryEntity) {
        final cat = args['selectedCategory'] as CategoryEntity;
        initialCategoryId = cat.id;
      } else if (args.containsKey('categoryId') &&
          args['categoryId'] is String) {
        initialCategoryId = args['categoryId'] as String;
      }
    } else if (args is int) {
      initialIndex = args;
    } else if (args is String) {
      initialCategoryId = args;
    }

    if (passedCategories != null && passedCategories.isNotEmpty) {
      categoryList.assignAll(passedCategories);
    } else {
      await fetchCategories();
    }

    if (initialCategoryId != null && categoryList.isNotEmpty) {
      final index = categoryList.indexWhere((c) => c.id == initialCategoryId);
      if (index != -1) {
        initialIndex = index;
      }
    }

    if (categoryList.isNotEmpty) {
      if (initialIndex < 0 || initialIndex >= categoryList.length) {
        initialIndex = 0;
      }
      selectedIndex.value = initialIndex;
      _scrollToCategoryIndex(initialIndex);
    }

    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      final useCase = getCategoryUsecase ??
          GetCategoryUsecase(
            CategoryRepositoryImpl(
              remoteDataSource: CategoryRemoteDataSourceImpl(),
            ),
          );
      final result = await useCase.call(page: 1, itemsPerPage: 50);
      categoryList.assignAll(result.data);
    } catch (e) {
      logger.warning('❌ [CATEGORY-PRODUCT] Failed to fetch categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void _scrollToCategoryIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!categoryScrollController.hasClients) return;
      const itemWidth = 100.0;
      final targetOffset = (index * itemWidth) - 100;
      final maxOffset = categoryScrollController.position.maxScrollExtent;
      final offset = targetOffset.clamp(0.0, maxOffset);

      categoryScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void selectCategory(int index) {
    if (index < 0 || index >= categoryList.length) return;
    if (selectedIndex.value == index && searchQuery.value.isEmpty) return;

    selectedIndex.value = index;
    searchQuery.value = '';
    searchAnchorController.clear();
    _scrollToCategoryIndex(index);
    fetchProducts();
  }

  Future<void> fetchProducts({String? search}) async {
    try {
      isLoadingProducts.value = true;
      productErrorMessage.value = '';
      currentPage = 1;
      hasMore.value = true;

      if (search != null) {
        searchQuery.value = search;
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
        categoryId: selectedCategoryId,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      products.assignAll(result.data);
      hasMore.value = result.hasMore;
      _loadNextPageIfNeeded();
    } catch (e, stackTrace) {
      logger.severe('❌ [CATEGORY-PRODUCT] Failed to fetch products: $e');
      if (kDebugMode) {
        print('❌ [CATEGORY-PRODUCT] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (isLoadingMore.value || isLoadingProducts.value || !hasMore.value) {
      return;
    }

    try {
      isLoadingMore.value = true;
      final nextPage = currentPage + 1;
      logger.info('🔍 [CATEGORY-PRODUCT] Loading next page: $nextPage');

      final useCase = getProductsUseCase ??
          GetProductsUseCase(
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
        page: nextPage,
        itemsPerPage: itemsPerPage,
        categoryId: selectedCategoryId,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (result.data.isNotEmpty) {
        products.addAll(result.data);
        currentPage = nextPage;
      }
      hasMore.value = result.hasMore;
    } catch (e) {
      logger.severe('❌ [CATEGORY-PRODUCT] Failed to load next page: $e');
    } finally {
      isLoadingMore.value = false;
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
        categoryId: selectedCategoryId,
        search: query.trim(),
      );
      return result.data;
    } catch (e) {
      logger.warning(
          '❌ [CATEGORY-PRODUCT] Error searching products suggestions: $e');
      return [];
    }
  }

  Future<void> fetchProductByID(String productID) async {
    if (isLoadingProducts.value) return;

    try {
      isLoadingProducts.value = true;
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
      logger.severe(
          '❌ [CATEGORY-PRODUCT] Failed to fetch detail products by ID: $e');
      if (kDebugMode) {
        print('❌ [CATEGORY-PRODUCT] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
    } finally {
      isLoadingProducts.value = false;
    }
  }
}
