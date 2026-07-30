import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';
import 'package:pos_royal/app/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<PaginatedEntity<ProductEntity>> getProducts({
    int page = 1,
    int itemsPerPage = 10,
  });
  Future<ProductByIdEntity> getProudctByID(String productID);
}
