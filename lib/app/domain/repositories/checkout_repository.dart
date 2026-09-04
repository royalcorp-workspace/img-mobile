import 'package:img/app/data/models/checkout_params_model.dart';
import 'package:img/app/domain/entities/checkout_entity.dart';

abstract class CheckoutRepository {
  Future<CheckoutEntity> checkout(CheckoutParamsModel params);
}
