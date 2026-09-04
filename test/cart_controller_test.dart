import 'package:flutter_test/flutter_test.dart';
import 'package:img/app/domain/entities/add_to_cart_entity.dart';
import 'package:img/app/domain/entities/cart_entity.dart';
import 'package:img/app/modules/cart/controllers/cart_controller.dart';

void main() {
  group('CartController selection logic', () {
    test('selectedTotalPrice sums only selected items and their quantities',
        () {
      final controller = CartController();
      controller.carts.value = [
        CartEntity(
          items: [
            ItemCart(id: 'a', quantity: 2, unitPrice: 100000, total: 200000),
            ItemCart(id: 'b', quantity: 3, unitPrice: 50000, total: 150000),
            ItemCart(id: 'c', quantity: 1, unitPrice: 75000, total: 75000),
          ],
        ),
      ];

      controller.selectedItems['a'] = true;
      controller.selectedItems['c'] = true;
      controller.itemQuantities['a'] = 2;
      controller.itemQuantities['b'] = 3;
      controller.itemQuantities['c'] = 1;

      expect(controller.selectedTotalPrice, 275000);
      expect(controller.selectedCartItems.length, 2);
      expect(controller.hasSelectedItems, isTrue);
    });

    test('toggleItemSelection and quantity updates do not leak across items',
        () {
      final controller = CartController();
      controller.carts.value = [
        CartEntity(
          items: [
            ItemCart(id: 'a', quantity: 2, unitPrice: 100000, total: 200000),
            ItemCart(id: 'b', quantity: 1, unitPrice: 50000, total: 50000),
          ],
        ),
      ];

      controller.toggleItemSelection('a', true);
      controller.incrementQty('a');
      controller.incrementQty('b');

      expect(controller.isItemSelected('a'), isTrue);
      expect(controller.isItemSelected('b'), isFalse);
      expect(controller.getItemQuantity('a'), 3);
      expect(controller.getItemQuantity('b'), 2);
      expect(controller.selectedTotalPrice, 300000);
    });

    test('cartItemCount aggregates the total number of items from all carts',
        () {
      final controller = CartController();
      controller.carts.value = [
        CartEntity(
          items: [
            ItemCart(id: 'a', quantity: 2, unitPrice: 100000, total: 200000),
            ItemCart(id: 'b', quantity: 1, unitPrice: 50000, total: 50000),
          ],
        ),
        CartEntity(
          items: [
            ItemCart(id: 'c', quantity: 3, unitPrice: 40000, total: 120000),
          ],
        ),
      ];

      expect(controller.cartItemCount, 6);
    });
  });
}
