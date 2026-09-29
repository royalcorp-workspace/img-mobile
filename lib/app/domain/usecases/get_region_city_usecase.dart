import 'package:img/app/domain/entities/city_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/repositories/region_repository.dart';

class GetRegionCityUsecase {
  final RegionRepository repository;

  GetRegionCityUsecase(this.repository);

  Future<PaginatedEntity<CityEntity>> call({
    required String provincyID,
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getCity(
      page: page,
      itemsPerPage: itemsPerPage,
      provincyID: provincyID,
    );
  }
}
