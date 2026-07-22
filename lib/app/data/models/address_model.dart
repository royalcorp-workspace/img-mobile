class AddressModel {
  final String? id;
  final String? userId;
  final String? cityId;
  final String? subDistrictId;
  final String? label;
  final String? recipientName;
  final String? phone;
  final String? address;
  final String? postalCode;
  final bool? isPrimary;
  final String? createdAt;
  final String? updatedAt;

  AddressModel({
    this.id,
    this.userId,
    this.cityId,
    this.subDistrictId,
    this.label,
    this.recipientName,
    this.phone,
    this.address,
    this.postalCode,
    this.isPrimary,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      cityId: json['city_id'] as String?,
      subDistrictId: json['sub_district_id'] as String?,
      label: json['label'] as String?,
      recipientName: json['recipient_name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      postalCode: json['postal_code'] as String?,
      isPrimary: json['is_primary'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'city_id': cityId,
      'sub_district_id': subDistrictId,
      'label': label,
      'recipient_name': recipientName,
      'phone': phone,
      'address': address,
      'postal_code': postalCode,
      'is_primary': isPrimary,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
