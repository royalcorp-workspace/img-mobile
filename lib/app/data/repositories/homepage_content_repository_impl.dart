import 'package:pos_royal/app/data/datasources/homepage_content_remote_datasource.dart';
import 'package:pos_royal/app/domain/entities/homepage_content_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/repositories/homepage_content_repository.dart';

class HomepageContentRepositoryImpl implements HomepageContentRepository {
  final HomepageContentRemoteDataSource remoteDataSource;

  HomepageContentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedEntity<HomepageContentSectionEntity>> getHomepageContent() {
    return remoteDataSource.getHomepageContent();
  }
}
