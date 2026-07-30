import 'package:pos_royal/app/domain/entities/category_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/repositories/category_repository.dart';

class GetCategoryUsecase {
  final CategoryRepository repository;

  GetCategoryUsecase(this.repository);

  Future<PaginatedEntity<CategoryEntity>> call({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getCategory(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
