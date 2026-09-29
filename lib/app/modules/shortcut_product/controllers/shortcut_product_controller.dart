import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/product_remote_datasource.dart';
import 'package:img/app/data/repositories/product_repository_impl.dart';
import 'package:img/app/domain/entities/product_entity.dart';
import 'package:img/app/domain/entities/product_tag_entity.dart';
import 'package:img/app/domain/usecases/get_product_by_id_usecase.dart';
import 'package:img/app/domain/usecases/get_product_tags_usecase.dart';
import 'package:img/app/domain/usecases/get_products_usecase.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/routes/app_pages.dart';

class ShortcutProductController extends GetxController {
  ShortcutProductController({
    this.getProductsUseCase,
    this.getProductByIdUsecase,
    this.getProductTagsUseCase,
  });

  final GetProductsUseCase? getProductsUseCase;
  final GetProductByIdUsecase? getProductByIdUsecase;
  final GetProductTagsUseCase? getProductTagsUseCase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();

  final ScrollController pageScrollController = ScrollController();
  final ScrollController shortcutScrollController = ScrollController();
  final SearchController searchAnchorController = SearchController();

  final shortcutList = <ProductTagEntity>[].obs;
  final selectedIndex = 0.obs;

  final products = <ProductEntity>[].obs;
  final isLoadingProducts = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

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

  ProductTagEntity? get selectedShortcut {
    if (selectedIndex.value >= 0 && selectedIndex.value < shortcutList.length) {
      return shortcutList[selectedIndex.value];
    }
    return null;
  }

  String? get selectedShortcutId => selectedShortcut?.id;

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
    shortcutScrollController.dispose();
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
    String? initialShortcutId;

    final args = Get.arguments;
    if (args is Map) {
      if (args.containsKey('initialIndex') && args['initialIndex'] is int) {
        initialIndex = args['initialIndex'] as int;
      }
      if (args.containsKey('tags') && args['tags'] is List) {
        final passedTags =
            (args['tags'] as List).whereType<ProductTagEntity>().toList();
        if (passedTags.isNotEmpty) {
          shortcutList.assignAll(passedTags);
        }
      }
      if (args.containsKey('selectedTag') &&
          args['selectedTag'] is ProductTagEntity) {
        final tag = args['selectedTag'] as ProductTagEntity;
        initialShortcutId = tag.id;
      } else if (args.containsKey('tagId') && args['tagId'] is String) {
        initialShortcutId = args['tagId'] as String;
      } else if (args.containsKey('shortcutId') &&
          args['shortcutId'] is String) {
        initialShortcutId = args['shortcutId'] as String;
      }
    } else if (args is ProductTagEntity) {
      initialShortcutId = args.id;
    } else if (args is int) {
      initialIndex = args;
    } else if (args is String) {
      initialShortcutId = args;
    }

    if (shortcutList.isEmpty) {
      await fetchTags();
    }

    if (initialShortcutId != null && shortcutList.isNotEmpty) {
      final index = shortcutList.indexWhere((s) => s.id == initialShortcutId);
      if (index != -1) {
        initialIndex = index;
      }
    }

    if (shortcutList.isNotEmpty) {
      if (initialIndex < 0 || initialIndex >= shortcutList.length) {
        initialIndex = 0;
      }
      selectedIndex.value = initialIndex;
      _scrollToShortcutIndex(initialIndex);
    }

    fetchProducts();
  }

  Future<void> fetchTags() async {
    try {
      final useCase = getProductTagsUseCase ??
          GetProductTagsUseCase(
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
          );
      final result = await useCase.call();
      shortcutList.assignAll(result);
    } catch (e) {
      logger.warning('❌ [SHORTCUT-PRODUCT] Failed to fetch tags: $e');
    }
  }

  void _scrollToShortcutIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!shortcutScrollController.hasClients) return;
      const itemWidth = 100.0;
      final targetOffset = (index * itemWidth) - 100;
      final maxOffset = shortcutScrollController.position.maxScrollExtent;
      final offset = targetOffset.clamp(0.0, maxOffset);

      shortcutScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void selectShortcut(int index) {
    if (index < 0 || index >= shortcutList.length) return;
    if (selectedIndex.value == index && searchQuery.value.isEmpty) return;

    selectedIndex.value = index;
    searchQuery.value = '';
    searchAnchorController.clear();
    _scrollToShortcutIndex(index);
    fetchProducts();
  }

  void selectShortcutByItem(ProductTagEntity item) {
    final index = shortcutList.indexWhere((s) => s.id == item.id);
    if (index != -1) {
      selectShortcut(index);
    }
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
        tagId: selectedShortcutId,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      products.assignAll(result.data);
      hasMore.value = result.hasMore;
      _loadNextPageIfNeeded();
    } catch (e, stackTrace) {
      logger.severe('❌ [SHORTCUT-PRODUCT] Failed to fetch products: $e');
      if (kDebugMode) {
        print('❌ [SHORTCUT-PRODUCT] Error: $e');
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
      logger.info('🔍 [SHORTCUT-PRODUCT] Loading next page: $nextPage');

      final useCase = getProductsUseCase ??
          GetProductsUseCase(
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
        page: nextPage,
        itemsPerPage: itemsPerPage,
        tagId: selectedShortcutId,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (result.data.isNotEmpty) {
        products.addAll(result.data);
        currentPage = nextPage;
      }
      hasMore.value = result.hasMore;
    } catch (e) {
      logger.severe('❌ [SHORTCUT-PRODUCT] Failed to load next page: $e');
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
        tagId: selectedShortcutId,
        search: query.trim(),
      );
      return result.data;
    } catch (e) {
      logger.warning(
          '❌ [SHORTCUT-PRODUCT] Error searching products suggestions: $e');
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
          '❌ [SHORTCUT-PRODUCT] Failed to fetch detail products by ID: $e');
      if (kDebugMode) {
        print('❌ [SHORTCUT-PRODUCT] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
    } finally {
      isLoadingProducts.value = false;
    }
  }
}
