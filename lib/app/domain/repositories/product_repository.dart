import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ProductPaginatedEntity> getProducts({
    int page = 1,
    int itemsPerPage = 10,
  });
}
