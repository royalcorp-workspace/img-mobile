import '../entities/order_tracking_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderDetailUsecase {
  final OrderRepository repository;

  GetOrderDetailUsecase(this.repository);

  Future<OrderTrackingEntity> call(String orderId) {
    return repository.getOrderTracking(orderId);
  }
}
