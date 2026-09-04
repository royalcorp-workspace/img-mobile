import 'package:img/app/domain/entities/product_by_id_entity.dart';
import 'package:img/app/domain/repositories/product_repository.dart';

class GetProductByIdUsecase {
  final ProductRepository repository;

  GetProductByIdUsecase(this.repository);

  Future<ProductByIdEntity> call(String productID) {
    return repository.getProudctByID(productID);
  }
}
