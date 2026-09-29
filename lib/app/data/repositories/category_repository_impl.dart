import 'package:img/app/data/datasources/category_remote_datasource.dart';
import 'package:img/app/domain/entities/category_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedEntity<CategoryEntity>> getCategory({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return remoteDataSource.getCategory(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
