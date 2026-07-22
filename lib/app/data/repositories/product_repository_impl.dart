import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProductPaginatedEntity> getProducts({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return remoteDataSource.getProducts(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
