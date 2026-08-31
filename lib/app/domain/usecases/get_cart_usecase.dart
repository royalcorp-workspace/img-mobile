import 'package:pos_royal/app/domain/entities/cart_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/repositories/cart_repository.dart';

class GetCartUsecase {
  final CartRepository repository;

  GetCartUsecase(this.repository);

  Future<PaginatedEntity<CartEntity>> call({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getCart(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
