import 'address_model.dart';

class AddressRequest {
  final String? address;
  final String? cityId;
  final bool? isPrimary;
  final String? label;
  final String? phone;
  final String? postalCode;
  final String? recipientName;
  final String? subDistrictId;

  AddressRequest({
    this.address,
    this.cityId,
    this.isPrimary,
    this.label,
    this.phone,
    this.postalCode,
    this.recipientName,
    this.subDistrictId,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city_id': cityId,
      'is_primary': isPrimary ?? false,
      'label': label,
      'phone': phone,
      'postal_code': postalCode,
      'recipient_name': recipientName,
      'sub_district_id': subDistrictId,
    };
  }

  factory AddressRequest.fromAddressModel(AddressModel model, {bool? overrideIsPrimary}) {
    return AddressRequest(
      address: model.address,
      cityId: model.cityId,
      isPrimary: overrideIsPrimary ?? model.isPrimary,
      label: model.label,
      phone: model.phone,
      postalCode: model.postalCode,
      recipientName: model.recipientName,
      subDistrictId: model.subDistrictId,
    );
  }
}

class CustomerUpdateRequest {
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;
  final List<AddressRequest>? addresses;

  CustomerUpdateRequest({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.addresses,
  });

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'addresses': addresses?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}
