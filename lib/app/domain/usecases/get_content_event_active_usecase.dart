import 'package:img/app/domain/entities/content_event_active_entity.dart';
import 'package:img/app/domain/repositories/homepage_content_repository.dart';

class GetContentEventActiveUsecase {
  final HomepageContentRepository repository;

  GetContentEventActiveUsecase(this.repository);

  Future<ContentEventActiveEntity> call() async {
    return repository.getContentEventActive();
  }
}
