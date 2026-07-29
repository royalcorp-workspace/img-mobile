import 'package:pos_royal/app/data/models/shipping_addresses_model.dart';

class ShippingAddressesPaginatedEntity {
  final List<ShippingAddressesModel> data;
  final int totalCount;
  final bool hasMore;
  final int page;
  final int itemsPerPage;

  ShippingAddressesPaginatedEntity({
    required this.data,
    required this.totalCount,
    required this.hasMore,
    required this.page,
    required this.itemsPerPage,
  });
}

class ShippingAddressesEntity {
  final String createdAt;
  final String updatedAt;
  final String courierId;
  final String subDistrictId;
  final int type;
  final double price;
  final bool isActive;
  final int sortOrder;
  final String id;
  final CourierModel courier;

  ShippingAddressesEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.courierId,
    required this.subDistrictId,
    required this.type,
    required this.price,
    required this.isActive,
    required this.sortOrder,
    required this.id,
    required this.courier,
  });
}

class CourierEntity {
  final String id;
  final String code;
  final String name;
  final int type;
  final bool isActive;
  final int sortOrder;

  CourierEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.isActive,
    required this.sortOrder,
  });
}
