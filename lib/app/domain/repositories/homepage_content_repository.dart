import '../entities/homepage_content_entity.dart';
import '../entities/paginated_entity.dart';

abstract class HomepageContentRepository {
  Future<PaginatedEntity<HomepageContentSectionEntity>> getHomepageContent();
}
