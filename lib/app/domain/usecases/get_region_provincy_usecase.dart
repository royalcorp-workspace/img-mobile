import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/entities/provincy_entity.dart';
import 'package:pos_royal/app/domain/repositories/region_repository.dart';

class GetRegionProvincyUsecase {
  final RegionRepository repository;

  GetRegionProvincyUsecase(this.repository);

  Future<PaginatedEntity<ProvincyEntity>> call({
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getProvincy(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
