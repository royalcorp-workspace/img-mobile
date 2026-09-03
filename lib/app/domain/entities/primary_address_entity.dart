class PrimaryAddressEntity {
  final String createdAt;
  final String updatedAt;
  final String name;
  final String email;
  final String phone;
  final dynamic meta;
  final String id;
  final String userId;
  final List<dynamic> addresses;

  PrimaryAddressEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.email,
    required this.phone,
    required this.meta,
    required this.id,
    required this.userId,
    required this.addresses,
  });
}
