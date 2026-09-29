import 'package:img/app/domain/entities/category_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';

abstract class CategoryRepository {
  Future<PaginatedEntity<CategoryEntity>> getCategory({
    int page = 1,
    int itemsPerPage = 10,
  });
}
