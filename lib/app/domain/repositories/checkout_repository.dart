import 'package:pos_royal/app/data/models/checkout_params_model.dart';
import 'package:pos_royal/app/domain/entities/checkout_entity.dart';

abstract class CheckoutRepository {
  Future<CheckoutEntity> checkout(CheckoutParamsModel params);
}
