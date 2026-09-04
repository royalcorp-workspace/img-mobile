import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/category_remote_datasource.dart';
import 'package:img/app/data/datasources/product_remote_datasource.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/data/repositories/category_repository_impl.dart';
import 'package:img/app/data/repositories/product_repository_impl.dart';
import 'package:img/app/domain/usecases/get_cart_usecase.dart';
import 'package:img/app/domain/usecases/get_category_usecase.dart';
import 'package:img/app/domain/usecases/get_product_by_id_usecase.dart';
import 'package:img/app/domain/usecases/get_products_usecase.dart';
import 'package:img/app/modules/home/views/home_view.dart';
import 'package:img/app/modules/home/widgets/parts_product.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/shared/widgets/app_banner.dart';
import 'package:img/app/domain/entities/product_entity.dart';

class HomeController extends GetxController {
  HomeController({
    this.getProductsUseCase,
    this.getProductByIdUsecase,
    this.getCategoryUsecase,
    this.getCartUsecase,
  });

  final GetProductsUseCase? getProductsUseCase;
  final GetProductByIdUsecase? getProductByIdUsecase;
  final GetCategoryUsecase? getCategoryUsecase;
  final GetCartUsecase? getCartUsecase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  // Products Infinite Scroll State
  final ScrollController pageScrollController = ScrollController(); // renamed
  var products = [].obs;
  var category = [].obs;
  var isLoadingProducts = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 10;
  var productErrorMessage = ''.obs;

  var selectedCategoryId = RxnString();
  var searchQuery = ''.obs;
  final SearchController searchAnchorController = SearchController();

  double priceVal = 0.0;
  double originalPriceVal = 0.0;

  String formattedPrice = '';
  String formattedOriginalPrice = '';
  String imageUrl = '';

  CartController get cartController {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController(), fenix: true);
    }
    return Get.find<CartController>();
  }

  List get carts => cartController.carts;

  /// List Slider
  List<CustomBanner> customBannerListSlider = [
    const CustomBanner(imagePath: 'img_banner.jpeg'),
    const CustomBanner(imagePath: 'img_banner.jpeg'),
    const CustomBanner(imagePath: 'img_banner.jpeg'),
  ];

  /// List Parts Product
  List<PartsProduct> customPartsProduct = [
    const PartsProduct(imagePath: 'img_bed_home.png', title: 'Kasur'),
    const PartsProduct(imagePath: 'img_pillow_home.png', title: 'Bantal'),
    const PartsProduct(imagePath: 'img_rolls_home.png', title: 'Guling'),
    const PartsProduct(imagePath: 'img_acc_home.png', title: 'Aksesoris'),
  ];

  /// List Brands
  List<CategoryBrand> customBrand = [
    const CategoryBrand(imagePath: 'img_brand1.png'),
    const CategoryBrand(imagePath: 'img_brand2.png'),
    const CategoryBrand(imagePath: 'img_brand3.png'),
    const CategoryBrand(imagePath: 'img_brand4.png'),
    const CategoryBrand(imagePath: 'img_brand5.png'),
    const CategoryBrand(imagePath: 'img_brand6.png'),
  ];

  @override
  void onInit() {
    super.onInit();
    _initScrollListener();
    fetchProducts();
    refreshCart();
    fetchCategory();
  }

  @override
  void onClose() {
    pageScrollController.dispose();
    searchAnchorController.dispose();
    super.onClose();
  }

  void _initScrollListener() {
    pageScrollController.addListener(() {
      if (pageScrollController.position.pixels >=
          pageScrollController.position.maxScrollExtent - 300) {
        loadNextPage();
      }
    });
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
    } catch (e, stackTrace) {
      logger.severe('❌ [HOME] Failed to fetch products: $e');
      if (kDebugMode) {
        print('❌ [HOME] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> refreshCart() async {
    try {
      isLoadingProducts.value = true;
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
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> fetchCategory() async {
    try {
      isLoadingProducts.value = true;
      productErrorMessage.value = '';
      currentPage = 1;
      hasMore.value = true;

      final useCase = getCategoryUsecase ??
          GetCategoryUsecase(
            CategoryRepositoryImpl(
              remoteDataSource: CategoryRemoteDataSourceImpl(),
            ),
          );

      final result =
          await useCase.call(page: currentPage, itemsPerPage: itemsPerPage);
      category.assignAll(result.data);
      hasMore.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [HOME] Failed to fetch category: $e');
      if (kDebugMode) {
        print('❌ [HOME] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> fetchProductByID(String productID) async {
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
      logger.severe('❌ [HOME] Failed to fetch detail products by ID: $e');
      if (kDebugMode) {
        print('❌ [HOME] Error: $e');
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
      logger.info('🔍 [HOME] Loading next page: $nextPage');

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
      logger.severe('❌ [HOME] Failed to load next page: $e');
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
      logger.warning('❌ [HOME] Error searching products suggestions: $e');
      return [];
    }
  }

  Future<void> addToCart(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);

    // Update state after animation completes
    await refreshCart();

    // Run the cart badge animation
    await cartKey.currentState!
        .runCartAnimation(cartController.cartItemCount.toString());
  }
}
