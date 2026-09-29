import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<PaginatedEntity<ProductEntity>> call({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getProducts(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
