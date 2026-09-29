import 'package:img/app/domain/entities/add_to_cart_entity.dart';
import 'package:img/app/domain/repositories/cart_repository.dart';

class AddToCartUsecase {
  final CartRepository repository;

  AddToCartUsecase(this.repository);

  Future<AddToCartEntity> call(AddToCartEntityParams params) {
    return repository.addToCart(params);
  }
}
