import 'package:pos_royal/app/data/models/checkout_params_model.dart';
import 'package:pos_royal/app/domain/entities/checkout_entity.dart';
import 'package:pos_royal/app/domain/repositories/checkout_repository.dart';

class CheckoutUsecase {
  final CheckoutRepository repository;

  CheckoutUsecase(this.repository);

  Future<CheckoutEntity> call(CheckoutParamsModel params) {
    return repository.checkout(params);
  }
}
