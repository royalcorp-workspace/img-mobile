import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';

import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ProductPaginatedEntity> getProducts({
    int page = 1,
    int itemsPerPage = 10,
  });
  Future<ProductByIdEntity> getProudctByID(String productID);
}
