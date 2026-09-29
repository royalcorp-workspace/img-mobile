import 'package:img/app/domain/entities/product_tag_entity.dart';
import '../repositories/product_repository.dart';

class GetProductTagsUseCase {
  final ProductRepository repository;

  GetProductTagsUseCase(this.repository);

  Future<List<ProductTagEntity>> call() {
    return repository.getProductTags();
  }
}
