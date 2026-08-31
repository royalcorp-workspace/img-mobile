import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/datasources/cart_remote_datasource.dart';
import 'package:pos_royal/app/data/repositories/cart_repository_impl.dart';
import 'package:pos_royal/app/domain/entities/cart_entity.dart';
import 'package:pos_royal/app/domain/usecases/get_cart_usecase.dart';

class CartController extends GetxController {
  CartController({
    this.getCartUsecase,
  });

  final GetCartUsecase? getCartUsecase;

  RxBool selectedCart = false.obs;
  RxInt selectedQty = 1.obs;
  RxInt selectedPrice = 1087210.obs;
  var carts = <CartEntity>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 10;

  final ScrollController pageScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasMore.value = true;

      final useCase = getCartUsecase ??
          GetCartUsecase(
            CartRepositoryImpl(
              remoteDataSource: CartRemoteDataSourceImpl(),
            ),
          );

      final result =
          await useCase.call(page: currentPage, itemsPerPage: itemsPerPage);
      carts.assignAll(result.data);
      hasMore.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [HOME] Failed to fetch carts: $e');
      if (kDebugMode) {
        print('❌ [HOME] Error: $e');
        print(stackTrace);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void incrementQty() {
    selectedQty.value++;
  }

  void decrementQty() {
    if (selectedQty.value == 0) {
      selectedQty.value;
    } else {
      selectedQty.value--;
    }
  }

  void showDeleteConfirmationDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hapus Produk Terpilih ?',
                style: AppTextStyle.xLargeBlackBold,
                textAlign: TextAlign.center,
              ),
              12.verticalSpace,
              Text(
                'Produk yang kamu pilih akan dihapus\ndari keranjang secara permanen',
                style: AppTextStyle.mediumGrey.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Batal',
                        style: AppTextStyle.largeBlackBold,
                      ),
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Hapus',
                        style: AppTextStyle.largeWhiteBold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
