import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/core/utils/event_time_helper.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/core/utils/token_storage.dart';
import 'package:img/app/data/datasources/homepage_content_remote_datasource.dart';
import 'package:img/app/data/datasources/product_remote_datasource.dart';
import 'package:img/app/data/models/address_model.dart';
import 'package:img/app/data/models/user_model.dart';
import 'package:img/app/data/repositories/homepage_content_repository_impl.dart';
import 'package:img/app/domain/entities/content_banner_entity.dart';
import 'package:img/app/domain/entities/content_event_active_data_entity.dart';
import 'package:img/app/domain/usecases/get_content_banner_usecase.dart';
import 'package:img/app/domain/usecases/get_content_event_active_usecase.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';
import 'package:img/app/data/repositories/product_repository_impl.dart';
import 'package:img/app/domain/usecases/get_cart_usecase.dart';
import 'package:img/app/domain/usecases/get_product_by_id_usecase.dart';
import 'package:img/app/domain/usecases/get_products_usecase.dart';
import 'package:img/app/routes/app_pages.dart';
import 'package:img/app/domain/entities/product_entity.dart';

import 'package:img/app/domain/entities/product_tag_entity.dart';
import 'package:img/app/domain/usecases/get_product_tags_usecase.dart';
import 'package:img/app/shared/widgets/button/primary_button.dart';

class HomeController extends GetxController {
  HomeController({
    this.getProductsUseCase,
    this.getProductByIdUsecase,
    this.getCartUsecase,
    this.getContentEventActiveUsecase,
    this.getProductTagsUseCase,
  });

  final GetProductsUseCase? getProductsUseCase;
  final GetProductByIdUsecase? getProductByIdUsecase;
  final GetCartUsecase? getCartUsecase;
  final GetContentEventActiveUsecase? getContentEventActiveUsecase;
  final GetProductTagsUseCase? getProductTagsUseCase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var cartQuantityItems = 0.obs;

  // Products Infinite Scroll State
  final ScrollController pageScrollController = ScrollController(); // renamed

  var products = [].obs;
  var banners = <ContentBannerEntity>[].obs;
  var contentEventActive = <ContentEventActiveDataEntity>[].obs;
  var productTags = <ProductTagEntity>[].obs;
  RxList<AddressModel>? adddress = <AddressModel>[].obs;

  // Active Event & Anti-Cheat Monotonic Countdown State
  final Stopwatch _eventStopwatch = Stopwatch();
  DateTime? _initialServerUtcTime;
  var eventCountdownText = '00 : 00 : 00'.obs;
  var isEventActive = false.obs;
  var activeEventTitle = ''.obs;
  var isLoadingProducts = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 10;
  var activeBannerIndex = 0.obs;
  var productErrorMessage = ''.obs;
  var bannerErrorMessage = ''.obs;

  var selectedCategoryId = RxnString();
  var selectedShortcutId = RxnString();
  var selectedSortOption = 'Terpopuler'.obs;
  var searchQuery = ''.obs;
  final SearchController searchAnchorController = SearchController();
  Timer? _timer;

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

  @override
  void onInit() {
    super.onInit();
    _initScrollListener();
    fetchProducts();
    _fetchBanners();
    _fetchContentEventActive();
    _fetchProductTags();
    _fetchAddress();
  }

  @override
  void onClose() {
    pageScrollController.removeListener(_onScroll);
    pageScrollController.dispose();
    _timer?.cancel();
    _eventStopwatch.stop();
    searchAnchorController.dispose();
    super.onClose();
  }

  void sortProducts(String option) {
    selectedSortOption.value = option;
    if (products.isEmpty) return;

    final list = List.from(products);
    if (option == 'Harga: Rendah ke Tinggi') {
      list.sort((a, b) {
        final double priceA =
            (a.finalPrice > 0 ? a.finalPrice : a.basePrice).toDouble();
        final double priceB =
            (b.finalPrice > 0 ? b.finalPrice : b.basePrice).toDouble();
        return priceA.compareTo(priceB);
      });
    } else if (option == 'Harga: Tinggi ke Rendah') {
      list.sort((a, b) {
        final double priceA =
            (a.finalPrice > 0 ? a.finalPrice : a.basePrice).toDouble();
        final double priceB =
            (b.finalPrice > 0 ? b.finalPrice : b.basePrice).toDouble();
        return priceB.compareTo(priceA);
      });
    } else if (option == 'Rating Tertinggi') {
      list.sort((a, b) {
        final double ratingA = (a.avgRating ?? 4.2).toDouble();
        final double ratingB = (b.avgRating ?? 4.2).toDouble();
        return ratingB.compareTo(ratingA);
      });
    } else if (option == 'Terbaru') {
      // Keep default API order
    } else {
      // Terpopuler: sort by totalReviews
      list.sort((a, b) {
        final int revA = (a.totalReviews ?? 128);
        final int revB = (b.totalReviews ?? 128);
        return revB.compareTo(revA);
      });
    }
    products.assignAll(list);
  }

  void _updateEventCountdown() {
    if (_initialServerUtcTime == null || contentEventActive.isEmpty) return;

    final activeEvent =
        contentEventActive.firstWhereOrNull((e) => e.isActive) ??
            contentEventActive.first;
    activeEventTitle.value = activeEvent.title;

    // Current Server UTC Time computed monotonically (Immune to device clock tampering)
    final currentServerUtc =
        _initialServerUtcTime!.add(_eventStopwatch.elapsed);

    final startUtc = EventTimeHelper.parseToUtc(
      activeEvent.startDate,
      timezone: activeEvent.timezone,
      timezoneName: activeEvent.timezoneName,
    );

    final endUtc = EventTimeHelper.parseToUtc(
      activeEvent.endDate,
      timezone: activeEvent.timezone,
      timezoneName: activeEvent.timezoneName,
    );

    if (endUtc == null) return;

    if (startUtc != null && currentServerUtc.isBefore(startUtc)) {
      final durationToStart = startUtc.difference(currentServerUtc);
      eventCountdownText.value =
          EventTimeHelper.formatCountdown(durationToStart);
      isEventActive.value = false;
    } else {
      final remaining = endUtc.difference(currentServerUtc);
      if (remaining.isNegative || remaining == Duration.zero) {
        eventCountdownText.value = '00 : 00 : 00';
        isEventActive.value = false;
      } else {
        eventCountdownText.value = EventTimeHelper.formatCountdown(remaining);
        isEventActive.value = true;
      }
    }
  }

  void _initScrollListener() {
    pageScrollController.addListener(() {
      if (pageScrollController.position.pixels >=
          pageScrollController.position.maxScrollExtent - 300) {
        loadNextPage();
      }
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

  Future<void> fetchProducts() async {
    try {
      isLoadingProducts.value = true;
      productErrorMessage.value = '';
      currentPage = 1;
      hasMore.value = true;

      if (resetFilters) {
        searchQuery.value = '';
        selectedCategoryId.value = null;
        selectedShortcutId.value = null;
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

      final result =
          await useCase.call(page: currentPage, itemsPerPage: itemsPerPage);
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

  Future<void> _fetchBanners() async {
    try {
      productErrorMessage.value = '';

      final useCase = getContentBannerUsecase ??
          GetContentBannerUsecase(
            HomepageContentRepositoryImpl(
              remoteDataSource: HomepageContentRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call();
      banners.assignAll(result.data);
    } catch (e, stackTrace) {
      logger.severe('❌ [HOME] Failed to fetch banners: $e');
      if (kDebugMode) {
        print('❌ [HOME] Error: $e');
        print(stackTrace);
      }
      bannerErrorMessage.value = e.toString();
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
        arguments: result,
      );
    } catch (e, stackTrace) {
      logger.severe('❌ [HOME] Failed to fetch products by ID: $e');
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

      final result =
          await useCase.call(page: nextPage, itemsPerPage: itemsPerPage);
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

  Future<void> _fetchContentEventActive() async {
    try {
      final useCase = getContentEventActiveUsecase ??
          GetContentEventActiveUsecase(
            HomepageContentRepositoryImpl(
              remoteDataSource: HomepageContentRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call();

      contentEventActive.assignAll(result.data);

      // Initialize Anti-Cheat Monotonic Timer with Server Time parsed to UTC
      _initialServerUtcTime = EventTimeHelper.parseToUtc(
        result.serverTime,
        timezone: result.timezone,
        timezoneName: result.timezoneName,
      );
      _eventStopwatch.stop();
      _eventStopwatch.reset();
      _eventStopwatch.start();

      _updateEventCountdown();
    } catch (e, stackTrace) {
      logger.severe('❌ [HOME] Failed to fetch content event active: $e');
      if (kDebugMode) {
        print('❌ [HOME] Error: $e');
        print(stackTrace);
      }
      productErrorMessage.value = e.toString();
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
      logger.severe('❌ [HOME] Failed to fetch product tags: $e');
      if (kDebugMode) {
        print('❌ [HOME] Error: $e');
        print(stackTrace);
      }
    }
  }

  Future<String?> _fetchAddress() async {
    try {
      final userDataStr = await TokenStorage.getUserData();
      if (userDataStr != null && userDataStr.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userDataStr);
        final Map<String, dynamic> userPayload = userMap['user'] ?? userMap;
        final userModel = UserModel.fromJson(userPayload);

        adddress?.value = userModel.customer?.addresses ?? <AddressModel>[];

        // 🔥 SOLUSI 2: Gunakan operator safety ?. atau check null sebelum memanggil .isEmpty
        if (adddress != null && adddress!.isEmpty) {
          Future.delayed(const Duration(milliseconds: 500), () {
            showLocationPermissionDialog();
          });
        }
      }
    } catch (e) {
      logger
          .warning('⚠️ [ADDRESS] Could not parse stored user customer ID: $e');
    }
    return null;
  }

  void showLocationPermissionDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Sudut melengkung luar
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(24), // Agar gambar tidak bocor keluar sudut
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(14),
                width: double.infinity,
                color: AppColors.white,
                child: Center(
                  child: Image.asset(Helper.getImagePath('img_address.png')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Kami butuh Lokasimu!',
                      style: AppTextStyle.largeBlackBold,
                      textAlign: TextAlign.center,
                    ),
                    12.verticalSpace,
                    Text(
                      'Akses Lokasi akan digunakan untuk mendapatkan lokasi kamu, dan Jarak Toko ke lokasi kamu saat ini',
                      style: AppTextStyle.mediumGrey.copyWith(height: 1.2),
                      textAlign: TextAlign.center,
                    ),
                    24.verticalSpace,
                    ButtonPrimary(
                      fullWidth: true,
                      text: 'Tambah Alamat',
                      textColor: AppColors.white,
                      color: AppColors.primaryColor,
                      onPressed: () {
                        Get.back();
                        Get.toNamed(Routes.ADDRESS);
                      },
                    ),
                  ],
                ),
              ),
              14.verticalSpace,
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
