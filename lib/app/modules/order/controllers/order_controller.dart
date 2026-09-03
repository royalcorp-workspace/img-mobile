import 'dart:convert';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/data/datasources/order_remote_datasource.dart';
import 'package:pos_royal/app/data/models/user_model.dart';
import 'package:pos_royal/app/data/repositories/order_repository_impl.dart';
import 'package:pos_royal/app/domain/entities/order_history_entity.dart';
import 'package:pos_royal/app/domain/usecases/get_order_history_usecase.dart';

class OrderController extends GetxController {
  OrderController({
    this.getOrderHistoryUsecase,
  });

  final GetOrderHistoryUsecase? getOrderHistoryUsecase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  RxInt selectedIndex = 0.obs;

  final ScrollController pageScrollController = ScrollController();

  var orderHistory = <OrderHistoryEntity>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 10;
  var orderHistoryErrorMessage = ''.obs;
  RxString customerId = ''.obs;
  final SearchController searchAnchorController = SearchController();

  @override
  void onInit() {
    super.onInit();
    _initScrollListener();
    fetchOrderHistory();
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

  Future<String> _getOrFetchCustomerId() async {
    try {
      final userDataStr = await TokenStorage.getUserData();
      if (userDataStr != null && userDataStr.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userDataStr);
        final userModel = UserModel.fromJson(userMap);
        final customerId = userModel.customer?.id;
        if (customerId != null && customerId.isNotEmpty) {
          return customerId;
        }
        final userId = userModel.id;
        if (userId != null && userId.isNotEmpty) {
          return userId;
        }
      }
    } catch (e) {
      logger.warning('⚠️ [ORDER] Could not parse stored user customer ID: $e');
    }
    return '';
  }

  Future<void> fetchOrderHistory() async {
    try {
      isLoading.value = true;
      orderHistoryErrorMessage.value = '';
      currentPage = 1;
      hasMore.value = true;

      customerId.value = await _getOrFetchCustomerId();

      final useCase = getOrderHistoryUsecase ??
          GetOrderHistoryUsecase(
            OrderRepositoryImpl(
              remoteDataSource: OrderRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
          customerId: '$customerId',
          page: currentPage,
          itemsPerPage: itemsPerPage);
      orderHistory.assignAll(result.data);
      hasMore.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [ORDER] Failed to fetch products: $e');
      if (kDebugMode) {
        print('❌ [ORDER] Error: $e');
        print(stackTrace);
      }
      orderHistoryErrorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (isLoadingMore.value || isLoading.value || !hasMore.value) {
      return;
    }

    try {
      isLoadingMore.value = true;
      final nextPage = currentPage + 1;
      logger.info('🔍 [ORDER] Loading next page: $nextPage');

      final useCase = getOrderHistoryUsecase ??
          GetOrderHistoryUsecase(
            OrderRepositoryImpl(
              remoteDataSource: OrderRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
          customerId: customerId.value,
          page: nextPage,
          itemsPerPage: itemsPerPage);
      if (result.data.isNotEmpty) {
        orderHistory.addAll(result.data);
        currentPage = nextPage;
      }
      hasMore.value = result.hasMore;
    } catch (e) {
      logger.severe('❌ [ORDER] Failed to load next page: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu pembayaran' || 'Draft':
        return const Color(0xFFD97706); // Orange
      case 'konfirmasi':
        return const Color(0xFF2563EB); // Blue
      case 'diproses':
        return const Color(0xFF7C3AED); // Purple
      case 'dikirim':
        return const Color(0xFF0891B2); // Cyan
      case 'terkirim':
        return const Color(0xFF16A34A); // Green
      default:
        return Colors.grey;
    }
  }
}
