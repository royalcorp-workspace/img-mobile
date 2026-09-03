import '../entities/homepage_content_entity.dart';
import '../entities/paginated_entity.dart';
import '../repositories/homepage_content_repository.dart';

class GetHomepageContentUsecase {
  final HomepageContentRepository repository;

  GetHomepageContentUsecase(this.repository);

  Future<PaginatedEntity<HomepageContentSectionEntity>> call() {
    return repository.getHomepageContent();
  }
}
