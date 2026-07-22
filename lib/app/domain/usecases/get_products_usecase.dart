import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<ProductPaginatedEntity> call({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getProducts(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
