import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<OrderEntity> createOrder(CreateOrderParams params);
}
