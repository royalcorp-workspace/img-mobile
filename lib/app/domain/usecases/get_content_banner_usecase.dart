import 'package:img/app/domain/entities/content_banner_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/repositories/homepage_content_repository.dart';

class GetContentBannerUsecase {
  final HomepageContentRepository repository;

  GetContentBannerUsecase(this.repository);

  Future<PaginatedEntity<ContentBannerEntity>> call() async {
    return repository.getContentBanner();
  }
}
