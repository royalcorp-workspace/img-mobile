import 'package:pos_royal/app/data/datasources/cart_remote_datasource.dart';
import 'package:pos_royal/app/domain/entities/add_to_cart_entity.dart';
import 'package:pos_royal/app/domain/entities/cart_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AddToCartEntity> addToCart(AddToCartEntityParams params) {
    return remoteDataSource.addToCart(params.toJson());
  }

  @override
  Future<void> deleteCartItem({
    required String addToCartId,
    required String itemId,
  }) {
    return remoteDataSource.deleteCartItem(
      addToCartId: addToCartId,
      itemId: itemId,
    );
  }

  @override
  Future<PaginatedEntity<CartEntity>> getCart(
      {int page = 1, int itemsPerPage = 10}) {
    return remoteDataSource.getCart(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
