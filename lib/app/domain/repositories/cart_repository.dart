import 'package:pos_royal/app/domain/entities/add_to_cart_entity.dart';
import 'package:pos_royal/app/domain/entities/cart_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';

abstract class CartRepository {
  Future<AddToCartEntity> addToCart(AddToCartEntityParams params);
  Future<PaginatedEntity<CartEntity>> getCart({
    int page = 1,
    int itemsPerPage = 10,
  });
}
