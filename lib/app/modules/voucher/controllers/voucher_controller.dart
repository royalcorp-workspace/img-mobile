import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/voucher_remote_datasource.dart';
import 'package:img/app/data/repositories/voucher_repository_impl.dart';
import 'package:img/app/domain/entities/voucher_entity.dart';
import 'package:img/app/domain/usecases/get_voucher_usecase.dart';

class Voucher {
  final String image;
  final String title;
  final String description;
  final String titleVoucher;
  final String subtitleVoucher;
  final String codeVoucher;

  Voucher({
    required this.image,
    required this.title,
    required this.description,
    required this.titleVoucher,
    required this.subtitleVoucher,
    required this.codeVoucher,
  });
}

class VoucherController extends GetxController {
  VoucherController({this.getVoucherUsecase});

  final GetVoucherUsecase? getVoucherUsecase;

  RxInt selectedIndex = 0.obs;
  final ScrollController pageScrollController = ScrollController();
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 10;
  var voucherErrorMessage = ''.obs;
  var vouchers = <VoucherEntity>[].obs;

  @override
  void onInit() async {
    await fetchVouchers();

    super.onInit();
    _initScrollListener();
  }

  void _initScrollListener() {
    pageScrollController.addListener(() {
      if (pageScrollController.position.pixels >=
          pageScrollController.position.maxScrollExtent - 300) {
        loadNextPage();
      }
    });
  }

  Future<void> fetchVouchers() async {
    try {
      isLoading.value = true;
      voucherErrorMessage.value = '';
      currentPage = 1;
      hasMore.value = true;

      final useCase = getVoucherUsecase ??
          GetVoucherUsecase(
            VoucherRepositoryImpl(
              remoteDataSource: VoucherRemoteDataSourceImpl(),
            ),
          );

      final result =
          await useCase.call(page: currentPage, itemsPerPage: itemsPerPage);
      vouchers.assignAll(result.data);
      hasMore.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [VOUCHER] Failed to fetch vouchers: $e');
      if (kDebugMode) {
        print('❌ [VOUCHER] Error: $e');
        print(stackTrace);
      }
      voucherErrorMessage.value = e.toString();
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
      logger.info('🔍 [VOUCHER] Loading next page: $nextPage');

      final useCase = getVoucherUsecase ??
          GetVoucherUsecase(
            VoucherRepositoryImpl(
              remoteDataSource: VoucherRemoteDataSourceImpl(),
            ),
          );

      final result =
          await useCase.call(page: nextPage, itemsPerPage: itemsPerPage);
      if (result.data.isNotEmpty) {
        vouchers.addAll(result.data);
        currentPage = nextPage;
      }
      hasMore.value = result.hasMore;
    } catch (e) {
      logger.severe('❌ [VOUCHER] Failed to load next page: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }
}
