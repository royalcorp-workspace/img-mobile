import 'package:img/app/domain/entities/content_event_active_entity.dart';
import 'package:img/app/domain/entities/content_banner_entity.dart';

import '../entities/homepage_content_entity.dart';
import '../entities/paginated_entity.dart';

abstract class HomepageContentRepository {
  Future<PaginatedEntity<ContentBannerEntity>> getContentBanner();
  Future<PaginatedEntity<HomepageContentSectionEntity>> getHomepageContent();
  Future<ContentEventActiveEntity> getContentEventActive();
}
