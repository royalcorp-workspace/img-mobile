import 'package:img/app/domain/entities/order_history_entity.dart';
import 'package:img/app/domain/entities/paginated_entity.dart';

import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<OrderEntity> createOrder(CreateOrderParams params);
  Future<PaginatedEntity<OrderHistoryEntity>> getOrderHistory({
    required String customerId,
    int page = 1,
    int itemsPerPage = 10,
  });
}
