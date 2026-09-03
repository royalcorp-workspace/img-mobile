import 'package:pos_royal/app/domain/repositories/cart_repository.dart';

class DeleteCartItemUsecase {
  final CartRepository repository;

  DeleteCartItemUsecase(this.repository);

  Future<void> call({
    required String addToCartId,
    required String itemId,
  }) {
    return repository.deleteCartItem(
      addToCartId: addToCartId,
      itemId: itemId,
    );
  }
}
