import 'dart:convert';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/core/utils/token_storage.dart';
import 'package:img/app/data/datasources/order_remote_datasource.dart';
import 'package:img/app/data/models/user_model.dart';
import 'package:img/app/data/repositories/order_repository_impl.dart';
import 'package:img/app/domain/entities/order_history_entity.dart';
import 'package:img/app/domain/usecases/get_order_history_usecase.dart';

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

  List<OrderHistoryEntity> get filteredOrderHistory {
    switch (selectedIndex.value) {
      case 1:
        return orderHistory
            .where((order) => _hasStatus(order, const {'draft'}))
            .toList();
      case 2:
        return orderHistory
            .where((order) => _hasStatus(order, const {'menunggu pembayaran'}))
            .toList();
      case 3:
        return orderHistory
            .where((order) => _hasStatus(order, const {'diproses'}))
            .toList();
      case 4:
        return orderHistory
            .where((order) => _hasStatus(order, const {'gagal transaksi'}))
            .toList();
      case 5:
        return orderHistory
            .where((order) => _isCompletedStatus(order.statusLabel))
            .toList();
      default:
        return orderHistory.toList();
    }
  }

  bool _hasStatus(OrderHistoryEntity order, Set<String> statuses) {
    return statuses.contains(order.statusLabel.trim().toLowerCase());
  }

  bool _isCompletedStatus(String status) {
    switch (status.trim().toLowerCase()) {
      case 'terkirim':
      case 'selesai':
        return true;
      default:
        return false;
    }
  }

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
      case 'menunggu pembayaran':
        return const Color(0xFFD97706);
      case 'draft':
        return Colors.grey; // Grey
      case 'konfirmasi':
        return const Color(0xFF2563EB); // Purple
      case 'diproses':
        return const Color(0xFF7C3AED); // Orange
      case 'dikirim':
        return const Color(0xFF0891B2); // Cyan
      case 'terkirim':
        return const Color(0xFF16A34A); // Green
      case 'gagal transaksi':
        return const Color(0xFFA31616); // Red
      default:
        return const Color(0xFF2563EB);
    }
  }
}
