import 'package:pos_royal/app/domain/entities/order_history_entity.dart';

import 'package:pos_royal/app/domain/entities/paginated_entity.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderEntity> createOrder(CreateOrderParams params) {
    return remoteDataSource.createOrder(params.toJson());
  }

  @override
  Future<PaginatedEntity<OrderHistoryEntity>> getOrderHistory({
    required String customerId,
    int page = 1,
    int itemsPerPage = 10,
  }) {
    return remoteDataSource.getOrderHistory(
      customerId: customerId,
      page: page,
      itemsPerPage: itemsPerPage,
    );
  }
}
