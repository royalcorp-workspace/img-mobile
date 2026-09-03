import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/data/datasources/cart_remote_datasource.dart';
import 'package:pos_royal/app/data/repositories/cart_repository_impl.dart';
import 'package:pos_royal/app/domain/entities/add_to_cart_entity.dart';
import 'package:pos_royal/app/domain/entities/cart_entity.dart';
import 'package:pos_royal/app/domain/usecases/get_cart_usecase.dart';

class CartController extends GetxController {
  CartController({
    this.getCartUsecase,
  });

  final GetCartUsecase? getCartUsecase;

  final RxMap<String, bool> selectedItems = <String, bool>{}.obs;
  final RxMap<String, int> itemQuantities = <String, int>{}.obs;

  var carts = <CartEntity>[].obs;

  Future<void> fetchCart() async {
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
      update();

      for (final item in cartItems) {
        final itemId = item.id ?? uniqueKeyForItem(item);
        if (!itemQuantities.containsKey(itemId)) {
          itemQuantities[itemId] = item.quantity;
        }
        if (!selectedItems.containsKey(itemId)) {
          selectedItems[itemId] = false;
        }
      }
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

  int get cartItemCount {
    var total = 0;
    for (final cart in carts) {
      if (cart.items != null) {
        for (final item in cart.items!) {
          total += item.quantity;
        }
      }
    }
    return total;
  }

  List<ItemCart> get cartItems {
    final List<ItemCart> items = [];
    for (var cart in carts) {
      if (cart.items != null && cart.items!.isNotEmpty) {
        items.addAll(cart.items!);
      }
    }

    for (final item in items) {
      final itemId = item.id ?? uniqueKeyForItem(item);
      if (!itemQuantities.containsKey(itemId)) {
        itemQuantities[itemId] = item.quantity;
      }
      if (!selectedItems.containsKey(itemId)) {
        selectedItems[itemId] = false;
      }
    }

    return items;
  }

  bool isItemSelected(String itemId) => selectedItems[itemId] ?? false;

  int getItemQuantity(String itemId) {
    final item = cartItems.firstWhereOrNull(
      (element) => (element.id ?? uniqueKeyForItem(element)) == itemId,
    );
    final fallback = item?.quantity ?? 1;
    if (!itemQuantities.containsKey(itemId)) {
      itemQuantities[itemId] = fallback;
    }
    return itemQuantities[itemId] ?? fallback;
  }

  void toggleItemSelection(String itemId, bool value) {
    selectedItems[itemId] = value;
    selectedItems.refresh();
    update();
  }

  void incrementQty(String itemId) {
    final currentQty = getItemQuantity(itemId);
    itemQuantities[itemId] = currentQty + 1;
    itemQuantities.refresh();
    update();
  }

  void decrementQty(String itemId) {
    final currentQty = getItemQuantity(itemId);
    if (currentQty <= 1) {
      showDeleteConfirmationDialog(itemId);
      return;
    }

    itemQuantities[itemId] = currentQty - 1;
    itemQuantities.refresh();
    update();
  }

  bool get hasSelectedItems => selectedCartItems.isNotEmpty;

  List<ItemCart> get selectedCartItems {
    final List<ItemCart> selected = [];
    for (final item in cartItems) {
      final itemId = item.id ?? uniqueKeyForItem(item);
      if (selectedItems[itemId] == true) {
        final updatedQuantity = itemQuantities[itemId] ?? item.quantity;
        final updatedTotal = item.unitPrice * updatedQuantity;

        selected.add(ItemCart(
          productId: item.productId,
          productVariantId: item.productVariantId,
          name: item.name,
          quantity: updatedQuantity,
          unitPrice: item.unitPrice,
          total: updatedTotal,
          discountNominal: item.discountNominal,
          discountPercent: item.discountPercent,
          itemNotes: item.itemNotes,
          meta: item.meta,
          id: item.id,
          addToCartId: item.addToCartId,
          product: item.product,
          variant: item.variant,
        ));
      }
    }
    return selected;
  }

  double get selectedTotalPrice {
    double total = 0;
    for (final item in selectedCartItems) {
      final itemId = item.id ?? uniqueKeyForItem(item);
      final qty = getItemQuantity(itemId);
      final price = item.unitPrice;
      total += (price * qty);
    }
    return total;
  }

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 10;

  final ScrollController pageScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  String uniqueKeyForItem(ItemCart item) {
    final productId = item.productId ?? item.product?.id ?? 'unknown';
    final name = item.name ?? 'item';
    final addToCartId = item.addToCartId ?? '';
    return '$productId-$name-$addToCartId';
  }

  void showDeleteConfirmationDialog(String itemId) {
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
                        selectedItems.remove(itemId);
                        itemQuantities.remove(itemId);
                        selectedItems.refresh();
                        itemQuantities.refresh();
                        update();
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
