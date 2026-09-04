import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/cart_remote_datasource.dart';
import 'package:img/app/data/repositories/cart_repository_impl.dart';
import 'package:img/app/domain/entities/add_to_cart_entity.dart';
import 'package:img/app/domain/entities/cart_entity.dart';
import 'package:img/app/domain/usecases/get_cart_usecase.dart';
import 'package:img/app/domain/usecases/delete_cart_item_usecase.dart';

class CartController extends GetxController {
  CartController({
    this.getCartUsecase,
    this.deleteCartItemUsecase,
  });

  final GetCartUsecase? getCartUsecase;
  final DeleteCartItemUsecase? deleteCartItemUsecase;

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
      _syncItemState();
      update();
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
    return items;
  }

  bool isItemSelected(String itemId) => selectedItems[itemId] ?? false;

  int getItemQuantity(String itemId) {
    final item = cartItems.firstWhereOrNull(
      (element) => (element.id ?? uniqueKeyForItem(element)) == itemId,
    );
    final fallback = item?.quantity ?? 1;
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

  void _syncItemState() {
    final currentItemIds = <String>{};
    for (final item in cartItems) {
      final itemId = item.id ?? uniqueKeyForItem(item);
      currentItemIds.add(itemId);
      itemQuantities.putIfAbsent(itemId, () => item.quantity);
      selectedItems.putIfAbsent(itemId, () => false);
    }

    itemQuantities.removeWhere((itemId, _) => !currentItemIds.contains(itemId));
    selectedItems.removeWhere((itemId, _) => !currentItemIds.contains(itemId));
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
                      onPressed: () async {
                        final item = cartItems.firstWhereOrNull(
                          (cartItem) =>
                              (cartItem.id ?? uniqueKeyForItem(cartItem)) ==
                              itemId,
                        );
                        if (item?.addToCartId == null || item?.id == null) {
                          Get.snackbar(
                            'Gagal menghapus produk',
                            'Data produk tidak lengkap.',
                            backgroundColor: AppColors.red,
                            colorText: AppColors.white,
                          );
                          return;
                        }

                        final useCase = deleteCartItemUsecase ??
                            DeleteCartItemUsecase(
                              CartRepositoryImpl(
                                remoteDataSource: CartRemoteDataSourceImpl(),
                              ),
                            );
                        try {
                          await useCase.call(
                            addToCartId: item!.addToCartId!,
                            itemId: item.id!,
                          );
                        } catch (e) {
                          Get.back();
                          Get.snackbar(
                            'Gagal menghapus produk',
                            'Terjadi kesalahan saat menghapus produk.',
                            backgroundColor: AppColors.red,
                            colorText: AppColors.white,
                          );
                          return;
                        }

                        selectedItems.remove(itemId);
                        itemQuantities.remove(itemId);
                        selectedItems.refresh();
                        itemQuantities.refresh();
                        await fetchCart();
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
