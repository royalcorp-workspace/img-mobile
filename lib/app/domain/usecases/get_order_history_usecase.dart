import 'package:pos_royal/app/domain/entities/order_history_entity.dart';
import 'package:pos_royal/app/domain/entities/paginated_entity.dart';
import 'package:pos_royal/app/domain/repositories/order_repository.dart';

class GetOrderHistoryUsecase {
  final OrderRepository repository;

  GetOrderHistoryUsecase(this.repository);

  Future<PaginatedEntity<OrderHistoryEntity>> call({
    required String customerId,
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return repository.getOrderHistory(
      customerId: customerId,
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
