import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<OrderEntity> call(CreateOrderParams params) {
    return repository.createOrder(params);
  }
}
