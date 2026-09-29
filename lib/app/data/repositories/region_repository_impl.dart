import 'package:img/app/data/datasources/region_remote_datasource.dart';
import 'package:img/app/domain/entities/city_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';
import 'package:img/app/domain/entities/provincy_entity.dart';
import 'package:img/app/domain/entities/sub_district_entity.dart';
import 'package:img/app/domain/repositories/region_repository.dart';

class RegionRepositoryImpl implements RegionRepository {
  final RegionRemoteDataSourceImpl remoteDataSource;

  RegionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedEntity<ProvincyEntity>> getProvincy(
      {int page = 1, int itemsPerPage = 10}) {
    return remoteDataSource.getProvinces(
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }

  @override
  Future<PaginatedEntity<CityEntity>> getCity(
      {int page = 1, int itemsPerPage = 10, required String provincyID}) {
    return remoteDataSource.getCity(
      page: page,
      itemsPerPage: itemsPerPage,
      provincyID: provincyID,
    );
  }

  @override
  Future<PaginatedEntity<SubDistrictEntity>> getSubDistrict(
      {int page = 1, int itemsPerPage = 10, required String cityID}) {
    return remoteDataSource.getSubDistrict(
      page: page,
      itemsPerPage: itemsPerPage,
      cityID: cityID,
    );
  }
}
