import 'package:img/app/domain/entities/add_to_cart_entity.dart';
import 'package:img/app/domain/entities/cart_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';

abstract class CartRepository {
  Future<AddToCartEntity> addToCart(AddToCartEntityParams params);
  Future<void> deleteCartItem({
    required String addToCartId,
    required String itemId,
  });
  Future<PaginatedEntity<CartEntity>> getCart({
    int page = 1,
    int itemsPerPage = 10,
  });
}
