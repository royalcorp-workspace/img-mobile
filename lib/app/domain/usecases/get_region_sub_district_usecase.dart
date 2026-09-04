import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/sub_district_entity.dart';
import 'package:img/app/domain/repositories/region_repository.dart';

class GetRegionSubDistrictUsecase {
  final RegionRepository repository;

  GetRegionSubDistrictUsecase(this.repository);

  Future<PaginatedEntity<SubDistrictEntity>> call({
    required String cityID,
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getSubDistrict(
      page: page,
      itemsPerPage: itemsPerPage,
      cityID: cityID,
    );
  }
}
