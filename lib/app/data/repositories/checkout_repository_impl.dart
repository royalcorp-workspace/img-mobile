import 'package:pos_royal/app/data/datasources/checkout_remote_datasource.dart';
import 'package:pos_royal/app/data/models/checkout_params_model.dart';
import 'package:pos_royal/app/domain/entities/checkout_entity.dart';
import 'package:pos_royal/app/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CheckoutEntity> checkout(CheckoutParamsModel params) {
    return remoteDataSource.checkout(params);
  }
}
