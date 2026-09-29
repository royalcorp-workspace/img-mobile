import 'package:img/app/domain/entities/city_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/provincy_entity.dart';
import 'package:img/app/domain/entities/sub_district_entity.dart';

abstract class RegionRepository {
  Future<PaginatedEntity<ProvincyEntity>> getProvincy({
    int page = 1,
    int itemsPerPage = 10,
  });
  Future<PaginatedEntity<CityEntity>> getCity({
    int page = 1,
    int itemsPerPage = 10,
    required String provincyID,
  });
  Future<PaginatedEntity<SubDistrictEntity>> getSubDistrict({
    int page = 1,
    int itemsPerPage = 10,
    required String cityID,
  });
}
